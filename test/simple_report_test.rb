require "test_helper"

class EmptyReport < SimpleReport::Base
  def report
    add_sheet 'First tab', (1..10) do | sheet |
      sheet.add_field('Field Name', width: 20) { |x| x }

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
    data = report.report_xls
    refute_nil data
  end
end
