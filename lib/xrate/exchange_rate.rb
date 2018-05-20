require "xrate/version"
require "bigdecimal"
require "unconvertable_currency_exception"

module Xrate
  class ExchangeRate
    def self.at(date, from_currency, target_currency)
      date_range = (date - fallback_days)..date
      get_latest(date_range, from_currency, target_currency) or
        raise Xrate::UnconvertableCurrencyException
    end

    def self.get_latest(date_range, from_currency, target_currency)
      if from_currency == ENV.fetch("XRATE_BASE_CURRENCY")
        Xrate::Rate.where(date: date_range, currency: target_currency).first&.rate
      else
        calculate_rate(date_range, from_currency, target_currency)
      end
    end

    def self.calculate_rate(date_range, from_currency, target_currency)
      begin
        base_to_from = Xrate::Rate.where(date: date_range, currency: from_currency).first&.rate
        base_to_target = Xrate::Rate.where(date: date_range, currency: target_currency).first&.rate

        base_to_target / base_to_from
      rescue NoMethodError # handle divide by zero
        nil
      end
    end

    def self.fallback_days
      ENV.fetch("XRATE_FALLBACK_DAYS").to_i
    end
  end
end
