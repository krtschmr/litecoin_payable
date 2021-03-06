class CreateLitecoinPayments < ActiveRecord::Migration
  def change
    create_table :litecoin_payments do |t|
      t.string   :payable_type
      t.integer  :payable_id
      t.string   :currency
      t.string   :reason
      t.integer  :price
      t.float    :ltc_amount_due, default: 0
      t.string   :address
      t.string   :state
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :litecoin_payments, [:payable_type, :payable_id]
  end
end