# frozen_string_literal: true

module Bowling
  module Parser
    ##
    # Tokenizer class Lazily pulls a token from a stream. It is used by the parser to
    # pull tokens from the input string.
    class Tokenizer
      class SyntaxError < StandardError; end

      Token = Struct.new(:type, :value, :line, :column)

      SPEC = {
        '\A\t+' => :whitespace,
        '\A\R+' => :new_line,
        '\A\d+(?=\s|\z)' => :number,
        '\AF(?=\s|\z)' => :fault,
        '\A[a-zA-Z]\w*' => :identifier
      }.freeze

      ##
      # initialize takes a string and returns a new Tokenizer.
      def initialize(str)
        @str = str
        @cursor = 0
        @line = 0
        @last_line_char_count = 0
      end

      ##
      # next_token returns the next token in the stream. It will skip over whitespace and
      # will raise a SyntaxError if it encounters an unexpected.
      def next_token # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        line = @line + 1
        column = @cursor - @last_line_char_count + 1

        return Token.new(:eof, "<eof>", line, column) unless more_tokens?

        str = @str.slice(@cursor, @str.length)

        SPEC.each do |regex, type|
          value = match(regex, str)
          next unless value

          return next_token if type == :whitespace

          if type == :new_line
            @line += 1
            @last_line_char_count = @cursor
            value = ""
          end

          value = value.to_i if type == :number

          return Token.new(type, value, line, column)
        end

        raise SyntaxError, "Unexpected char #{str[0].inspect} at #{line}:#{column}"
      end

      private

      ##
      # more_tokens? returns true if there are more tokens to be read from the stream.
      def more_tokens?
        @cursor < @str.length
      end

      ##
      # match returns the first match for the given regex in the given string. It
      # will also advance the cursor by the length of the match.
      def match(regex, str)
        matched = str.match(Regexp.new(regex))
        return unless matched

        @cursor += matched[0].length
        matched[0]
      end
    end
  end
end
