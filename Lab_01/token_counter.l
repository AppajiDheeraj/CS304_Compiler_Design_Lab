%{
#include <iostream>
using namespace std;

int keywords = 0;
int identifiers = 0;
int integers = 0;
int floating = 0;
int operators = 0;
int special = 0;
%}

%%

"//".*                                              { }
[0-9]*\.[0-9]+                                     { floating++; }
int|float|double|char|break|while|for|continue|switch|auto|bool|if|else|return|void                { keywords++; }
[_a-zA-Z][_a-zA-Z0-9]*                             { identifiers++; }
[0-9]+                                             { integers++; }
==|>=|<=|&&|\|\||!=|=|\+|-|\*|\/|%|\+\+|--        { operators++; }
\{|\}|\[|\]|\(|\)|;|:|,                            { special++; }
[ \t\n]+                                           { }
.                                                  { }

%%

int yywrap()
{
    return 1;
}

int main()
{
    yylex();

    cout << "\nKeywords are " << keywords << endl;
    cout << "Identifiers are " << identifiers << endl;
    cout << "Floating numbers are " << floating << endl;
    cout << "Integers are " << integers << endl;
    cout << "Operators are " << operators << endl;
    cout << "Special symbols are " << special << endl;

    return 0;
}