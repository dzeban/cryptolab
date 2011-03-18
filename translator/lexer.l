/*
 * 		lexer.l 
 * 	
 * 	Lexical analyzer for CryptoLab language. For more info about cryptolab see
 * 	<http://code.google.com/p/cryptolab> or email authors
 * 
 * Copyright (C) 2010 Alexander Dzyoba <finger@reduct.ru>
 *
 *
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * THis program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty if MERCHATABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details
 *
 * You should received a copy of the GNU General Public License along with this
 * program. If not, see <http://www.gnu.org/licences/>.
 *
 * 
 */


%{
/* Include tokens definition from bison/yacc */
#include "tokens.h"
/*extern YYSTYPE yylval;*/
%}

%option yylineno

%option nounput
%option noinput
%option noyywrap

 /* Lexer states */
%x SL_COMM
%x ML_COMM
%x STRING

 /***********************************************
  *		 Define some regex for convinience		*
  ***********************************************/
  
 /* Newline */
NL	\r?\n?
 /* Whitespaces */
WS	[ \t\n\r]

 /* Identificator */
IDENT	[a-zA-Z_\x7F-\xFF][a-zA-Z0-9_\x7F-\xFF]*
 /* Define an integer number */
DEC	([1-9][0-9]*)|0
HEX	0[xX][0-9a-fA-F]+
OCT	0[0-7]+
INT	({DEC}|{HEX}|{OCT})

 /* Define a real number */
LNUM				[0-9]+
DNUM				([0-9]*[\.]{LNUM})|({LNUM}[\.][0-9]*)
EXPONENT_DNUM	(({LNUM}|{DNUM})[eE][+-]?{LNUM})
REAL				{DNUM}|{EXPONENT_DNUM}

 /* Any character. Really _any_. */
ANY	[\x00-\xff]

 /* Guess what is it? */
BRACKET			[(){}[\]]
 
 /* Define different operators */
ARITHMETIC		[+\-/*%^]
BITWISE			[&|~]

RELATION		[><]	
OTHER_OP		[.,]
 	/******	That ^ looks like an angry owl ;-)  ******/

OPERATOR	{ARITHMETIC}|{RELATION}|{BITWISE}


%%

{NL}	{
			printf("%s%d:\t", yytext, yylineno);
			yylval.str = strdup(yytext);
			return(NL);
		}

{WS}	{
			printf("%s", yytext);
		}

 /************************************************************
  * 		Dealing with comments and strings.				 *
  *----------------------------------------------------------*
  * Because parser doesn't give a shit about comments -      *
  * we won't return to it anything related to comments.      *
  *                                                          *
  * In strings case we will return quotes characters and     *
  * token STRING_CHAR for every symbol in string             *
  */ 

"/*"	{
			BEGIN(ML_COMM);
			cprintf("<c>%s", yytext);
			
		}

"//"	{
			BEGIN(SL_COMM);
			cprintf("<c>%s", yytext);
		}

<ML_COMM>"*/"	{
					BEGIN(0);
					cprintf("%s</>", yytext);
				}


<SL_COMM>{NL}	{
					BEGIN(0);
					cprintf("%s</>%d:\t", yytext, yylineno);
					yylval.str = strdup(yytext);
					return(NL);
				}

<ML_COMM,SL_COMM>{ANY}	{
			cprintf("%s",yytext);
			}


"\""	{
			BEGIN(STRING);
			cprintf("<r>%s", yytext);
			yylval.str = strdup(yytext);
			return(D_QUOTE);
		}

<STRING>"\""	{
/*TODO: double quotes escaping, i.e. " \"   \"\" " */
				BEGIN(0);
				cprintf("%s </>", yytext);
				yylval.str = strdup(yytext);
				return(D_QUOTE);
			}

<STRING>{ANY}	{
				printf("%s", yytext);
				yylval.str = strdup(yytext);
				return(STRING_CHAR);
			}


	/************************************************
	 * 				Keywords part					*
	 ***********************************************/
"mod"	{
			cprintf("<g>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(MOD_KW);	
		}

"echo"	{
			cprintf("<m>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(ECHO_KW);	
		}

"if"	{
			cprintf("<m>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(IF);
		}

"else"	{
			cprintf("<m>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(ELSE_KW);
		}

"Field"		{
			cprintf("<m>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(FIELD_KW);
			}


	/************************************************
	 * 				Operators part					*
	 ***********************************************/

"<-"	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(ASSIGN);
		}

">="	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(RELATIONAL);
		}

"<="	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(RELATIONAL);
		}

"=="	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(EQEQ_OP);
		}

"="		{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(*yytext);
		}

{RELATION}	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(RELATIONAL);
			}

{OPERATOR}	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(*yytext);
			}

{BRACKET}	{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(*yytext);
			}

{OTHER_OP} {
				printf("%s", yytext);
				yylval.str = strdup(yytext);
				return(*yytext);
			}
	

	/************************************************
	 * 					Stuff part					*
	 ***********************************************/
";"		{
			printf("%s", yytext);
			yylval.str = strdup(yytext);
			return(EOS);
		}

{INT}	{
			cprintf("<y>%s</>", yytext);
			yylval.str = strdup(yytext);
			return(INT);
		}

	/************************************************
	 * 		IDENT should always be at bottom, 		*
	 * 		otherwise it considered as any keyword	*
	 ***********************************************/
{IDENT}	{
			cprintf("%s",yytext);
			yylval.str = strdup(yytext);
			return(IDENT);
		}

%%
