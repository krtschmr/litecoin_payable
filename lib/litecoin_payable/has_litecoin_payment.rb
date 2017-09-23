module LitecoinPayable
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def has_litecoin_payments(options = {})
        has_many :litecoin_payments, class_name: LitecoinPayable::LitecoinPayment, as: 'payable'
      end

    end
  end
end
