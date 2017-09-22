module LitecoinPayable
  class LitecoinCalculator
    def self.convert_satoshis_to_litecoin(satoshis)
      satoshis * 0.00000001
    end

    def self.convert_litecoins_to_satoshis(litecoins)
      litecoins / 0.00000001
    end

    def self.exchange_price(price, exchange_rate)
      (price.to_f / exchange_rate.to_f).round(8)
    end
  end
end