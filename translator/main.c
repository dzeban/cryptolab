/*
 * 		main.c 
 * 	
 * 	Entry point for Cryptolab language translator. For more info about
 * 	cryptolab see <http://code.google.com/p/cryptolab> or email authors
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
 *
 */


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

	printf("[[[::: Parsing complete :::]]]\n\n");
	printf("[[[::: Generated code :::]]]\n%s",GENSTR);
	return 0;
	
}
