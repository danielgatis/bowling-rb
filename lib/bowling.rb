# frozen_string_literal: true

require_relative "bowling/version"

require_relative "bowling/parser/parser"
require_relative "bowling/parser/tokenizer"
require_relative "bowling/parser/vm"

require_relative "bowling/game/pinfall"
require_relative "bowling/game/error"
require_relative "bowling/game/frame"
require_relative "bowling/game/game"

##
# Bowling is a gem for parsing bowling scores.
module Bowling
  module_function

  ##
  # Parses the given input and returns the game.
  def parse(input)
    ::Bowling::Game::Game.new.tap do |game|
      tokenizer = ::Bowling::Parser::Tokenizer.new(input)
      parser = ::Bowling::Parser::Parser.new(tokenizer)
      vm = ::Bowling::Parser::VM.new(game)

      ast = parser.parse
      vm.eval(ast)
    end
  end

  ##
  # Prints the score board for the given input.
  def print_score_board(game, output)
    output.puts "Frame\t\t#{[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].join("\t\t")}"
    game.score_board.each do |player, frames|
      output.puts player
      output.puts "Pinfalls\t#{frames.map(&:to_repr).join("\t")}"
      output.puts "Score\t\t#{frames.map { _1.score.to_i }.join("\t\t")}"
    end

    nil
  end
end
