# Xrate
Xrate is a gem for Rails which provides historic exchange rate lookups against a base currency.

This gem uses the European Central Bank 90 day historic rate feed as a source, but other sources can be used by storing the rates by creating Rate objects:

`Xrate:Rate.create(date: Date.today, currency: "GBP", rate: 0.555)`

Xrate will raise an exception if the conversion cannot be carried out due to lack of data.  You should plan to gracefully handle UnconvertableCurrencyExceptions in your app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "xrate"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xrate

Xrate stores a cache of the current exhange rates in the database and assumes `ActiveRecord` is present.  To generate the migration for this table, run `rails generate xrate:install` and `rails db:migrate` to run the migration.

Xrate assumes that all rates will be against a base currency defined in the environment variable "XRATE_BASE_CURRENCY".

## Usage
To get the last 90 days of exhange rate data from the [European Central Bank](http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml), run `rake xrate:import`.  This can be run on a regular basis to keep your rate cache up to date.  Note, Xrate will always take the last import as correct, overwriting any previous stored rates.

Lookups are made by running `Xrate::ExchangeRate.at({date}, {source}, {target})`

### Example
To find out the how much £1 was worth in USD the day before brexit, you would run:

`Xrate::ExchangeRate.at("2016-06-22", "GBP", "USD")`

Xrate returns rates in [BigDecimal](https://ruby-doc.org/stdlib/libdoc/bigdecimal/rdoc/BigDecimal.html).

## Roadmap
- Add caching layer to prevent the need to hit the database for each lookup
- Make ORM and framework-agnostic

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/samward/xrate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
