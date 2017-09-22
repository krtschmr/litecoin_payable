class AddLtcConversionToLitecoinPayments < ActiveRecord::Migration
  def change
    add_column :litecoin_payments, :ltc_conversion, :integer
  end
end