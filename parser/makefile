# $Id$
# plain simple Makefile to build exprtest

CXX = g++
LEX = flex
YACC = bison

CXXFLAGS = -Wall
LDFLAGS =


all: parser

# Generate scanner and parser
Parser.cpp: Parser.y
	$(YACC) -o Parser.cpp --defines=Tokens.h Parser.y

Lexer.cpp: Lexer.lex 
	$(LEX) -o Lexer.cpp Lexer.lex

#Compile sources
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
 

#Link all
parser: Parser.o Lexer.o Main.o 
	$(CXX) Main.o Parser.o Lexer.o -o parser $(LDFLAGS)

clean:
	rm -f *.o parser Parser.cpp Lexer.cpp Tokens.h
