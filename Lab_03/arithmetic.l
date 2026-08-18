%option noyywrap

%{
    #define YYSTYPE double
    #include<iostream>
    #include "arithmetic.tab.h"
    using namespace std;
%}

%%
[0-9]+(\.[0-9]+)? {yylval = atof(yytext); return NUMBER;}
[+-/*()] {return yytext[0];}
[ \t]+ ;
\n {return '\n';}
. {
    cout<<"Lexical Error: Invalid Symbol %s\n"<<yytext;
}
%%

