module SimpleReport
  class Field
    attr_reader :name, :width, :block, :format, :field, :value, :force

    def initialize(name, field, format: nil, width: 10, value: nil, force: nil, &block)
      @name = name
      @field = field
      @width = width
      @value = value
      @block = block
      @format = format
      @force = force
    end
  end
end
