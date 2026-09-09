%{
#include <stdio.h>

extern int yylex(void), yylineno;
void yyerror(const char *message);
int error_count;

static void report(const char *message)
{
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, message);
    error_count++;
}
%}

%token FOR WHILE INT FLOAT ID INT_NUM FLOAT_NUM LE GE EQ NE INC DEC
%left '+' '-'
%left '*' '/'

%%
program: loops;
loops: /* empty */ | loops loop;
loop: for_loop | while_loop
    | ID '(' condition ')' block
      { report("unrecognized loop construct (invalid keyword)"); }
    | ID '(' init ';' condition ';' update ')' block
      { report("unrecognized loop construct (invalid keyword)"); };
for_loop: FOR '(' init ';' condition ';' update ')' block
        | FOR '(' nonempty_init condition ';' update ')' block
          { report("missing semicolon in for-loop header"); }
        | FOR '(' init ';' condition update ')' block
          { report("missing semicolon in for-loop header"); };
while_loop: WHILE '(' condition ')' block
          | WHILE '(' ')' block
            { report("missing condition in while loop"); };
block: '{' loops '}'
     | '{' loops error
       { report("missing closing brace '}'"); yyerrok; };
init: /* empty */ | declaration | assignment;
nonempty_init: declaration | assignment;
declaration: type ID | type assignment;
type: INT | FLOAT;
assignment: ID '=' expression;
condition: expression relop expression;
relop: '<' | '>' | LE | GE | EQ | NE;
update: ID update_tail
      | '(' expression ')'
        { report("unsupported update expression in for loop"); }
      | INT_NUM
        { report("unsupported update expression in for loop"); }
      | FLOAT_NUM
        { report("unsupported update expression in for loop"); };
update_tail: INC | DEC | '=' expression
           | '+' expression
             { report("unsupported update expression in for loop"); }
           | '-' expression
             { report("unsupported update expression in for loop"); }
           | '*' expression
             { report("unsupported update expression in for loop"); }
           | '/' expression
             { report("unsupported update expression in for loop"); };
expression: ID | INT_NUM | FLOAT_NUM
          | expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | '(' expression ')';
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
