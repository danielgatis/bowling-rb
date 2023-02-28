# Bowling

This is a gem for calculating bowling scores.

## Usage

Go to the root of the project and run:

```
cat spec/fixtures/positive/scores.txt | ./bin/score_board
```

And you will see this output:

```
Frame           1               2               3               4               5               6               7               8               9               10
Jeff
Pinfalls                X       7       /       9       0               X       0       8       8       /       F       6               X               X       X       8       1
Score           20              39              48              66              74              84              90              120             148             167
John
Pinfalls        3       /       6       3               X       8       1               X               X       9       0       7       /       4       4       X       9       0
Score           16              25              44              53              82              101             110             124             132             151
```

## Errors

There are 3 types of errors:
  - SyntaxError: When there are some unknown character on the input file.
  - ParserError: When all characters is ok but there is a semantic error.
  - RuntimeError: When all is ok but a runtime errors happens on evaluation time.


### SyntaxError

```
cat spec/fixtures/negative/negative.txt | ./bin/score_board
```

You can figure out the problem looking on the error message: `Unexpected char "-" at 2:6 (Bowling::Parser::Tokenizer::SyntaxError)`.

### ParserError

```
cat spec/fixtures/negative/invalid-score.txt | ./bin/score_board
```

You can figure out the problem looking on the error message: `Expected number or fault, got identifier "lorem" at 2:6 (Bowling::Parser::Parser::ParserError)`.

### RuntimeError

```
cat spec/fixtures/negative/extra-score.txt | ./bin/score_board
```

You can figure out the problem looking on the error message: `This game is already finished (Bowling::Game::BowlingError)`.

## Running tests

Go to the root of the project and run:

```bash
$ rspec
```
