require "active_record"

module Xrate
  class Rate < ActiveRecord::Base
    self.table_name = "xrate_exchange_rates"
    default_scope { order(date: :desc) }

    validates :currency, uniqueness: { scope: :date }
    validates :currency, :rate, :date, presence: true
  end
end
