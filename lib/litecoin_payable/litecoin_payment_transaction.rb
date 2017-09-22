module LitecoinPayable
  class LitecoinPaymentTransaction < ::ActiveRecord::Base

    belongs_to :litecoin_payment

  end
end