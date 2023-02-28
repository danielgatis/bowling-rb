# frozen_string_literal: true

RSpec.describe ::Bowling::Parser::VM do
  subject(:vm) { described_class.new(game) }

  let(:game) { instance_double("game") }

  before do
    allow(game).to receive(:roll)
  end

  it "evaluates the ast and returns the score board" do
    vm.eval([:rolls, [[:roll, "Player-1", 1], [:roll, "Player-2", 2]]])

    expect(game).to have_received(:roll).with("Player-1", 1)
    expect(game).to have_received(:roll).with("Player-2", 2)
  end
end
