%{
#include "Lexer.h"
#include "Tokens.h"
int LINECOUNT = 1;
%}
hexdigit	({digit}|[a-f]|[A-F])
bindigit	("0"|"1")
octdigit	[0-7]
nonzerodigit	[1-9]
digit		[0-9]
floatnumber	({pointfloat}|{exponentfloat})
exponentfloat	(({intpart}|{pointfloat}){exp})
pointfloat	(({intpart}?{fraction})|{intpart}".")
intpart		{digit}+
fraction	"."{digit}+
exp		("e"|"E")("+"|"-")?({digit}+)
longinteger	({integer}("l"|"L"))
integer 	({decimalinteger}|{octinteger}|{hexinteger}|{bininteger})
decimalinteger	(({nonzerodigit}{digit}*)|"0")
octinteger	(("0"("o"|"O"){octdigit}+)|"0"{octdigit}+)
hexinteger	("0"("x"|"X"){hexdigit}+)
bininteger	("0"("b"|"B"){bindigit}+)
leninteger	({integer}("b"|"B"))
imagnumber	(({floatnumber}|{intpart})("j"|"J"))
%%


^[ \t]+([\r]?[\n])+ {
	LINECOUNT += countchar(yytext, '\n');
	printf("Empty line\n");
}


[ \t]+		{ }

"/*"		{ comment(); }
"//"		{ string_comment(); }

"Field"		{ printf("key Field\n"); return FIELD; }
"Group"		{ printf("key Group\n"); return GROUP; }

"mul"		{ printf("par mul\n"); return MUL; }
"int"		{ printf("par int\n"); return INT_PAR; }
"len"		{ printf("par len\n"); return LEN;}


"and"		{ printf("key and\n"); return AND; }
"or"		{ printf("key or\n"); return OR; }
"not"		{ printf("key not\n"); return NOT; }
"is"		{ printf("key is\n"); return IS; }
"xor"		{ printf("key xor\n"); return XOR; }
"in"      	{ printf("key in\n"); return IN; }
"mod"      	{ printf("key mod\n"); return MOD; }

"for"		{ printf("key for\n"); return FOR; }
"while"		{ printf("key while\n"); return WHILE; }
"break"		{ printf("key break\n"); return BREAK; }
"continue"	{ printf("key continue\n"); return CONTINUE; }

"if"		{ printf("key if\n"); return IF; }
"else"		{ printf("key else\n"); return ELSE; }
"elif"		{ printf("key elif\n"); return ELIF; }

"echo"		{ printf("key echo\n"); return ECHHO; }
"return"	{ printf("key return\n"); return RETURN; }


"("	{ return LPAREN; }
")"	{ return RPAREN; }
"["	{ return LBRACE; }
"]"	{ return RBRACE; }
"{"	{ return LFBRACE; }
"}"	{ return RFBRACE; }
":"	{ return COLON; }
","	{ return COMMA; }
";"	{ return SEMIC; }

"+"	{ return PLUS; }
"-"	{ return MINUS; }
"*"	{ return STAR; }
"/"	{ return SLASH; }
"|"	{ return VBAR; }
"&"	{ return AMPERS; }
"%"	{ return PERCENT; }
"^"	{ return CIRCX; }

"<"	{ return LESSER; }
">"	{ return GREATER; }
"="	{ return ASSIGN; }
"=="	{ return EQUAL; }
"!="	{ return NOTEQUAL; }
"<>"	{ return ALT_NOTEQUAL; }
"<="	{ return LESSEQUAL; }
"<<"	{ return LEFTSHIFT; }
">="	{ return GREATEREQUAL; }
">>"	{ return RIGHTSHIFT; }
"<-"	{ return TAKE; }

"+="	{ return PLUSEQUAL; }
"-="	{ return MINUSEQUAL; }
"*="	{ return STAREQUAL; }
"%="	{ return PERCENTEQ; }
"^="	{ return CIREQ; }

"."	{ return DOT; }
"@"	{ return AT; }


(("_"|[a-zA-Z])([0-9]|[a-zA-Z]|"_")*) {
	printf("Identifier: %s\n", yytext);
	return NAME;
}

{longinteger} {
	printf("Long integer %s\n", yytext);
	return LONGINT;
}

{leninteger} {
	printf("Len integer %s\n", yytext);
	return LENINT;
}

{integer} {
	printf("Integer %s\n", yytext);
	return INT;
}

{floatnumber} {
	printf("Float number %s\n", yytext);
	return FLOAT;
}

{imagnumber} {
	printf("Complex number %s\n", yytext);
	//yylval.str = (char *) malloc(yyleng + 1);
	//strcpy(yylval.str, yytext);
	return COMPLEX;
}

([\r]?[\n])+ {
	LINECOUNT += countchar(yytext, '\n');
	return NEWLINE;
}


(?x:("u"|"r"|"ur")?("\""|"'")) {
	register int c;
	char delim;
	char prev;
	delim = prev = yytext[strlen(yytext) - 1];
	prev = delim;
	printf("strings: %s", yytext);
	while(1)
	{
		c = yyinput();
		if(c == '\n')	{LINECOUNT++;}
		printf("%c", c);
		if(prev == '\\')
		{
			if(c == '\\')	{prev = 'O';} 
			else if(c == '\r')	{prev = '\\';} 
			else	{prev = c;}
			continue;
		}
		else
			if(c == '\n')
			{
				printf("New line in string %d\n", LINECOUNT);
				exit(1);
			}
			else
				if(c == delim)
				{
					printf("\n");
					return STRING;
				}
				if(c == EOF)
				{
					printf("End of file in string\n");
					exit(1);
				}
				prev = c;
	}
}


. {}

%%


int yywrap(void)
{
	return 1;
}


int countchar(char *str, char c)
{
  uint i, res = 0;

  for(i = 0; i < strlen(str); i++) {
    if(str[i] == c) {
      res++;
    }
  }
  return res;
}


int comment()
{
	char c, c1;
	
loop:
	while ((c = yyinput()) != '*' && c != 0){ }
	if ((c1 = yyinput()) != '/' && c != 0)
		{ goto loop; }
	return 0;
}

int string_comment(){
	char c;
	printf("\tComment: ");
	while ((c = yyinput()) != '\n' && c != 0){printf("%c",c);}
	if(c == EOF) yyterminate();
	printf("\n");
	LINECOUNT+=1;
	return 0;
}

int unput_char(int i, char* c)
{
	yyunput(i,c);
	return 0;
}
