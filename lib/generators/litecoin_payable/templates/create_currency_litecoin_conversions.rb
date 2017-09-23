class CreateCurrencyLitecoinConversions < ActiveRecord::Migration
  def change
    create_table :currency_litecoin_conversions do |t|
      t.float "currency"
      t.integer "ltc"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
