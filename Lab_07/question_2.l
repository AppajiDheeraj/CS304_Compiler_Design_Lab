%option noyywrap yylineno
%{
#include "question_2.tab.h"
#include <stdio.h>

extern int error_count;
#define TOKEN(t) do { printf("%-12s %-12s line %d\n", #t, yytext, yylineno); return t; } while (0)
#define CHARACTER(kind) do { printf("%-12s %-12s line %d\n", kind, yytext, yylineno); return yytext[0]; } while (0)
%}

DIGIT [0-9]
ID    [A-Za-z_][A-Za-z0-9_]*

%%
"int"                 { TOKEN(INT); }
"float"               { TOKEN(FLOAT); }
"void"                { TOKEN(VOID); }
"return"              { TOKEN(RETURN); }
"for"                 { TOKEN(FOR); }
"while"               { TOKEN(WHILE); }
{DIGIT}+"."{DIGIT}+   { TOKEN(FLOAT_NUM); }
{DIGIT}+               { TOKEN(INT_NUM); }
"<="                  { TOKEN(LE); }
">="                  { TOKEN(GE); }
"=="                  { TOKEN(EQ); }
"!="                  { TOKEN(NE); }
{ID}                   { TOKEN(ID); }
[+*/<>=-]              { CHARACTER("OPERATOR"); }
[;,(){}]               { CHARACTER("DELIMITER"); }
[ \t\r\n]+             ;
.                      { fprintf(stderr, "Lexical error at line %d: invalid token '%s'\n", yylineno, yytext); error_count++; }
%%
