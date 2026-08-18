%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
%}

%%

input:
    S '\n' { puts("VALID"); };

S:
    '0' S
    | '0' '1' '2';

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
