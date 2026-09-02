%option noyywrap yylineno

%{
#include "question_1.tab.hpp"

#define TOKEN(value) (yylloc.first_line = yylloc.last_line = yylineno, (value))
%}

%%

"if"                    return TOKEN(IF);
"else"                  return TOKEN(ELSE);
[a-zA-Z_][a-zA-Z0-9_]*  return TOKEN(ID);
[0-9]+                  return TOKEN(NUMBER);
">="|"<="|"=="|"!="|">"|"<"  return TOKEN(RELOP);
[=+\-*/;(){}]           return TOKEN(yytext[0]);
[ \t\r\n]+              ;
.                       return TOKEN(INVALID);
