# simple_report

[![Build Status](https://travis-ci.org/lostapathy/simple_report.svg?branch=master)](https://travis-ci.org/lostapathy/simple_report)
[![Code Climate](https://api.codeclimate.com/v1/badges/04ced70d7b66d1a7c42d/maintainability)](https://codeclimate.com/github/lostapathy/simple_report)
[![Test Coverage](https://codeclimate.com/github/lostapathy/simple_report/badges/coverage.svg)](https://codeclimate.com/github/lostapathy/simple_report/coverage)


simple_report is a gem for building simple reports from Enumerable collections.  It was extracted from a larger application and only supports Excel exports for now, but we plan to add support for HTML reports as well (see TODO below).  Other formats could be added if requested.

simple_report is meant to provide a simple way to get a collection of data out of your application and out to the user in a reasonable report, and do so without any hassle.  It's not intended to collect, analyze, or transform data for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_report'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_report

## Usage

Like a typical spreadsheet, each report may have multiple Sheets.  Each sheet has multiple fields/columns.  The data sources passed in can be any Enumerable collection, whether that's a simple Array or an ActiveRecord query does not matter.

Let's build our first report:

```ruby
class CustomerReport < SimpleReport::Base
  def build_report
    data = Customer.all

    add_sheet('Customers', data) do |sheet|
      sheet.add_field('Username', :username)
      sheet.add_field('Full Name', width: 30) { |x| x.first_name + " " x.last_name }
      sheet.add_field('Billing Rate', :billing_rate, format: :money)
      sheet.add_field('SLA %', :sla, format: :percent)
      sheet.add_field('Placeholder', value: 'TBD')
    end
  end
end

report = CustomerReport.new
File.write('report.xlsx', report.to_xlsx)
```

This is pretty straightforward, and covers the entire API.  We'll go over it in detail below.


```ruby
class CustomerReport < SimpleReport::Base
  def build_report
```
Each report must subclass ```SimpleReport::Base``` and define the report in the build_report method.  For this example, we're report on an an ActiveRecord collection of all ```Customer```ruby records.

```ruby
    data = Customer.all
```
Our report data will be all the ```Customer``` objects returned by ActiveRecord

```ruby
    add_sheet('Customers', data) do |sheet|
```
We want to add a Sheet to our report.  It'll be labeled 'Customers', and include one row for every element in ```data```.  To include multiple Sheets in your report, simple add additional add_sheet blocks.


```ruby
      sheet.add_field('Username', :username)
```
Adds a column labeled Username to the report, and populates it by invoking the :username method on each record in the data collection.


```ruby
      sheet.add_field('Full Name', width: 30) { |x| x.first_name + " " x.last_name }
```
Adds a column labeled 'Full Name' to the report, and populates it by calling the provided block on each record.  In this case, it's concatenating the user's name together.  We're also setting a field width of 30.


```ruby
      sheet.add_field('Billing Rate', :billing_rate, format: :money)
```
Add a column named 'Billing Rate', populate it by invoking :billing_rate on each record, and format the results as money.


```ruby
      sheet.add_field('SLA %', :sla, format: :percent)
```
Add a column named 'SLA %', populate it by invoking :sla on each record, and format the results as a percentage.

```ruby
      sheet.add_field('Placeholder', value: 'TBD')
```
Add a column 'Plaeholder' and populate it with the supplied value. This seemingly useless capability is surprisingly useful when you have to match a report full of boilerplate.

```ruby
report = CustomerReport.new
File.write('report.xlsx', report.to_xlsx)
```
Instantiate the report, then write it to file.

## Advanced Usage

Your report object and build_report method are just plain ruby code, so you can add logic to how your reports are generated.  For example:

```ruby
class FancyReport < SimpleReport::Base
  attr_accessor :include_wholesale

  def initialize
    @include_wholesale = true
  end

  def build_report
    data = Product.all
    add_sheet('Products', data) do |sheet|
      sheet.add_field('Name', :name)
      sheet.add_field('MSRP', :msrp, format: :money)
      sheet.add_field('Wholesale', :wholesale, format: :money) if @include_wholesale
    end
  end
end

report = FancyReport.new
report.include_wholesale = false
File.write('my_report.xlsx, report.to_xlsx)
```

You can also add attributes to the report to pass data into the report, rather than compute the data in the report as our simple examples have thus far:
```ruby
class AnotherReport < SimpleReport::Base
  attr_accessor :data

  def build_report
    add_sheet 'Something', @data do |sheet|
      // define some fields
    end
  end
end

report = AnotherReport.new
report.data = Customer.all
File.write('another_report.xlsx', report.to_xlsx)

```




## TODO

* Add to_html method to render out as a simple table-based HTML report.  We'll generate a table, with thead/tbody/tfoot, apply css classes based on formats, and apply basic text formatting such as number_to_currency or percent (%) characters.  That will give the end-user enough flexibility to do whatever they want with the output, while still keeping the gem extremely simple
* Add some concept of a footer/summary to the reports that allows operations like sum, average, minimum, maximum.  When exported to xlsx, these will be exported as formulas.  Actual values should be computed for HTML reports.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lostapathy/simple_report.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
