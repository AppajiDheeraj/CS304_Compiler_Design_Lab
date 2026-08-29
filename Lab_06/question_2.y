%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *message);
%}

%token WHILE FOR ID NUMBER RELOP
%left '+' '-'
%left '*' '/'

%%

program:
    statement { puts("Valid Statement"); }
    ;

statement:
    assignment ';'
    | WHILE '(' condition ')' statement
    | FOR '(' assignment ';' condition ';' assignment ')' statement
    | '{' statements '}'
    ;

statements:
    /* empty */
    | statements statement
    ;

assignment:
    ID '=' expression
    ;

condition:
    expression RELOP expression
    | expression
    ;

expression:
    ID
    | NUMBER
    | '(' expression ')'
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    ;

%%

void yyerror(const char *message)
{
    (void)message;
    puts("Syntax error: invalid loop (check parentheses, semicolons, and expressions).");
}

int main(void)
{
    return yyparse();
}
