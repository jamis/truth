require 'strscan'

module Truth
  class Tokenizer
    class Error < RuntimeError; end

    def initialize(string)
      @scanner = StringScanner.new(string)
      @buffer = []
    end

    def eof?
      @buffer.empty? && @scanner.eos?
    end

    def push(tok)
      @buffer.push(tok)
    end

    def peek
      tok = self.next
      push(tok)
      tok
    end

    def next
      return @buffer.pop if @buffer.any?
      @scanner.skip(/\s+/)

      if @scanner.eos?
        return [ :eof, :eof ]
      elsif (match = @scanner.scan(/\w+/))
        return [ :word, match ]
      elsif @scanner.scan(/&&/)
        return [ :and, "&&" ]
      elsif @scanner.scan(/!/)
        return [ :bang, "!" ]
      elsif @scanner.scan(/\|\|/)
        return [ :or, "||" ]
      elsif @scanner.scan(/\^\^/)
        return [ :xor, "^^" ]
      elsif @scanner.scan(/\(/)
        return [ :oparen, "(" ]
      elsif @scanner.scan(/\)/)
        return [ :cparen, ")" ]
      else
        raise Error, "not sure how to parse at #{@scanner.pos} #{@scanner.rest.inspect}"
      end
    end
  end
end
