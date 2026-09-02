%{
#include <iostream>
#include <string>
using namespace std;

int yylex();
void yyerror(const char *message);
extern char *yytext;
%}

%error-verbose
%locations
%token IF ELSE ID NUMBER RELOP INVALID
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
    string error(message);
    cout << "Syntax error at line " << yylloc.first_line << ": ";

    if (error.find("unexpected INVALID") != string::npos)
        cout << "unexpected token '" << yytext << "'.";
    else if (error.find("expecting ';'") != string::npos)
        cout << "missing ';'.";
    else if (error.find("expecting ')'") != string::npos)
        cout << "missing ')'.";
    else if (error.find("expecting '('") != string::npos)
        cout << "missing '('.";
    else if (error.find("expecting ID") != string::npos ||
             error.find("expecting NUMBER") != string::npos)
        cout << "invalid expression near '" << yytext << "'.";
    else
        cout << message << ".";

    cout << endl;
}

int main()
{
    return yyparse();
}
