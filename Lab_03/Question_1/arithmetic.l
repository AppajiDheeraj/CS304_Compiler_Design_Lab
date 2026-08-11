%option noyywrap

%{
#include <stdlib.h>
#include "arithmetic.tab.h"

int error_type = 0;
char last_char = 0;
%}

%%

[0-9]+(\.[0-9]+)?   { yylval.number = atof(yytext); last_char = 0; return NUMBER; }
[+*/-][+*/-]         { error_type = 2; return BAD_OPERATOR; }
[+\-*/()]            { last_char = yytext[0]; return yytext[0]; }
[ \t\r]+             { }
\n                   { return '\n'; }
.                    { error_type = 1; last_char = yytext[0]; return INVALID; }

%%
