%{
#include <iostream>
using namespace std;

int yylex();
void yyerror(const char *message);
%}

%token IF ELSE ID NUMBER RELOP
%left '+' '-'
%left '*' '/'
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
    statement { cout << "Valid Statement" << endl; }
    ;

statement:
    matched
    | unmatched
    ;

matched:
    assignment ';'
    | '{' statements '}'
    | IF '(' condition ')' matched ELSE matched
    ;

unmatched:
    IF '(' condition ')' statement %prec LOWER_THAN_ELSE
    | IF '(' condition ')' matched ELSE unmatched
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
    cout << "Syntax error: invalid if-else statement "
         << "(check condition, parentheses, and semicolons)." << endl;
}

int main()
{
    return yyparse();
}
