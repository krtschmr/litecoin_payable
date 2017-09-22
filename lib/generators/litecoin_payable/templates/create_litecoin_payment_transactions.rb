class CreateLitecoinPaymentTransactions < ActiveRecord::Migration
  def change
    create_table :litecoin_payment_transactions do |t|
      t.integer :estimated_value
      t.string :transaction_hash
      t.string :block_hash
      t.datetime :block_time
      t.datetime :estimated_time
      t.integer :litecoin_payment_id
      t.integer :ltc_conversion
    end

    add_index :litecoin_payment_transactions, :litecoin_payment_id
  end
end