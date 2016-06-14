require File.expand_path('../parser', __FILE__)

module Truth
  class Table
    attr_reader :ast
    attr_reader :rows

    def initialize(expression)
      @ast = Parser.parse(expression)

      row_count = 2 ** @ast.ids.count
      @rows = Array.new(row_count) do |row|
        values = @ast.ids.map.with_index do |id, idx|
          [id, (row / (2 ** idx)) % 2 == 1]
        end

        mapping = Hash[values]

        { result: @ast.evaluate(mapping),
          values: mapping }
      end
    end

    def display
      bool = ->(v) { v ? "t" : "f" }

      puts "Expression:"
      puts @ast
      puts

      @ast.ids.each { |id| print " #{id} " }
      puts "| ="
      @ast.ids.each { |id| print '-' * (id.length + 2) }
      puts "+---"

      @rows.each do |row|
        @ast.ids.each do |id|
          print " %*s " % [id.length, bool[row[:values][id]]]
        end
        puts "| %s " % bool[row[:result]]
      end
    end
  end
end
