module SimpleReport
  class Field
    attr_reader :name, :width, :block, :format, :field, :value, :force, :formula

    def initialize(name, field, format: nil, width: 10, value: nil, force: nil, formula: nil, &block)
      @name = name
      @field = field
      @width = width
      @value = value
      @block = block
      @format = format
      @force = force
      @formula = formula
    end
  end
end
