%{
#include "question_2.tab.h"
%}

%%

"while"                 return WHILE;
"for"                   return FOR;
[a-zA-Z_][a-zA-Z0-9_]*  return ID;
[0-9]+                  return NUMBER;
">="|"<="|"=="|"!="|">"|"<"  return RELOP;
[=+\-*/;(){}]           return yytext[0];
[ \t\r\n]+              ;
.                       return yytext[0];

%%

int yywrap(void)
{
    return 1;
}
