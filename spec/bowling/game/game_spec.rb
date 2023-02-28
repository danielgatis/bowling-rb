# frozen_string_literal: true

RSpec.describe ::Bowling::Game::Game do
  subject(:game) { described_class.new }

  let(:player) { "player-1" }

  context "when be able to score a game with all zeros" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(0)
    end
  end

  context "when be able to score a game with no strikes or spares" do
    let(:rolls) { [3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(90)
    end
  end

  context "when a spare followed by zeros is worth ten points" do
    let(:rolls) { [6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(10)
    end
  end

  context "when points scored in the roll after a spare are counted twice" do
    let(:rolls) { [6, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(16)
    end
  end

  context "when consecutive spares each get a one roll bonus" do
    let(:rolls) { [5, 5, 3, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(31)
    end
  end

  context "when a spare in the last frame gets a one roll bonus that is counted once" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 7] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(17)
    end
  end

  context "when a strike earns ten points in a frame with a single roll" do
    let(:rolls) { [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(10)
    end
  end

  context "when points scored in the two rolls after a strike are counted twice as a bonus" do
    let(:rolls) { [10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(26)
    end
  end

  context "when consecutive strikes each get the two roll bonus" do
    let(:rolls) { [10, 10, 10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(81)
    end
  end

  context "when a strike in the last frame gets a two roll bonus that is counted once" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 1] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(18)
    end
  end

  context "when rolling a spare with the two roll bonus does not get a bonus roll" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 3] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(20)
    end
  end

  context "when strikes with the two roll bonus do not get bonus rolls" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(30)
    end
  end

  context "when last two strikes followed by only last bonus with non strike points" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 0, 1] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(31)
    end
  end

  context "when a strike with the one roll bonus after a spare in the last frame does not get a bonus" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 10] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(20)
    end
  end

  context "when all strikes is a perfect game" do
    let(:rolls) { [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(300)
    end
  end

  context "when rolls cannot score negative points" do
    it "raises an error" do
      expect { game.roll(player, -1) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The pins number must be between 0 and 10, got -1")
    end
  end

  context "when rolls cannot score more than 10 points" do
    it "raises an error" do
      expect { game.roll(player, 11) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The pins number must be between 0 and 10, got 11")
    end
  end

  context "when two rolls in a frame cannot score more than 10 points" do
    it "raises an error" do
      game.roll(player, 5)
      expect { game.roll(player, 6) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The frame cannot score more than 10 points")
    end
  end

  context "when bonus roll after a strike in the last frame cannot score more than 10 points" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 11) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The pins number must be between 0 and 10, got 11")
    end
  end

  context "when two bonus rolls after a strike in the last frame cannot score more than 10 points" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 5] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 6) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The frame cannot score more than 10 points")
    end
  end

  context "when two bonus rolls after a strike in the last frame can score more than 10 points if one is a strike" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 6] }

    it "checks the score" do
      rolls.each { game.roll(player, _1) }
      expect(game.score(player)).to eq(26)
    end
  end

  context "when the second bonus rolls after a strike in the last frame cannot be" \
          "a strike if the first one is not a strike" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 6] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 10) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The frame cannot score more than 10 points")
    end
  end

  context "when second bonus roll after a strike in the last frame cannot score more than 10 points" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 11) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("The pins number must be between 0 and 10, got 11")
    end
  end

  context "when an unstarted game cannot be scored" do
    let(:rolls) { [] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.score(player) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is not finished yet")
    end
  end

  context "when an incomplete game cannot be scored" do
    let(:rolls) { [0, 0] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.score(player) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is not finished yet")
    end
  end

  context "when cannot roll if game already has ten frames" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 0) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is already finished")
    end
  end

  context "when bonus rolls for a strike in the last frame must be rolled before score can be calculated" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.score(player) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is not finished yet")
    end
  end

  context "when both bonus rolls for a strike in the last frame must be rolled before score can be calculated" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.score(player) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is not finished yet")
    end
  end

  context "when bonus roll for a spare in the last frame must be rolled before score can be calculated" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.score(player) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is not finished yet")
    end
  end

  context "when cannot roll after bonus roll for spare" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 2] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 2) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is already finished")
    end
  end

  context "when cannot roll after bonus roll for strike" do
    let(:rolls) { [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 3, 2] }

    it "raises an error" do
      rolls.each { game.roll(player, _1) }
      expect { game.roll(player, 2) }.to raise_error(::Bowling::Game::BowlingError)
        .with_message("This game is already finished")
    end
  end
end
