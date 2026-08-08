%option noyywrap

%{
#include "arithmetic.tab.h"

int error_kind = 0;
int last_token = 0;
%}

%%

[0-9]+(\.[0-9]+)?     { yylval.value = atof(yytext); last_token = 0; return NUMBER; }
[+*/-][+*/-]           { error_kind = 2; last_token = yytext[0]; return BAD_OPERATOR; }
[+\-*/()]             { last_token = yytext[0]; return yytext[0]; }
[ \t\r]+              { }
\n                    { return '\n'; }
.                     { error_kind = 1; last_token = yytext[0]; return INVALID; }

%%
