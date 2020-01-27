module SimpleReport
  class Base
    def initialize
      @sheets = []
      @skip_rows = 1 # By default, we skip a header row
      @skip_headings = false
      @template_path = nil
    end

    # Number of rows to skip in order to get below templating
    def skip_rows(val)
      @skip_rows = val
    end

    # Skip outputting the heading row (useful when working from templates)
    def skip_headings(val=true)
      @skip_headings = val
    end

    def template_path(template_path)
      raise ArgumentError, 'File does not exist' unless File.file?(template_path)

      @template_path = template_path
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
      setup_workbook

      @sheets.each do |sheet|
        output_sheet = @workbook[sheet.name]

        unless @skip_headings
          sheet.fields.each_with_index do |f, index|
            output_sheet.change_column_width(index, f.width) unless f.width.nil?
            output_sheet.add_cell(0, index, f.name)
            output_sheet.sheet_data[0][index].change_font_bold(true)
          end
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

            formula = field.formula
            if !formula.nil? && formula != ''
              output_sheet.add_cell(record_num + @skip_rows, column, '', formula.gsub('_ROW_', (record_num + @skip_rows + 1).to_s))
            elsif !value.nil? && value != ''
              # FIXME: rename force to something more obvious
              case field.force
              when nil
                output_sheet.add_cell(record_num + @skip_rows, column, value)
              when :string
                output_sheet.add_cell(record_num + @skip_rows, column, value.to_s)
              else
                raise "invalid force param"
              end
            end

            output_sheet[record_num + @skip_rows][column]&.set_number_format find_format(field.format) if field.format
          end
        end
      end
    end

    def find_format(format)
      case format
      when :money
        '$#,###.00'
      when :percent
        '00%'
      else
        nil
      end
    end

    def build_report
      raise NotImplementedError.new('<report>#build_report not implemented')
    end

    private

    def setup_workbook
      if @template_path.nil?
        @workbook = RubyXL::Workbook.new
        @workbook.worksheets.pop # Delete the default Sheet1 worksheet

        @sheets.each do |sheet|
          @workbook.add_worksheet(sheet.name)
        end
      else
        @workbook = RubyXL::Parser.parse(@template_path)
      end
    end
  end
end
