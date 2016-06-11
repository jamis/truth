require 'truth/tokenizer'
require 'truth/node'
require 'truth/ast'

# expr := expr2
#       | expr2 '||' expr
#       | expr2 '^^' expr
#
# expr2 := expr3
#        | expr3 '&&' expr2
#
# expr3 := identifier
#        | '(' expr ')'
#        | '!' expr3

module Truth
  class Parser
    class Error < RuntimeError; end

    def self.parse(string)
      new(string).parse
    end

    def initialize(string)
      @tokens = Tokenizer.new(string)
    end

    def parse
      AST.new(_parse_expr)
    end

    def _expect(token_type)
      tok = @tokens.next || []
      return tok.last if tok.first == token_type
      raise Error, "expected #{token_type}, got #{tok.first.inspect} (#{tok.last.inspect})"
    end

    def _eat_any(*token_types)
      tok = @tokens.next
      if token_types.include?(tok.first)
        tok
      else
        @tokens.push(tok)
        nil
      end
    end

    def _parse_expr
      node = _parse_expr2

      if (tok = _eat_any(:or, :xor))
        right = _parse_expr
        node = Node::BinaryOperation.new(tok.first, node, right)
      end

      node
    end

    def _parse_expr2
      node = _parse_expr3

      if _eat_any(:and)
        right = _parse_expr2
        node = Node::BinaryOperation.new(:and, node, right)
      end

      node
    end

    def _parse_expr3
      if (tok = _eat_any(:word))
        Node::Identifier.new(tok.last)

      elsif _eat_any(:oparen)
        expr = Node::UnaryOperation.new(:group, _parse_expr)
        _expect(:cparen)
        expr

      elsif _eat_any(:bang)
        Node::UnaryOperation.new(:not, _parse_expr3)

      else
        raise Error, "expected (:word, :oparen, :bang), got #{@tokens.peek.inspect}"
      end
    end
  end
end
