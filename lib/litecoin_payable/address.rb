module LitecoinPayable
  class Address

    def self.create(id)
      if LitecoinPayable.config.master_public_key
        master = MoneyTree::Node.from_serialized_address LitecoinPayable.config.master_public_key
        node = master.node_for_path LitecoinPayable.config.node_path + id.to_s
      else
        raise "MASTER_SEED or MASTER_PUBLIC_KEY is required"
      end

      node.to_address(network: LitecoinPayable.config.network)
    end

  end
end
