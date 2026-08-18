%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
%}

%%

input:
    S '\n' { puts("VALID"); };

S:
    '1' S
    | '1' A;

A:
    '0' A
    | '0' '1';

%%

void yyerror(const char *message)
{
    (void)message;
    puts("INVALID");
}

int main(void)
{
    return yyparse();
}
