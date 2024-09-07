all: npp_parser

npp_parser: npp_parser.tab.o lex.yy.o
	gcc -o npp_parser npp_parser.tab.o lex.yy.o -lfl

npp_parser.tab.c npp_parser.tab.h: npp_parser.y
	bison -d -v -Wcounterexamples npp_parser.y

lex.yy.c: npp_lexer.l npp_parser.tab.h
	flex npp_lexer.l


clean:
	rm -f npp_parser npp_parser.tab.c npp_parser.tab.h lex.yy.c *.o npp_parser.output
