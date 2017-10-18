require "test_helper"

class EmptyReport < SimpleReport::Base
  def build_report
  end
end

class NoReport < SimpleReport::Base
end

class MinimalReport < SimpleReport::Base
  def build_report
    add_sheet 'First tab', (1..10) do |sheet|
      sheet.add_field('Field Name', width: 20) { |x| x }

    end
    add_sheet 'Second tab', (1..10) do |sheet|
      sheet.add_field('Field Name', width: 20) { |x| x }

    end
  end
end

class FieldReport < SimpleReport::Base
  Record = Struct.new(:field1, :field2)
  def build_report
    data = [Record.new('data')]
    add_sheet 'First tab', data do |sheet|
      sheet.add_field('By method', :field1)
      sheet.add_field('By value', value: 'foo')
    end
  end
end


class SimpleReportTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SimpleReport::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_empty_report
    report = EmptyReport.new
    data = report.to_xlsx
    refute_nil data
  end

  def test_minimal_report
    report = MinimalReport.new
    data = report.to_xlsx
    refute_nil data
  end

  def test_no_report
    report = NoReport.new
    assert_raises NotImplementedError do
      report.to_xlsx
    end
  end

  def test_field_types
    report = FieldReport.new
    data = report.to_xlsx
    refute_nil data
  end
end
