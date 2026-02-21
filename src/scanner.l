
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
char temp [BUFFER_SIZE];
int pos;
%}

newline         [\r]?[\n]
whitespace      [ \t]+
letter          [a-zA-Z]
digit           [0-9]
integer         0|[1-9][0-9]*
identifier      {letter}({letter}|{digit})*
illidentifier   {digit}+{letter}({letter}|{digit})*
integerlead0     0{digit}+
character       \'([^\'\\]|\\.)\'
string          \"([^\"\\]|\\.)*\"
untermstring    \"([^\"\\]|\\.)*$
comment         \/\/[^\n]*
multlncomment   \/\*([^*]|\n)*\*\/
untermcomment   \/\*([^*]|\n)*

%%

 /* rules */

 /* Keywords */
"if"            {updateCol(); return KWD_IF;}
"else"          {updateCol(); return KWD_ELSE;}
"while"         {updateCol(); return KWD_WHILE;}
"int"           {updateCol(); return KWD_INT;}
"char"          {updateCol(); return KWD_CHAR;}
"return"        {updateCol(); return KWD_RETURN;}
"void"          {updateCol(); return KWD_VOID;}

 /* Operators */
"++"            {updateCol(); return OPER_INC;}
"--"            {updateCol(); return OPER_DEC;}
"&&"            {updateCol(); return OPER_AND;}
"||"            {updateCol(); return OPER_OR;}

"<="            {updateCol(); return OPER_LTE;}
">="            {updateCol(); return OPER_GTE;}
"=="            {updateCol(); return OPER_EQ;}
"!="            {updateCol(); return OPER_NEQ;}

"+"             {updateCol(); return OPER_ADD;}
"-"             {updateCol(); return OPER_SUB;}
"*"             {updateCol(); return OPER_MUL;}
"/"             {updateCol(); return OPER_DIV;}
"%"             {updateCol(); return OPER_MOD;}
"<"             {updateCol(); return OPER_LT;}
">"             {updateCol(); return OPER_GT;}
"="             {updateCol(); return OPER_ASGN;}
"!"             {updateCol(); return OPER_NOT;}

"["             {updateCol(); return LSQ_BRKT;}
"]"             {updateCol(); return RSQ_BRKT;}
"{"             {updateCol(); return LCRLY_BRKT;}
"}"             {updateCol(); return RCRLY_BRKT;}
"("             {updateCol(); return LPAREN;}
")"             {updateCol(); return RPAREN;}
","             {updateCol(); return COMMA;}
";"             {updateCol(); return SEMICLN;}


 /* Identifiers */
{identifier} {
    updateCol();

    return ID;
}
{illidentifier} {
    updateCol();
    
    yyerror = "Illegal identifier";
    return ERROR;
}

 /* Constants */
{integer} {
    updateCol();
   
    return INTCONST;
}
{integerlead0} {
    updateCol();
    
    yyerror = "Illegal integer constant with leading zeros (except for 0 itself)";
    return ERROR;
}
{character} {
    updateCol();
    
    return CHARCONST;
}
{string}        {updateCol(); return KWD_STRING;}
{untermstring}  {updateCol(); yyerror = "Unterminated string"; return ERROR;}

 /* Comments */
{comment} {
    updateCol();
    

    /* ignore comments, no need for returning a token */
}
{untermcomment} {
    updateCol();
    

    yyerror = "Unterminated/unfinished comment";
    return ERROR;
}
{multlncomment} {
    updateCol();
    

    /* ignore comments, no need for returning a token */
}

 /* Other */
{newline}       { countLines(); }
{whitespace}    { scancol += yyleng; }
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
