module SimpleReport
  class Field
    attr_reader :name, :width, :block, :format, :field, :value

    def initialize(name, field, format: nil, width: 10, value: nil, &block)
      @name = name
      @field = field
      @width = width
      @value = value
      @block = block
      @format = format
    end
  end
end
