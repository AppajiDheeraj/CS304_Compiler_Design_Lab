%{
#include <stdio.h>

extern int yylex(void), yylineno;
void yyerror(const char *message);
int error_count;

static int function_type, first_return_type, saw_return, conflicting_return;
static int nested_depth;

static void report(const char *message)
{
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, message);
    error_count++;
}

static void record_return(int type)
{
    if (nested_depth)
        return;
    if (saw_return && first_return_type != type)
        conflicting_return = 1;
    else if (!saw_return)
        first_return_type = type;
    saw_return = 1;
}
%}

%union { int type; }
%token INT FLOAT VOID RETURN FOR WHILE ID INT_NUM FLOAT_NUM LE GE EQ NE
%type <type> type expression
%left '+' '-'
%left '*' '/'

%%
program: functions;
functions: function | functions function;
function: type
          { function_type = $1; saw_return = conflicting_return = 0; }
          ID '(' parameters ')' '{' statements '}'
          {
              if (function_type != 0 && !saw_return)
                  report("missing return statement in non-void function");
              if (conflicting_return)
                  report("conflicting types in multiple return statements");
          };
parameters: /* empty */ | typed_parameters;
typed_parameters: parameter | typed_parameters ',' parameter;
parameter: type ID
         | ID
           { report("missing parameter type in function header"); };
type: INT { $$ = 1; } | FLOAT { $$ = 2; } | VOID { $$ = 0; };
statements: /* empty */ | statements statement;
statement: declaration ';' | assignment ';' | return_statement ';' | loop | nested_function
         | declaration error
           { report("missing semicolon in function body"); yyerrok; }
         | assignment error
           { report("missing semicolon in function body"); yyerrok; }
         | return_statement error
           { report("missing semicolon in function body"); yyerrok; };
declaration: type ID | type assignment;
assignment: ID '=' expression;
return_statement: RETURN expression { record_return($2); };
nested_function: type ID '(' parameters ')' '{'
                 { nested_depth++; }
                 statements '}'
                 { nested_depth--; report("invalid nested function definition"); };
loop: WHILE '(' condition ')' '{' statements '}'
    | FOR '(' assignment ';' condition ';' assignment ')' '{' statements '}';
condition: expression relop expression;
relop: '<' | '>' | LE | GE | EQ | NE;
expression: ID { $$ = function_type; }
          | INT_NUM { $$ = 1; }
          | FLOAT_NUM { $$ = 2; }
          | expression '+' expression { $$ = ($1 == 2 || $3 == 2) ? 2 : 1; }
          | expression '-' expression { $$ = ($1 == 2 || $3 == 2) ? 2 : 1; }
          | expression '*' expression { $$ = ($1 == 2 || $3 == 2) ? 2 : 1; }
          | expression '/' expression { $$ = ($1 == 2 || $3 == 2) ? 2 : 1; }
          | '(' expression ')' { $$ = $2; };
%%

void yyerror(const char *message)
{
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, message);
    error_count++;
}

int main(void)
{
    int parse_status;
    puts("TOKEN        LEXEME       LINE");
    parse_status = yyparse();
    if (!parse_status && !error_count)
        puts("Parsing successful");
    return parse_status || error_count != 0;
}
