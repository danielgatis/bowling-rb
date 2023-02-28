# frozen_string_literal: true

module Bowling
  module Game
    ##
    # Represents a frame in a game of bowling.
    class Frame
      attr_reader :rolls

      ##
      # initialize a frame.
      def initialize(frames)
        @frames = frames
        @rolls = []
      end

      ##
      # roll a ball and knock down pins.
      def <<(pins) # rubocop:disable Metrics
        unless pins.between?(
          0, 10
        )
          raise ::Bowling::Game::BowlingError,
                "The pins number must be between 0 and 10, got #{pins.to_s}"
        end

        raise ::Bowling::Game::BowlingError, "This frame is already closed" if finished?

        rolls << pins

        if tenth? && strike?
          unless rolls[1] == 10 || rolls[1..2].sum <= 10
            raise ::Bowling::Game::BowlingError,
                  "The frame cannot score more than 10 points"
          end
        else
          unless rolls.take(2).sum <= 10
            raise ::Bowling::Game::BowlingError,
                  "The frame cannot score more than 10 points"
          end
        end
      end

      ##
      # check if the frame is finished.
      def finished?
        if tenth?
          rolls.size == (strike? || spare? ? 3 : 2)
        else
          strike? || rolls.size == 2
        end
      end

      ##
      # calculate the score of the frame.
      def score # rubocop:disable Metrics
        return previous_frame_score + rolls.sum if tenth?

        result = rolls.sum

        if strike?
          result += next_rolls[0..1].sum
        elsif spare?
          result += next_rolls.first
        end

        previous_frame_score + result
      end

      ##
      # to string representation.
      def to_repr # rubocop:disable Metrics
        if tenth?
          return ["X", rolls[1].to_s, rolls[2].to_s] if strike?
          return [rolls[0].to_s, "/", rolls[2].to_s] if spare?
        else
          return [" ", "X"] if strike?
          return [rolls.first.to_s, "/"] if spare?

          rolls.map(&:to_s)
        end
      end

      private

      attr_reader :frames

      ##
      # get the index of the frame.
      def index
        frames.index(self)
      end

      ##
      # get the previous frame score.
      def previous_frame_score
        return 0 if index.zero?

        frames[index - 1].score
      end

      ##
      # get the next rolls.
      def next_rolls
        Array(frames[(index + 1)..]).sum([], &:rolls)
      end

      ##
      # check if the frame is a spare.
      def spare?
        !strike? && rolls.take(2).sum == 10
      end

      ##
      # check if the frame is a strike.
      def strike?
        rolls.first == 10
      end

      ##
      # check if the frame is the 10th frame.
      def tenth?
        index == 9
      end
    end
  end
end
