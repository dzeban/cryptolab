
#include "parser.h"

extern FILE *yyin;
char *filename;

int main(int c, char **a)
{
	if(c > 1)
	{
		printf("Parsing file: %s...\n-----------------------------------------\n", a[1]);
		filename = a[1];
		yyin = fopen(a[1], "r");
		if(!yyin)
		{
			fprintf(stderr, "Error %s", a[1]);
			perror("fopen");
			return 1;
		}
	}
	yyparse();
	return 0;
	
}
