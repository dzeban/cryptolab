/*
 * 		grammar.y 
 * 	
 * 	Formal grammar for syntax analyzer of CryptoLab language. For more info
 * 	about cryptolab see	<http://code.google.com/p/cryptolab> or email authors
 * 
 *  Copyright (C) 2010 Alexander Dzyoba <finger@reduct.ru>
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
#include "parser.h"
#include "cprintf.h"	 /* Colored printf */



/* Lexer variable that stores line number */
extern int line;

#ifdef DEBUG
int yydebug=1;
#endif

%}

%token IDENT
%token RELATIONAL

%token ASSIGN
%token EQEQ_OP
%token STRING_CHAR
%token D_QUOTE S_QUOTE
%token INT
%token NL

%token FIELD_KW ECHO_KW IF ELSE_KW MOD_KW
%token EOS	/* End of statement */

%left ','
%nonassoc EQEQ_OP
%nonassoc RELATIONAL 
%left '=' ASSIGN 
%left MOD_KW
%left '+' '-' '.' 
%left '*' '/' '%'
%left '^'
%%
start: statement_list ;

/* 
 * Top rule describing whole file 
 *
 *!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 **********************************||||
 * FIXME: Error on empty lines 	|||||||
 **********************************||||
 *!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
 */ 

statement_list: statement_list sep statement 
				| 
				;


/* 
 * 	Statements allowed by language
 *
 */
statement:	assign_statement		 	/* a<-[1,2] */
			| equation_statement 		/* a=3(mod 5) */
			| echo_statement 			/* echo "Done" */
			| field_statement 			/* Field F{int}*/
			| function_call				/* mul_inv(e,fi)*/
			| if_statement				/* if(condition) {...}*/
			| else_statement 			/* else {...} */
			|
			;

sep:	NL
		| EOS
		;
/* 
 * 			== Assign statement == 
 *	
 *	Example:
 * 		e<-[1,fi-1]
 * 	
 * 	This statement is intended for assigning _random_ value from some
 * 	structire. Difference between this statement at equation statement is 
 * 	that equation statement intended for assigning _defined_ value.
 * 	It's allowed to assign random element from range or random element of field
 *	 *
 */ 

assign_statement:
			IDENT ASSIGN assign_statement_operand
			;

assign_statement_operand:
			range
			| field_operator
			;


range:	'[' range_list ']'
		;

range_list:
		operand ',' operand
		;

operand:
		INT
		| function_call
		| IDENT
		| expr
		;
		

/*
 * 			== Field statement ==
 *
 *	Field statement is intended for defining such mathematical object as "field"
 *	Field is described by it identificator and has a different options which you
 *	can set in that statement. For example, if you want to set up an integer
 *	field you write in field_params "int"
 *
 *
 */

field_statement:	FIELD_KW field_operator;

field_operator:	IDENT '{' field_params '}' 
				;

field_params: IDENT
			| inequation
			;

/*
 * 			== Equation statement ==
 * 
 *  Equation statement is a common and well-known in popular programming
 * 	languages statement. It's intended to assign defined value to variable
 *
 */
 
equation_statement:	
				IDENT '=' operand
				;

/*
 * 			== Function call ==
 * 	
 * 	As equation statement it's also well-known statement which intended to call
 * 	some function
 *
 */

function_call:	IDENT '(' function_params ')' ;

function_params:	function_params ',' operand
				|	operand
				;

/*
 * 			== Echo statement ==
 *
 * "echo" is a built-in function which outputs arguments,e.g. strings and
 * integers to standart output.
 *
 */
echo_statement:	
				ECHO_KW D_QUOTE string D_QUOTE
				;

string:	
			STRING_CHAR string
			| STRING_CHAR
			;

/* 		
 *  		== Program flow control statements ==
 *	
 *
 *
 */
if_statement:	IF '(' condition ')' line_expression
			  |	IF '(' condition ')' block_expression
			  ;

condition:	equation
			| inequation
			;

equation:	IDENT EQEQ_OP operand ;

inequation:	IDENT RELATIONAL operand ;


else_statement: ELSE_KW line_expression
			|	ELSE_KW block_expression
			;

line_expression:	statement ;
block_expression:	'{' statement_list '}' ;


/*
 *			Expressions	
 *
 */
expr: 	
		'(' expr ')'
		| '-' '(' expr ')'
		| expr '+' expr
		| expr '-' expr
		| expr '*' expr
		| expr '/' expr
		| expr modulo 
		| term 
		| '-' term
		;

term:	fact
		| term '*' term
		| term '/' term
		| term '^' term
		| term modulo
		;

fact:	INT
		| IDENT
		| fact modulo
		;

modulo:	'(' MOD_KW expr ')' ;

%%

void yyerror(char const *s)
{
	 if(yychar == 0)
	 {
		  fprintf(stderr, "End of file\n");
		  return;
	 }
 
	 fprintf(stderr, "Error at token: %d\nTOKEN:%c\n", yychar, yychar);
}

