%option noyywrap yylineno

%{
#include "question_2.tab.hpp"

#define TOKEN(value) (yylloc.first_line = yylloc.last_line = yylineno, (value))
%}

%%

"while"                 return TOKEN(WHILE);
"for"                   return TOKEN(FOR);
[a-zA-Z_][a-zA-Z0-9_]*  return TOKEN(ID);
[0-9]+                  return TOKEN(NUMBER);
">="|"<="|"=="|"!="|">"|"<"  return TOKEN(RELOP);
[=+\-*/;(){}]           return TOKEN(yytext[0]);
[ \t\r\n]+              ;
.                       return TOKEN(INVALID);
