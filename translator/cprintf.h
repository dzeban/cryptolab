#ifndef CPRINTF_H
#define CPRINTF_H


#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <regex.h>
#include <stdlib.h>

//Regex for color tags
#define PATTERN "<[agrybmc/]>"
#define TMP_SIZE 10

#define GRAY    "\e[37m"
#define GREEN   "\e[32m"
#define RED     "\e[31m"
#define YELLOW  "\e[33m"
#define BLUE    "\e[34m"
#define MAGENTA "\e[35m"
#define CYAN    "\e[36m"

#define RESET   "\e[0m"

/*
 * <a> - gray
 * <g> - green
 * <r> - red
 * <y> - yellow
 * <b> - blue
 * <m> - magenta
 * <c> - cyan
 */

char *substitute(const char *str, char *origin, char *replace)
{
  char *result;
  result = (char*)malloc(strlen(str)+strlen(replace));

  char *p = (char*)strstr(str,origin);
  if(p==NULL)
    return NULL;

  strncpy(result, str,p-str);

  sprintf(result+(p-str),"%s%s", replace, p+strlen(origin));
  result[strlen(result)+1]='\0';

  return result;
}

char *replace_escaped(char *str, char *tag)
{
  char *escape=(char*)malloc(10);
  memset(escape,0,10);

  switch(tag[1])
  {
    case 'a':       strncpy(escape, GRAY,   strlen(GRAY));          break;
    case 'g':       strncpy(escape, GREEN,  strlen(GREEN));         break;
    case 'r':       strncpy(escape, RED,    strlen(RED));           break;
    case 'y':       strncpy(escape, YELLOW, strlen(YELLOW));        break;
    case 'b':       strncpy(escape, BLUE,   strlen(BLUE));          break;
    case 'm':       strncpy(escape, MAGENTA,strlen(MAGENTA));       break;
    case 'c':       strncpy(escape, CYAN,   strlen(CYAN));          break;
    case '/':       strncpy(escape, RESET,  strlen(RESET));         break;
  }
  str = substitute(str, tag, escape);
  
  free(escape);
  return str;
}

char* format_process(const char *f)
{
  char *format;
  format = (char*)f;
  // Compiled regex structure
  regex_t preg;   

  //Compile regex with pattern
  regcomp(&preg, PATTERN, REG_EXTENDED);

  char *tmp, *escaped_format;

  int match_count = 1;
  regmatch_t pmatch;
  int err;

  tmp = (char*)malloc(TMP_SIZE);
  escaped_format = (char*)f;

  // Parse format string using compiled regex
  while((err=regexec(&preg, format, match_count, &pmatch, REG_NOTBOL))==0)
  {
    strncpy(tmp, format+pmatch.rm_so, pmatch.rm_eo - pmatch.rm_so);

    escaped_format = replace_escaped(escaped_format,tmp);
    format+= pmatch.rm_so + strlen(tmp);
    memset(tmp,0,TMP_SIZE);
  }
  free(tmp);
  return escaped_format;
}

int cprintf(const char *format, ...)
{

  va_list args;
  va_start(args,format);
  char *escaped_format;

  escaped_format = format_process(format);
  
  vprintf(escaped_format,args);

  va_end(args);
  return 0;
}

#endif
