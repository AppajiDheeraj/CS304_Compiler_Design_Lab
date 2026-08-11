%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
%}

%%

input:
    S '\n' { printf("Valid String\n"); }
    ;

S:
      'a' S
    | 'a' 'b'
    ;

%%

void yyerror(const char *message)
{
    (void)message;
    printf("Invalid String\n");
}

int main(void)
{
    return yyparse();
}
