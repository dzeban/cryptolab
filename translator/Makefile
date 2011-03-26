# Define tools
CXX = gcc
LEX = flex
YACC = bison

# Define flags
CXXFLAGS = -Wall #-DDEBUG
LDFLAGS = -lfl 
YACCFLAGS = -Wall --defines=tokens.h --debug --report=all

all:	translator

# Main target
translator: main.o parser.o lexer.o
	$(CXX) main.o parser.o lexer.o -o translator $(LDFLAGS)

# Compile sources
%.o: %.c
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Generate sources
parser.c: grammar.y
	$(YACC) $(YACCFLAGS) grammar.y -o parser.c

lexer.c: lexer.l 
	$(LEX) -o lexer.c lexer.l  

# Separate target for lexer
lexer:	lexer.o lexer.c
	$(CXX) lexer.o -o lexer $(LDFLAGS)

# Separate target for test cls
test:	rsa.cpp
	g++ -lgmp -lgmpxx -DDEBUG rsa.cpp -o rsa
# Housekeeping
clean:
	rm -f *.o translator rsa parser.c parser.output lexer.c tokens.h
