require "xrate/version"
require "bigdecimal"
require "unconvertable_currency_exception"

module Xrate
  class ExchangeRate
    def self.at(date, from, target)
      get_rate_at(date, from, target) or
        raise Xrate::UnconvertableCurrencyException
    end

    def self.get_rate_at(date, from, target)
      if from == ENV.fetch("XRATE_BASE_CURRENCY")
        Xrate::Rate.where(date: date, currency: target).first&.rate
      else
        calculate_rate(date, from, target)
      end
    end

    def self.calculate_rate(date, from, target)
      begin
        base_to_from = Xrate::Rate.where(date: date, currency: from).first&.rate
        base_to_target = Xrate::Rate.where(date: date, currency: target).first&.rate

        base_to_target / base_to_from
      rescue NoMethodError # handle divide by zero
        nil
      end
    end
  end
end
