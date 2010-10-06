#ifndef PARSER_H
#define PARSER_H

#include <stdio.h>

int yyparse (void);
int yylex(void);
void yyerror(char const *);

#endif
