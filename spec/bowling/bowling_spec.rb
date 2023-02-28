# frozen_string_literal: true

RSpec.describe ::Bowling do
  let(:parsed) { described_class.parse(input) }
  let(:printed) do
    io = StringIO.new
    described_class.print_score_board(parsed, io)
    io.rewind
    io.read
  end

  context "when positive" do
    context "when scores.txt" do
      let(:input) { File.read("./spec/fixtures/positive/scores.txt") }

      it "returns the correct score" do
        expect(parsed.score("Jeff")).to eq(167)
        expect(parsed.score("John")).to eq(151)
      end

      it "prints the score board" do
        expect(printed).to eq("Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nJeff\nPinfalls\t \tX\t7\t/\t9\t0\t \tX\t0\t8\t8\t/\tF\t6\t \tX\t \tX\tX\t8\t1\nScore\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\nJohn\nPinfalls\t3\t/\t6\t3\t \tX\t8\t1\t \tX\t \tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\nScore\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151\n")
      end
    end

    context "when perfect.txt" do
      let(:input) { File.read("./spec/fixtures/positive/perfect.txt") }

      it "returns the correct score" do
        expect(parsed.score("Carl")).to eq(300)
      end

      it "prints the score board" do
        expect(printed).to eq("Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nCarl\nPinfalls\t \tX\t \tX\t \tX\t \tX\t \tX\t \tX\t \tX\t \tX\t \tX\tX\t10\t10\nScore\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300\n")
      end
    end

    context "when example.txt" do
      let(:input) { File.read("./spec/fixtures/positive/example.txt") }

      it "returns the correct score" do
        expect(parsed.score("Jeff")).to eq(167)
        expect(parsed.score("John")).to eq(151)
      end

      it "prints the score board" do
        expect(printed).to eq("Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\nJeff\nPinfalls\t \tX\t7\t/\t9\t0\t \tX\t0\t8\t8\t/\tF\t6\t \tX\t \tX\tX\t8\t1\nScore\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\nJohn\nPinfalls\t3\t/\t6\t3\t \tX\t8\t1\t \tX\t \tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\nScore\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151\n")
      end
    end
  end

  context "when negative" do
    context "when empty.txt" do
      let(:input) { File.read("./spec/fixtures/negative/empty.txt") }

      it "returns the correct score" do
        expect { parsed.score("Jeff") }.to raise_error(::Bowling::Game::BowlingError)
          .with_message("This game is not finished yet")
      end
    end

    context "when extra-score.txt" do
      let(:input) { File.read("./spec/fixtures/negative/extra-score.txt") }

      it "returns the correct score" do
        expect { parsed.score("Carl") }.to raise_error(::Bowling::Game::BowlingError)
          .with_message("This game is already finished")
      end
    end

    context "when free-text.txt" do
      let(:input) { File.read("./spec/fixtures/negative/free-text.txt") }

      it "returns the correct score" do
        expect { parsed.score("Carl") }.to raise_error(::Bowling::Parser::Tokenizer::SyntaxError)
          .with_message("Unexpected char \" \" at 1:6")
      end
    end

    context "when invalid-score.txt" do
      let(:input) { File.read("./spec/fixtures/negative/invalid-score.txt") }

      it "returns the correct score" do
        expect { parsed.score("Carl") }.to raise_error(::Bowling::Parser::Parser::ParserError)
          .with_message("Expected number or fault, got identifier \"lorem\" at 2:6")
      end
    end

    context "when negative.txt" do
      let(:input) { File.read("./spec/fixtures/negative/negative.txt") }

      it "returns the correct score" do
        expect { parsed.score("Carl") }.to raise_error(::Bowling::Parser::Tokenizer::SyntaxError)
          .with_message("Unexpected char \"-\" at 2:6")
      end
    end
  end
end
