# frozen_string_literal: true

module Bowling
  module Game
    ##
    # Represents a game of bowling.
    class Game
      attr_reader :score_board

      ##
      # initialize a game.
      def initialize
        @score_board = Hash.new do |hash, key|
          hash[key] = [].tap { _1 << ::Bowling::Game::Frame.new(_1) }
        end
      end

      ##
      # rool a ball and knock down pins.
      def roll(player, pins)
        raise ::Bowling::Game::BowlingError, "This game is already finished" if finished?(player)

        frames = @score_board[player]
        frames << ::Bowling::Game::Frame.new(frames) if frames.last.finished?
        frames.last << ::Bowling::Game::Pinfall.new(pins)
      end

      ##
      # score of the game by player.
      def score(player)
        raise ::Bowling::Game::BowlingError, "This game is not finished yet" unless finished?(player)

        frames = @score_board[player]
        frames.last.score.to_i
      end

      ##
      # check if the game is finished.
      def finished?(player)
        frames = @score_board[player]
        frames.size == 10 && frames.last.finished?
      end
    end
  end
end
