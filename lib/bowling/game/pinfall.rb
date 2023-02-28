# frozen_string_literal: true

module Bowling
  module Game
    ##
    # Represents a pinfall in a game of bowling.
    class Pinfall < Numeric
      ##
      # initialize a pinfall.
      def initialize(value) # rubocop:disable Lint/MissingSuper
        @value = value
      end

      ##
      # convert the pinfall to a string.
      def to_s
        @value
      end

      ##
      # convert the pinfall to an integer.
      def to_i
        @value == "F" ? 0 : @value.to_i
      end

      ##
      # coecers the pinfall.
      def coerce(other)
        [self.class.new(other.to_i), self]
      end

      ##
      # compare the pinfall to another object.
      def <=>(other)
        to_i <=> other.to_i
      end

      ##
      # sum the pinfall to another object.
      def +(other)
        self.class.new(to_i + other.to_i)
      end
    end
  end
end
