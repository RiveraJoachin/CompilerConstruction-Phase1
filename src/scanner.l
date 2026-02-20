
/* definitions */

%{
#include <stdio.h>
#include <stdlib.h>
#include "tokendef.h"

 /* integers to track line and column numbers */
int scancol = 1;
int yycol = 1;
int scanlineno = 1;

 /* char pointer to pass error messages to driver.c */
char *yyerror;

 /* TODO: functions to update line and column numbers */
void updateCol();
void countLines();

 /* TODO: function to process a string literal */
int processString();

%}

newline         [\n]
whitespace      [ \t]+
integer         0|[1-9][0-9]*
character       //TODO

 /* String can contain any characters between the double quotes */
 /* other than a newline or unescaped doublequotes */
*/
string       //TODO


 /* If the end quote is not found in the same line the string is unterminated */
untermstring //TODO

comment         //TODO
multlncomment   //TODO
untermcomment   //TODO

identifier      //TODO
illidentifier   //TODO: regular expression for an illegal identifier

yylineno = 1;

%%

 /* rules */

 /* Keywords */
 /* TODO: Support all keywords in mC */

 /* Operators */
 /* TODO: Support all operators in mC */

 /* Identifiers */;
{identifier} {
    updateCol();
    countLines(); //unsure if this is necessary here, but it doesn't hurt to check for newlines in identifiers

    return ID;
}
{illidentifier} {
    updateCol();
    countLines(); //unsure if this is necessary here, but it doesn't hurt to check for newlines in identifiers

    yyerror = "Illegal identifier";
    return ERROR;
}

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
}

/* TODO:
Implement this function to keep track of line numbers
*/
void countLines(){
}


/* TODO:
Implement this function to
check for illegal escape sequences in string literals
and
convert valid escape sequences into escaped characters
(string[0] == '\\' and string[1] == 'n', then string[0] should be '\n')
*/
int processString(){
}
