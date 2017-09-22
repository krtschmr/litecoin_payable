module LitecoinPayable
  class PaymentProcessor
    def self.perform
      new.perform
    end

    def initialize
    end

    def perform
      LitecoinPayable::LitecoinPayment.where(state: [:pending, :partial_payment]).each do |payment|
        # => Check for completed payment first, incase it's 0 and we don't need to make an API call
        # => Preserve API calls
        check_paid(payment)

        unless payment.paid_in_full?
          begin
            adapter = LitecoinPayable::Adapters::Base.fetch_adapter

            adapter.fetch_transactions_for_address(payment.address).each do |tx|
              tx.symbolize_keys!

              unless payment.transactions.find_by_transaction_hash(tx[:txHash])
                payment.transactions.create!(
                  estimated_value: tx[:estimatedTxValue],
                  transaction_hash: tx[:txHash],
                  block_hash: tx[:blockHash],
                  block_time: (Time.at(tx[:blockTime]) if tx[:blockTime]),
                  estimated_time: (Time.at(tx[:estimatedTxTime]) if tx[:estimatedTxTime]),
                  ltc_conversion: payment.ltc_conversion
                )

                payment.update(ltc_amount_due: payment.calculate_ltc_amount_due, ltc_conversion: LitecoinPayable::CurrencyConversion.last.ltc)
              end
            end

            # => Check for payments after the response comes back
            check_paid(payment)

          rescue JSON::ParserError
            puts "Error processing response from server.  Possible API issue or your Quota has been exceeded"
          end
        end
        
      end
    end

    protected

    def check_paid(payment)
      if payment.currency_amount_paid >= payment.price
        payment.paid
      elsif payment.currency_amount_paid > 0
         payment.partially_paid
      end
    end

  end

end