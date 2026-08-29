%option noyywrap

%{
#include "question_1.tab.h"
%}

%%

"if"                    return IF;
"else"                  return ELSE;
[a-zA-Z_][a-zA-Z0-9_]*  return ID;
[0-9]+                  return NUMBER;
">="|"<="|"=="|"!="|">"|"<"  return RELOP;
[=+\-*/;(){}]           return yytext[0];
[ \t\r\n]+              ;
.                       return yytext[0];
