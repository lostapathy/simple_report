module SimpleReport
  class Base
    def add_format(name, format)
      @formats ||= {}
      @formats[name] = format
    end

    def initialize
      @file = Tempfile.new('simple_report')
      @workbook = WriteXLSX.new(@file.path)
      money = @workbook.add_format
      money.set_num_format('$0.00')
      add_format :money, money

      heading = @workbook.add_format
      heading.set_bold
      add_format :heading, heading

      percent = @workbook.add_format
      percent.set_num_format('0%')
      add_format :percent, percent
    end

    def report_xls(*params)
      report(*params)
      @workbook.close
      File.read @file.path
    end

    private

    def add_sheet(name, data)
      sheet = Sheet.new(name)
      @fields = []
      sheet = @workbook.add_worksheet(name)
      yield
      @sheets ||= []
      @sheets << sheet

      @fields.each_with_index do |f, index|
        sheet.set_column(index, index, f.width)
        sheet.write(0, index, f.name, @formats[:heading])
      end

      data.each_with_index do |ic, row|
        @fields.each_with_index do |field, column|
          if field.field
            value = ic.send(field.field)
          elsif field.value
            value = field.value
          elsif field.block
            value = field.block.call(ic)
          end
          sheet.write(row + 1, column, value, find_format(field.format))
        end
      end
    end

    def field(name, field = nil, width: nil, format: nil, value: nil, &block)
      rf = Field.new(name, field, width: width, format: format, value: value, &block)
      @fields << rf
    end

    private

    def find_format(format)
      @formats[format]
    end
  end
end
