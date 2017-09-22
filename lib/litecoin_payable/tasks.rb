require 'rake'
require 'litecoin_payable/commands/pricing_processor'
require 'litecoin_payable/commands/payment_processor'

namespace :litecoin_payable do

  desc "Process the prices and update the payments"
  task :process_prices => :environment do
    LitecoinPayable::PricingProcessor.perform
  end

  desc "Connect to HelloBlock.io and process payments"
  task :process_payments => :environment do
    LitecoinPayable::PaymentProcessor.perform
  end

end