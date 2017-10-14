module SimpleReport
  class Base
    def add_format(name, format)
      @formats ||= {}
      @formats[name] = format
    end

    def report_xls(*params)
      report(*params)

      generate_report

      @workbook.close
      File.read @file.path
    end

    private

    def add_sheet(name, data)
      sheet = Sheet.new(name, data)
      yield sheet
      @sheets ||= []
      @sheets << sheet
    end

    def generate_report
      @file = Tempfile.new('simple_report')
      @workbook = WriteXLSX.new(@file.path)
      add_formats

      @sheets.each do |sheet|
        output_sheet = @workbook.add_worksheet(sheet.name)
        sheet.fields.each_with_index do |f, index|
          output_sheet.set_column(index, index, f.width)
          output_sheet.write(0, index, f.name, @formats[:heading])
        end

        sheet.collection.each_with_index do |ic, row|
          sheet.fields.each_with_index do |field, column|
            if field.field
              value = ic.send(field.field)
            elsif field.value
              value = field.value
            elsif field.block
              value = field.block.call(ic)
            end
            output_sheet.write(row + 1, column, value, find_format(field.format))
          end
        end
      end
    end

    def find_format(format)
      @formats[format]
    end

    def add_formats
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

  end
end
