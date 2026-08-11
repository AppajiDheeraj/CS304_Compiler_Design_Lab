%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
extern int error_type;
extern char last_char;
%}

%union { double number; }
%token <number> NUMBER
%token BAD_OPERATOR INVALID
%type <number> expression
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
            if ($3 == 0) { printf("Math Error: Division by zero\n"); YYABORT; }
            $$ = $1 / $3;
        }
    | '(' expression ')' { $$ = $2; }
    ;

%%

void yyerror(const char *message)
{
    (void)message;

    if (error_type == 1)
        printf("Lexical Error: Invalid symbol '%c'\n", last_char);
    else if (error_type == 2)
        printf("Syntax Error: Invalid operator sequence\n");
    else if (last_char == '+' || last_char == '-' || last_char == '*' || last_char == '/')
        printf("Syntax Error: Incomplete expression\n");
    else
        printf("Syntax Error: Invalid expression\n");
}

int main(void)
{
    return yyparse();
}
