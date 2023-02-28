# frozen_string_literal: true

module Bowling
  module Parser
    ##
    # Parser is a recursive descent parser.
    class Parser
      class ParserError < StandardError; end

      ##
      # initialize takes a tokenizer and returns a new Parser.
      def initialize(tokenizer)
        @tokenizer = tokenizer
        @token = @tokenizer.next_token
      end

      ##
      # parse returns an ast representing the game.
      def parse
        rolls
      end

      ##
      # Rolls
      #  : Roll
      #  | Rolls Roll
      #  ;
      def rolls
        return [:rolls, []] if @token.type == :eof

        rolls = [roll]
        rolls << roll while @token.type != :eof

        [:rolls, rolls]
      end

      ##
      # Roll
      #  : Player Pins Delemiter
      #  ;
      def roll
        [:roll, player, pins].tap { delemiter }
      end

      ##
      # Player
      #  : IDENTIFIER
      #  ;
      def player
        consume(:identifier).value
      end

      ##
      # Pins
      #  : NUMBER
      #  | F
      #  ;
      def pins
        case @token.type
        when :number
          consume(:number).value.to_i
        when :fault
          consume(:fault).value
        else
          raise ParserError,
                "Expected number or fault, got #{@token.type} #{@token.value.inspect}" \
                " at #{@token.line}:#{@token.column}"
        end
      end

      ##
      # Delemiter
      #  : NEW_LINE
      #  : EOF
      #  ;
      def delemiter
        case @token.type
        when :new_line
          consume(:new_line)
        when :eof
          consume(:eof)
        else
          raise ParserError, "Delemiter: unexpected delemiter production"
        end
      end

      private

      ##
      # advance the look ahead token.
      def advance
        @token = @tokenizer.next_token
      end

      ##
      # consume the current look ahead token and advance the look ahead token.
      def consume(type)
        token = @token

        if token.type != type
          raise ParserError,
                "Expected #{type}, got #{token.type} #{token.value.inspect} at #{token.line}:#{token.column}"
        end

        token.tap { advance }
      end
    end
  end
end
