module LitecoinPayable
  class CurrencyConversion < ::ActiveRecord::Base
    validates :ltc, presence: true
  end
end