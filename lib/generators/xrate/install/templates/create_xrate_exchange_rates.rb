class CreateXrateExchangeRates < ActiveRecord::Migration
  def change
    create_table :xrate_exchange_rates do |t|
      t.string   :currency, null: false
      t.decimal  :rate, null: false
      t.date     :date, null: false
      t.timestamps
    end
    add_index :xrate_exchange_rates, [:date, :currency]
  end
end
