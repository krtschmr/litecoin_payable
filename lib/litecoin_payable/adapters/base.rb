module LitecoinPayable::Adapters
  class Base

    def self.fetch_adapter
      case LitecoinPayable.config.adapter
      when "blockchain_info"
        LitecoinPayable::Adapters::BlockchainInfoAdapter.new
      when "blockcypher"
        LitecoinPayable::Adapters::BlockcypherAdapter.new
      else
        raise "Please specify an adapter"
      end
    end

  end
end
