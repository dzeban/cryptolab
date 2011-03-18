/*
 * 		parser.h 
 *  
 *
 *  Header file for Cryptolab parser. For more information about
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

#ifndef PARSER_H
#define PARSER_H

#include <stdio.h>

int yyparse (void);
int yylex(void);
void yyerror(char const *);

char GENSTR[1000];

#endif
