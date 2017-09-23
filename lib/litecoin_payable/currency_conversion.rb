module LitecoinPayable
  class CurrencyConversion < ::ActiveRecord::Base
    self.table_name = "currency_litecoin_conversions"
    validates :ltc, presence: true
  end
end
