#require 'litecoin-addrgen'
require 'money-tree'
require 'state_machine'

module LitecoinPayable
  class LitecoinPayment < ::ActiveRecord::Base

    belongs_to :payable, polymorphic: true
    has_many :transactions, class_name: LitecoinPayable::LitecoinPaymentTransaction

    validates :reason, presence: true
    validates :price, presence: true

    before_create :populate_currency_and_amount_due
    after_create :populate_address

    state_machine :state, initial: :pending do
      state :pending
      state :partial_payment
      state :paid_in_full
      state :comped

      event :paid do
        transition [:pending, :partial_payment] => :paid_in_full
      end

      after_transition :on => :paid, :do => :notify_payable

      event :partially_paid do
        transition :pending => :partial_payment
      end

      event :comp do
        transition [:pending, :partial_payment] => :comped
      end

      after_transition :on => :comp, :do => :notify_payable
    end

    def currency_amount_paid
      # => Round to 0 decimal places so there aren't any partial cents
      self.transactions.inject(0) { |sum, tx| sum + (LitecoinPayable::LitecoinCalculator.convert_satoshis_to_litecoin(tx.estimated_value) * tx.ltc_conversion) }.round(0)
    end

    def currency_amount_due
      self.price - currency_amount_paid
    end

    def calculate_ltc_amount_due
      ltc_rate = LitecoinPayable::CurrencyConversion.last.ltc
      LitecoinPayable::LitecoinCalculator.exchange_price currency_amount_due, ltc_rate
    end

    private

    def populate_currency_and_amount_due
      self.currency ||= LitecoinPayable.config.currency
      self.ltc_amount_due = calculate_ltc_amount_due
      self.ltc_conversion = LitecoinPayable::CurrencyConversion.last.ltc
    end

    def populate_address
      self.update_attributes(address: Address.create(self.id))
    end

    def notify_payable
      if self.payable.respond_to?(:litecoin_payment_paid)
        self.payable.litecoin_payment_paid
      end
    end

  end
end
