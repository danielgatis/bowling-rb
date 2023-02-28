# frozen_string_literal: true

RSpec.describe ::Bowling::Parser::Parser do
  subject(:parser) { described_class.new(tokenizer) }

  let(:tokenizer) { ::Bowling::Parser::Tokenizer.new(str) }

  context "when str is empty" do
    let(:str) { "" }

    it "returns an empty rolls" do
      expect(parser.parse).to eq([:rolls, []])
    end
  end

  context "when str is not empty" do
    let(:str) { "foo\t1\nfoo\t9\nbar\t5\nbar\t5" }

    it "returns an empty game" do
      expect(parser.parse).to eq(
        [:rolls,
         [
           [:roll, "foo", 1],
           [:roll, "foo", 9],
           [:roll, "bar", 5],
           [:roll, "bar", 5]
         ]]
      )
    end
  end

  context "when 2 players on same line" do
    let(:str) { "foo\t1\nbar\tbar" }

    it "raises an error" do
      expect { parser.parse }.to raise_error(::Bowling::Parser::Parser::ParserError)
        .with_message('Expected number or fault, got identifier "bar" at 2:5')
    end
  end

  context "when 2 pins on same line" do
    let(:str) { "foo\t1\n1\t1" }

    it "raises an error" do
      expect { parser.parse }.to raise_error(::Bowling::Parser::Parser::ParserError)
        .with_message("Expected identifier, got number 1 at 2:1")
    end
  end

  context "when missing player" do
    let(:str) { "foo\t1\n\t1" }

    it "raises an error" do
      expect { parser.parse }.to raise_error(::Bowling::Parser::Parser::ParserError)
        .with_message("Expected identifier, got number 1 at 2:2")
    end
  end

  context "when missing pins" do
    let(:str) { "foo\t1\nbar\t" }

    it "raises an error" do
      expect { parser.parse }.to raise_error(::Bowling::Parser::Parser::ParserError)
        .with_message('Expected number or fault, got eof "<eof>" at 2:5')
    end
  end
end
