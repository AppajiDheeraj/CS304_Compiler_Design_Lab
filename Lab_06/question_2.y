%{
#include <iostream>
using namespace std;

int yylex();
void yyerror(const char *message);
%}

%token WHILE FOR ID NUMBER RELOP
%left '+' '-'
%left '*' '/'

%%

program:
    statement { cout << "Valid Statement" << endl; }
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
    cout << "Syntax error: invalid loop "
         << "(check parentheses, semicolons, and expressions)." << endl;
}

int main()
{
    return yyparse();
}
