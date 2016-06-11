require 'truth/node'

module Truth
  class AST
    attr_reader :ids

    def initialize(root)
      @root = root
      @ids = []

      stack = [ @root ]
      while stack.any?
        node = stack.pop
        case node
        when Node::UnaryOperation then
          stack.push node.value
        when Node::BinaryOperation then
          stack.push node.left
          stack.push node.right
        when Node::Identifier then
          @ids << node.name
        end
      end

      @ids = @ids.uniq.sort
    end

    def to_s
      _to_s(@root)
    end

    def _to_s(node)
      case node
      when Node::UnaryOperation
        value = _to_s(node.value)

        case node.op
        when :not then "!#{value}"
        when :group then "(#{value})"
        else raise ArgumentError, "unsupported unary operator #{node.op.inspect}"
        end

      when Node::BinaryOperation
        left = _to_s(node.left)
        right = _to_s(node.right)

        case node.op
        when :and then "#{left} && #{right}"
        when :or then "#{left} || #{right}"
        when :xor then "#{left} ^^ #{right}"
        else raise ArgumentError, "unsupported binary operator #{node.op.inspect}"
        end

      when Node::Identifier
        node.name

      else
        raise ArgumentError, "unsupported node type #{node.class}"
      end
    end

    def evaluate(values={})
      missing = @ids - values.keys
      raise ArgumentError, "missing values for #{missing.inspect}" if missing.any?

      extras = values.keys - @ids
      raise ArgumentError, "extra values: #{extras.inspect}" if extras.any?

      _evaluate_node(@root, values)
    end

    def _evaluate_node(node, values)
      case node
      when Node::UnaryOperation then
        value = _evaluate_node(node.value, values)

        case node.op
        when :not then !value
        when :group then value
        else raise ArgumentError, "unsupported unary operation: #{node.op.inspect}"
        end

      when Node::BinaryOperation then
        left = _evaluate_node(node.left, values)
        right = _evaluate_node(node.right, values)

        case node.op
        when :and then left && right
        when :or then left || right
        when :xor then left ^ right
        else raise ArgumentError, "unsupported binary operation: #{node.op.inspect}"
        end

      when Node::Identifier then
        values[node.name]

      else
        raise ArgumentError, "unsupported node type: #{node.class}"
      end
    end
  end
end
