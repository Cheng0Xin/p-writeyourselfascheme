all:
	stack build
	stack exec writeyourselfascheme-exe "\"test\""

build: src/Lexer.hs
	stack build

test: 
	stack test

clean:
	stack clean

