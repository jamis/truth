module Truth
  module Node
    class UnaryOperation < Struct.new(:op, :value)
    end

    class BinaryOperation < Struct.new(:op, :left, :right)
    end

    class Identifier < Struct.new(:name)
    end
  end
end
