module Xrate
  require "xrate/rate"
  require "xrate/exchange_rate"
  require "xrate/unconvertable_currency_exception"
  require "xrate/railtie" if defined?(Rails)
end
