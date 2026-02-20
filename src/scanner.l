
/* definitions */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokendef.h"

 /* integers to track line and column numbers */
int scancol = 1;
int yycol = 1;

 /* char pointer to pass error messages to driver.c */
char *yyerror;

int startLine;
int startCol;

 /* TODO: functions to update line and column numbers */
void updateCol();
void countLines();

#define BUFFER_SIZE 4096 
char temp [BUFFER_SIZE]
int pos;
%}

newline         [\r]?[\n]
whitespace      [ \t]+
letter          [a-zA-Z]
digit           [0-9]
integer         0|[1-9]{digit}*
identifier      {letter}({letter}|{digit})*

yylineno = 1;

%%

 /* rules */

 /* Keywords */
 /* TODO: Support all keywords in mC */

 /* Operators */
 /* TODO: Support all operators in mC */

 /* Identifiers */;
{identifier}    //TODO
{illidentifier} //TODO

 /* Constants */;
{integer}       //TODO
{integerlead0}  //TODO: "Integers may not have leading zeros"
{character}     //TODO
{string}        {updateCol(); return processString();}
{untermstring}  {updateCol(); yyerror = "Unterminated string"; return ERROR;}

 /* Comments */
{comment}       //TODO
{untermcomment} //TODO
{multlncomment} //TODO

 /* Other */
{newline}       //TODO
{whitespace}    //TODO
.               {return ILLEGAL_TOK;}

%%

/* user routines */

/* TODO:
Implement this function to keep track of column numbers
*/
void updateCol(){
    yycol   = scancol;
    scancol += yyleng;
}

/* TODO:
Implement this function to keep track of line numbers
*/
void countLines(){
    yylineno++;
    scancol = 1;
}
