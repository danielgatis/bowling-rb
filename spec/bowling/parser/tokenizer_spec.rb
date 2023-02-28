# frozen_string_literal: true

RSpec.describe ::Bowling::Parser::Tokenizer do
  subject(:tokenizer) { described_class.new(str) }

  context "when identifier" do
    let(:str) { "John" }

    it "returns the type" do
      token = tokenizer.next_token
      expect(token.type).to eq(:identifier)
    end

    it "returns the value" do
      token = tokenizer.next_token
      expect(token.value).to eq("John")
    end

    it "returns the line" do
      token = tokenizer.next_token
      expect(token.line).to eq(1)
    end

    it "returns the column" do
      token = tokenizer.next_token
      expect(token.column).to eq(1)
    end

    context "when identifier with white space" do
      let(:str) { "\t\tJohn\t\t" }

      it "returns the type" do
        token = tokenizer.next_token
        expect(token.type).to eq(:identifier)
      end

      it "returns the value" do
        token = tokenizer.next_token
        expect(token.value).to eq("John")
      end

      it "returns the line" do
        token = tokenizer.next_token
        expect(token.line).to eq(1)
      end

      it "returns the column" do
        token = tokenizer.next_token
        expect(token.column).to eq(3)
      end
    end
  end

  context "when number" do
    let(:str) { "1" }

    it "returns the type" do
      token = tokenizer.next_token
      expect(token.type).to eq(:number)
    end

    it "returns the value" do
      token = tokenizer.next_token
      expect(token.value).to eq(1)
    end

    it "returns the line" do
      token = tokenizer.next_token
      expect(token.line).to eq(1)
    end

    it "returns the column" do
      token = tokenizer.next_token
      expect(token.column).to eq(1)
    end

    context "when number with white space" do
      let(:str) { "\t\t1\t\t" }

      it "returns the type" do
        token = tokenizer.next_token
        expect(token.type).to eq(:number)
      end

      it "returns the value" do
        token = tokenizer.next_token
        expect(token.value).to eq(1)
      end

      it "returns the line" do
        token = tokenizer.next_token
        expect(token.line).to eq(1)
      end

      it "returns the column" do
        token = tokenizer.next_token
        expect(token.column).to eq(3)
      end
    end

    context "when invalid number" do
      let(:str) { "1-" }

      it "returns the type" do
        expect { tokenizer.next_token }.to raise_error(::Bowling::Parser::Tokenizer::SyntaxError)
      end
    end

    context "when negative number" do
      let(:str) { "-1" }

      it "returns the type" do
        expect { tokenizer.next_token }.to raise_error(::Bowling::Parser::Tokenizer::SyntaxError)
      end
    end
  end

  context "when new_line" do
    let(:str) { "\n" }

    it "returns the type" do
      token = tokenizer.next_token
      expect(token.type).to eq(:new_line)
    end

    it "returns the value" do
      token = tokenizer.next_token
      expect(token.value).to eq("")
    end

    it "returns the line" do
      token = tokenizer.next_token
      expect(token.line).to eq(1)
    end

    it "returns the column" do
      token = tokenizer.next_token
      expect(token.column).to eq(1)
    end
  end

  context "when input is a multiline str" do
    let(:str) { "A\t1\n\n\naAa1bB\t\t\t\t12132\n\t\tccc\t1\t" }

    it "returns all tokens" do
      expect(tokenizer.next_token.to_h).to eq({ type: :identifier, value: "A", line: 1, column: 1 })
      expect(tokenizer.next_token.to_h).to eq({ type: :number, value: 1, line: 1, column: 3 })
      expect(tokenizer.next_token.to_h).to eq({ type: :new_line, value: "", line: 1, column: 4 })
      expect(tokenizer.next_token.to_h).to eq({ type: :identifier, value: "aAa1bB", line: 2, column: 1 })
      expect(tokenizer.next_token.to_h).to eq({ type: :number, value: 12_132, line: 2, column: 11 })
      expect(tokenizer.next_token.to_h).to eq({ type: :new_line, value: "", line: 2, column: 16 })
      expect(tokenizer.next_token.to_h).to eq({ type: :identifier, value: "ccc", line: 3, column: 3 })
      expect(tokenizer.next_token.to_h).to eq({ type: :number, value: 1, line: 3, column: 7 })
    end
  end
end
