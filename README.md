# LitecoinPayable

Forked and transported from https://github.com/Sailias/bitcoin_payable

A rails gem that enables any model to have Litecoin payments.
The polymorphic table litecoin_payments creates payments with unique addresses based on a BIP32 deterministic seed using https://github.com/wink/money-tree
and uses the (https://helloblock.io OR https://blockchain.info/) API to check for payments.

Payments have 4 states:  `pending`, `partial_payment`, `paid_in_full`, `comped`

No private keys needed, No litecoind blockchain indexing on new servers, just address and payments.


## Installation

Add this line to your application's Gemfile:  

    gem 'litecoin_payable', git: 'https://github.com/krtschmr/litecoin_payable', branch: 'master'

And then execute:

    $ bundle

    $ rails g litecoin_payable:install

    $ bundle exec rake db:migrate

Or install it yourself as:

    $ gem install litecoin_payable

## Usage

### Configuration

config/initializers/litecoin_payable.rb

    LitecoinPayable.config.currency = :eur
    LitecoinPayable.config.node_path = "m/0/"
    LitecoinPayable.config.master_public_key = ENV["MASTER_PUBLIC_KEY"]
    LitecoinPayable.config.testnet = true
    LitecoinPayable.config.adapter = "blockchain_info"

#### Node Path

The derivation path for the node that will be creating your addresses

#### Master Public Key

A BIP32 MPK in "Extended Key" format.

Public net starts with: xpub
Testnet starts with: tpub

### Adding it to your model

    class Product < ActiveRecord::Base
      has_litecoin_payments
    end

### Creating a payment from your application

    def create_payment(amount_in_cents)
      self.litecoin_payments.create!(reason: 'sale', price: amount_in_cents)
    end

### Update payments with the current price of BTC based on your currency

LitecoinPayable also supports local currency conversions and BTC exchange rates.

The `process_prices` rake task connects to api.litecoinaverage.com to get the 24 hour weighted average of BTC for your specified currency.
It then updates all payments that havent received an update in the last 30 minutes with the new value owing in BTC.
This *honors* the price of a payment for 30 minutes at a time.

`rake litecoin_payable:process_prices`

### Processing payments

All payments are calculated against the dollar amount of the payment.  So a `litecoin_payment` for $49.99 will have it's value calculated in BTC.
It will stay at that price for 30 minutes.  When a payment is made, a transaction is created that stores the BTC in satoshis paid, and the exchange rate is was paid at.
This is very valuable for accounting later.  (capital gains of all payments received)

If a partial payment is made, the BTC value is recalculated for the remaining *dollar* amount with the latest exchange rate.
This means that if someone pays 0.01 for a 0.5 payment, that 0.01 is converted into dollars at the time of processing and the
remaining amount is calculated in dollars and the remaining amount in BTC is issued.  (If BTC bombs, that value could be greater than 0.5 now)

This prevents people from gaming the payments by paying very little BTC in hopes the price will rise.
Payments are not recalculated based on the current value of BTC, but in dollars.

To run the payment processor:

`rake litecoin_payable:process_payments`

### Notify your application when a payment is made

Use the `litecoin_payment_paid` method

    def Product < ActiveRecord::Base
      has_litecoin_payments

      def create_payment(amount_in_cents)
        self.litecoin_payments.create!(reason: 'sale', price: amount_in_cents)
      end

      def litecoin_payment_paid
        self.ship!
      end
    end

### Comp a payment

This will bypass the payment, set the state to comped and call back to your app that the payment has been processed.

`@litecoin_payment.comp`

### View all the transactions in the payment

    litecoin_payment = @product.litecoin_payments.first
    litecoin_payment.transactions.each do |transaction|
      puts transaction.block_hash
      puts transaction.block_time

      puts transaction.transaction_hash

      puts transaction.estimated_value
      puts transaction.estimated_time

      puts transaction.ltc_conversion
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
