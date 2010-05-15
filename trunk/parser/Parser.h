#ifndef PARSER_H
#define PARSER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <ctype.h>

int yyparse (void);
int yylex(void);
void yyerror(char const *);

#endif
