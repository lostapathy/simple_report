module SimpleReport
  class Base
    def initialize
      @sheets = []
    end

    def add_format(name, format)
      @formats ||= {}
      @formats[name] = format
    end

    def to_xlsx(*params)
      build_report(*params)
      generate_report
      @file = Tempfile.new(%w[simple_report .xlsx])
      @workbook.write(@file.path)
      File.read @file.path
    end

    def add_sheet(name, data)
      sheet = Sheet.new(name, data)
      yield sheet
      @sheets ||= []
      @sheets << sheet
    end

    def generate_report
      @workbook = RubyXL::Workbook.new
      @workbook.worksheets.pop # Delete the default Sheet1 worksheet
      add_formats
      @sheets.each do |sheet|
        output_sheet = @workbook.add_worksheet(sheet.name)
        sheet.fields.each_with_index do |f, index|
          output_sheet.change_column_width(index, f.width) unless f.width.nil?
          output_sheet.add_cell(0, index, f.name) #, @formats[:heading])
        end
        sheet.collection.each_with_index do |ic, record_num|
          sheet.fields.each_with_index do |field, column|
            if field.field
              value = ic.send(field.field)
            elsif field.value
              value = field.value
            elsif field.block
              value = field.block.call(ic, record_num + 2)
            end

            case field.force
            when nil
              output_sheet.add_cell(record_num + 1, column, value)#, find_format(field.format))
            when :string
              output_sheet.add_cell(record_num + 1, column, value.to_s) #, find_format(field.format))
            else
              raise "invalid force param"
            end
          end
        end
      end
    end

    def find_format(format)
      #@formats[format]
      nil
    end

    def add_formats
      #money = @workbook.add_format
      #money.set_num_format('$0.00')
      #add_format :money, money

      #heading = @workbook.add_format
      #heading.set_bold
      #add_format :heading, heading

      #percent = @workbook.add_format
      #percent.set_num_format('0.0%')
      #add_format :percent, percent
    end

    def build_report
      raise NotImplementedError.new('<report>#build_report not implemented')
    end
  end
end
