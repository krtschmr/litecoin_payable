require 'rails/generators'
require 'rails/generators/active_record'

module LitecoinPayable
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates (but does not run) a migration to add a litecoin payment tables.'

    def create_migration_file
      migration_template 'create_litecoin_payments.rb', 'db/migrate/create_litecoin_payments.rb'
      migration_template 'create_litecoin_payment_transactions.rb', 'db/migrate/create_litecoin_payment_transactions.rb'
      migration_template 'create_currency_litecoin_conversions.rb', 'db/migrate/create_currency_litecoin_conversions.rb'
      migration_template 'add_ltc_conversion_to_litecoin_payments.rb', 'db/migrate/add_ltc_conversion_to_litecoin_payments.rb'
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
