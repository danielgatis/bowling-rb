# frozen_string_literal: true

module Bowling
  module Parser
    ##
    # The VM class is the main class of the VM. It is responsible for running the
    # game.
    class VM
      class RuntimeError < StandardError; end

      ##
      # initialize takes a game and returns a new VM.
      def initialize(game)
        @game = game
      end

      ##
      # eval evaluates the ast.
      def eval(ast)
        case ast
        in [:rolls, rolls]
          rolls.each { self.eval(_1) }
        in [:roll, player, pins]
          @game.roll(player, pins)
        in [type, *]
          raise "Unknown AST node: #{type}"
        end
      end
    end
  end
end
