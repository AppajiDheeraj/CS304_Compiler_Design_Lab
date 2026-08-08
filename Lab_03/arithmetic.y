%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
extern int error_kind, last_token;
%}

%union { double value; }
%token <value> NUMBER
%token BAD_OPERATOR INVALID
%type <value> expression
%left '+' '-'
%left '*' '/'

%%

input:
      expression '\n' { printf("Result = %g\n", $1); }
    ;

expression:
      NUMBER
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression
        {
            if ($3 == 0) { error_kind = 3; YYERROR; }
            $$ = $1 / $3;
        }
    | '(' expression ')' { $$ = $2; }
    ;

%%

void yyerror(const char *message)
{
    (void)message;
    if (error_kind == 1)
        printf("Lexical Error: Invalid symbol '%c'\n", last_token);
    else if (error_kind == 2)
        printf("Syntax Error: Invalid operator sequence\n");
    else if (error_kind == 3)
        printf("Math Error: Division by zero\n");
    else if (last_token == '+' || last_token == '-' || last_token == '*' || last_token == '/')
        printf("Syntax Error: Incomplete expression\n");
    else
        printf("Syntax Error: Invalid expression\n");
}

int main(void)
{
    return yyparse();
}
