module LitecoinPayable
    class PricingProcessor

      def self.perform
        new.perform
      end

      def initialize
      end

      def perform
        # => Store three previous price ranges
        # => get_currency TODO: enable this again
        # => Defaulting to 1.00 for now
        rate = CurrencyConversion.create!(currency: 1.00, ltc: get_ltc)

        # => Loop through all unpaid payments and update them with the new price
        # => If it has been 20 mins since they have been updated
        LitecoinPayable::LitecoinPayment.where(state: ['pending', 'partial_payment']).where("updated_at < ? OR ltc_amount_due = 0", 30.minutes.ago).each do |bp|
          bp.update_attributes!(ltc_amount_due: bp.calculate_ltc_amount_due, ltc_conversion: rate.ltc)
        end
      end

      def get_ltc

        uri = URI.parse("https://apiv2.bitcoinaverage.com/indices/local/ticker/LTC#{LitecoinPayable.config.currency.to_s.upcase}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request)
        hash = JSON.parse(response.body)
        hash["averages"]["day"].to_f * 100.00
      end

      def get_currency
        #uri = URI("http://rate-exchange.appspot.com/currency?from=#{LitecoinPayable.config.currency}&to=USD")
        #rate = JSON.parse(Net::HTTP.get(uri))["rate"]

        uri = URI("http://openexchangerates.org/api/latest.json?app_id=#{LitecoinPayable.config.open_exchange_key}")
        response = JSON.parse(Net::HTTP.get(uri))
        response["rates"][LitecoinPayable.config.currency.to_s.upcase]
      end
    end
end
