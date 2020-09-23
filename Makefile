all:
	stack build
	stack exec writeyourselfascheme-exe "(+ (+ 4 3) 2)"

build: src/Lexer.hs
	stack build

test: 
	stack test

clean:
	stack clean

