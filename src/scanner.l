
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

 /* functions to update line and column numbers */
void updateCol();
void countLines();
int processCharacters();

#define BUFFER_SIZE 4096 
char temp [BUFFER_SIZE];
int pos;
%}

%option noyywrap

newline         [\r]?[\n]
whitespace      [ \t]+
letter          [a-zA-Z]
digit           [0-9]
integer         0|[1-9][0-9]*
identifier      {letter}({letter}|{digit})*
character       \'([^\'\\]|\\.)\

%x COMMENT_MODE

%%

 /* rules */

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

{identifier}    {updateCol(); return processCharacters();}

 /* Constants */

{integer}       {updateCol(); return INTCONST;}

{character}     {updateCol(); return CHARCONST;}
{string}        {updateCol(); return KWD_STRING;}

 /* Comments - start conditions used */

"/*"            {startLine = yylineno;
                startCol = scancol;
                scancol += 2;
                BEGIN(COMMENT_MODE);}

<COMMENT_MODE>"*/"      {scancol +=2; BEGIN(INITIAL);}
<COMMENT_MODE>{newline} {countLines();}
<COMMENT_MODE>.         {scancol++;}

<COMMENT_MODE><<EOF>>   {yyerror = "Unterminated comment";
                        yycol = startCol;
                        yylineno = startLine;
                        BEGIN(INITIAL);
                        return ERROR;}


 /* Other */
{newline}       {countLines();}
{whitespace}    {scancol += yyleng;}
.               {updateCol(); return ILLEGAL_TOK;}

%%

/* user routines */
/* Make characters in identifier lowercase then check for keywords */
int processCharacters() {
    for (inti=0; yytext[i]; ++i) {
        yytext[i] |= 0x20;
    }
    if      (strcmp(yytext, "if") ==0) return KWD_IF;
    else if (strcmp(yytext, "else")   == 0) return KWD_ELSE;
    else if (strcmp(yytext, "while")  == 0) return KWD_WHILE;
    else if (strcmp(yytext, "int")    == 0) return KWD_INT;
    else if (strcmp(yytext, "string") == 0) return KWD_STRING;
    else if (strcmp(yytext, "char")   == 0) return KWD_CHAR;
    else if (strcmp(yytext, "return") == 0) return KWD_RETURN;
    else if (strcmp(yytext, "void")   == 0) return KWD_VOID;
    return ID;
}

/* Implement this function to keep track of column numbers */
void updateCol(){
    yycol   = scancol;
    scancol += yyleng;
}

/* Implement this function to keep track of line numbers */
void countLines(){
    yylineno++;
    scancol = 1;
}
