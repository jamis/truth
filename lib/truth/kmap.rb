require 'truth/ast'

module Truth
  class KMap
    attr_reader :ast

    def initialize(ast)
      @ast = ast

      mid = (@ast.ids.length - 1) / 2
      @top = @ast.ids[0..mid]
      @side = @ast.ids[(mid+1)..-1]

      top_codes = _graycode(@top.length)
      side_codes = _graycode(@side.length)

      @top_codes_labels = top_codes.map { |row| row.map { |v| v ? 1 : 0 }.join }
      @side_codes_labels = side_codes.map { |row| row.map { |v| v ? 1 : 0 }.join }

      @matrix = Array.new(2 ** @side.length) do |s|
        Array.new(2 ** @top.length) do |t|
          top_inputs = top_codes[t].each.with_index.with_object({}) do |(input, idx), hash|
            hash[@top[idx]] = input
          end
          inputs = side_codes[s].each.with_index.with_object(top_inputs) do |(input, idx), hash|
            hash[@side[idx]] = input
          end

          @ast.evaluate(inputs)
        end
      end
    end

    def display
      cell_width = @top.length
      margin_width = @side.length
      full_margin_width = margin_width * 2 + 1

      puts "%s  %s" % [" " * full_margin_width, @top.join]
      print " " * full_margin_width + " "
      @top_codes_labels.each do |code|
        print " #{code}"
      end
      puts

      separator = " " * full_margin_width + " +"
      @top_codes_labels.each do |code|
        separator << "%s+" % [ "-" * code.length ]
      end
      puts separator

      @matrix.each.with_index do |row, row_idx|
        if row_idx == 0
          print @side.join
        else
          print " " * margin_width
        end

        print " " + @side_codes_labels[row_idx] + " |"

        row.each.with_index do |col, col_idx|
          result = @matrix[row_idx][col_idx] ? "1" : "0"
          print "%s|" % result.center(cell_width)
        end
        puts
        puts separator
      end
    end

    def _graycode(n)
      return [[false], [true]] if n <= 1

      n1 = _graycode(n - 1)
      reverse = n1.reverse

      p1 = n1.map { |l| [false, *l] }
      pr = reverse.map { |l| [true, *l] }

      p1 + pr
    end
  end
end

