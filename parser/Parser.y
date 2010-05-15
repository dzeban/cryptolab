%{
#include "Parser.h"
#include "Lexer.h"
extern int LINECOUNT;
%}

%start file
%token NEWLINE STRING

%token
FIELD GROUP

%token 
MUL INT_PAR LEN

%token
AND OR NOT IS XOR IN
FOR WHILE BREAK CONTINUE
IF ELSE ELIF
ECHHO RETURN MOD


%token 
LPAREN RPAREN LBRACE RBRACE LFBRACE RFBRACE COLON COMMA SEMIC
PLUS MINUS STAR SLASH VBAR AMPERS PERCENT CIRCX
LESSER GREATER ASSIGN EQUAL NOTEQUAL ALT_NOTEQUAL
LESSEQUAL LEFTSHIFT GREATEREQUAL RIGHTSHIFT TAKE
PLUSEQUAL MINUSEQUAL STAREQUAL PERCENTEQ CIREQ
DOT AT

%token
NAME LONGINT INT FLOAT COMPLEX LENINT
%%



file:		line
    		| file line
		;
	
line:		NEWLINE
		| state	SEMIC	{ printf("Done\n"); }
		;

state:		field_state
     		| group_state
		| take_state
		| assign_state
		| echo_state
		| if_state
		;

field_state:	FIELD NAME
	   	| field_state LFBRACE field_pars RFBRACE
		;

field_pars:	INT_PAR
	  	;

group_state:	GROUP NAME
	   	| group_state LFBRACE group_pars RFBRACE
		;

group_pars:	MUL
	  	;

take_state:	NAME TAKE NAME take_pars
	  	| NAME TAKE interval
		;

take_pars:	LFBRACE LEN comp_op num RFBRACE
	 	;

comp_op:	LESSER
		| GREATER
		| ASSIGN
		| GREATEREQUAL
		| LESSEQUAL
		| ALT_NOTEQUAL
		| EQUAL
		| NOTEQUAL
		| IN
		| NOT IN
		| IS
		| IS NOT
		;

num:		INT
   		| LENINT
		| LONGINT
		| COMPLEX
		;

assign_state:	NAME ASSIGN arith_expr
	    	| NAME ASSIGN func_expr
		;

arith_expr:	term
	  	| term mod_expr
		| term PLUS term
		| term MINUS term
		;

term:		NAME
    		| INT
		| fact STAR fact
		| fact CIRCX fact
		;

fact:		NAME
    		| INT
		;

mod_expr:	LPAREN MOD arith_expr RPAREN
		;

func_expr:	NAME LPAREN func_pars RPAREN
	 	;

func_pars:	NAME
	 	| func_pars COMMA NAME
		;

interval:	LPAREN arith_expr COMMA arith_expr RPAREN
		| LBRACE arith_expr COMMA arith_expr RBRACE
		;

echo_state:	ECHHO STRING
	  	;

if_state:	IF test state
		| if_state ELSE state
		;

test:		LPAREN NAME comp_op NAME RPAREN
    		;


%%



////////////////////////////////////////////////yyerror()//////////////////////////////////////////////////////////
extern char *yytext;
void yyerror(char const *s)
{
 if(yychar == 0) {fprintf(stderr, "End of file\n");} 
 /*switch(yychar)
 {
 	case NEWLINE: 
 		{
 			fprintf(stderr, "Error [LINE %d][%d]\tConstruction not completed\n", LINECOUNT-1, yychar);
 			break;	
 		}
 	case RBRACE: 
 		{
 			fprintf(stderr, "Error [LINE %d][%d]\tUnexpected right brake\t%s\n", LINECOUNT, yychar,yytext);
 			break;	
 		}
 	default: {fprintf(stderr, "Error [LINE %d][%d]\tUnexpected error\n", LINECOUNT,yychar);}
 }*/
 fprintf(stderr, "Error at line %d(token: %d)\n", LINECOUNT,yychar);
}

