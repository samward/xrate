ActiveRecord::Schema.define do
  self.verbose = false

  create_table :xrate_exchange_rates do |t|
    t.string   :currency, null: false
    t.decimal  :rate, null: false
    t.date     :date, null: false
    t.timestamps
  end
end
