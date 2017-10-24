module SimpleReport
  class Sheet
    attr_reader :name, :collection, :fields

    def initialize(name, collection)
      @name = name
      @collection = collection
      @fields = []
    end

    def add_field(name, field = nil, width: nil, format: nil, value: nil, force: nil, &block)
      @fields << Field.new(name, field, width: width, format: format, value: value, force: force, &block)
    end
  end
end
