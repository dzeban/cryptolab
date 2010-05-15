#ifndef LEXER_H
#define LEXER_H

#include <stdio.h>
#include <stdlib.h>

int comment(void);
int string_comment(void);
int countchar(char *str, char c);
void yyerror(char *);

#endif
