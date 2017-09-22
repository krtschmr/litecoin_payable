require 'net/http'
require 'litecoin_payable/config'
require 'litecoin_payable/version'
require 'litecoin_payable/has_litecoin_payment'
require 'litecoin_payable/tasks'
require 'litecoin_payable/litecoin_calculator'

require 'blockcypher'
require 'litecoin_payable/adapters/base'
require 'litecoin_payable/adapters/blockcypher_adapter'
require 'litecoin_payable/adapters/blockchain_info_adapter'

module LitecoinPayable
  def self.config
    @@config ||= LitecoinPayable::Config.instance
  end
end

require 'litecoin_payable/litecoin_payment_transaction'
require "litecoin_payable/address"
require 'litecoin_payable/litecoin_payment'

require 'litecoin_payable/currency_conversion'

ActiveSupport.on_load(:active_record) do
  include LitecoinPayable::Model
end
