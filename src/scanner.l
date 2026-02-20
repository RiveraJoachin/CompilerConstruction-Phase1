
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
 "if"   {updateCol(); return KWD_IF;}
 "else"   {updateCol(); return KWD_ELSE;}
 "while"   {updateCol(); return KWD_WHILE;}
 "int"   {updateCol(); return KWD_INT;}
 "char"   {updateCol(); return KWD_CHAR;}
 "return"   {updateCol(); return KWD_RETURN;}
 "void"   {updateCol(); return KWD_VOID;}

 /* Operators */
 "+"    {updateCol(); return OPER_ADD;}
 "-"    {updateCol(); return OPER_SUB;}
 "*"    {updateCol(); return OPER_MUL;}
 "/"    {updateCol(); return OPER_DIV;}
 "%"    {updateCol(); return OPER_MOD;}
 "<"    {updateCol(); return OPER_LT;}
 ">"    {updateCol(); return OPER_GT;}
 "<="   {updateCol(); return OPER_LTE;}
 ">="   {updateCol(); return OPER_GTE;}
 "=="   {updateCol(); return OPER_EQ;}
 "!="   {updateCol(); return OPER_NEQ;}
 "="    {updateCol(); return OPER_ASGN;}
 "["    {updateCol(); return LSQ_BRKT;}
 "]"    {updateCol(); return RSQ_BRKT;}
 "{"    {updateCol(); return LCRLY_BRKT;}
 "}"    {updateCol(); return RCRLY_BRKT;}
 "("    {updateCol(); return LPAREN;}
 ")"    {updateCol(); return RPAREN;}
 ","    {updateCol(); return COMMA;}
 ";"    {updateCol(); return SEMICLN;}
 "@"    {updateCol(); return OPER_AT;}
 "++"   {updateCol(); return OPER_INC;}
 "--"   {updateCol(); return OPER_DEC;}
 "&&"   {updateCol(); return OPER_AND;}
 "||"   {updateCol(); return OPER_OR;}
 "!"    {updateCol(); return OPER_NOT;}
 


 /* Identifiers */;
{identifier} {
    updateCol();
    countLines(); 
    return ID;
}
{illidentifier} {
    updateCol();
    countLines(); 
    yyerror = "Illegal identifier";
    return ERROR;
}

 /* Constants */;
{integer} {
    updateCol();
    countLines(); 
    return INTCONST;
}
{integerlead0} {
    updateCol();
    countLines(); 
    yyerror = "Illegal integer constant with leading zeros (except for 0 itself)";
    return ERROR;
}
{character} {
    updateCol();
    countLines(); 
    return CHARCONST;
}
{string}        {updateCol(); return processString();}
{untermstring}  {updateCol(); yyerror = "Unterminated string"; return ERROR;}

 /* Comments */
{comment} {
    updateCol();
    countLines();

    /* ignore comments, no need for returning a token */
}
{untermcomment} {
    updateCol();
    countLines();

    yyerror = "Unterminated/unfinished comment";
    return ERROR;
}
{multlncomment} {
    updateCol();
    countLines();

    /* ignore comments, no need for returning a token */
}

 /* Other */
{newline}       { countLines(); }
{whitespace}    { scancol += yyleng}
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
