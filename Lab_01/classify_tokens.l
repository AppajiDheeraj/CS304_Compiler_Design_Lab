%{
#include <iostream>
using namespace std;

int keywords = 0;
int identifiers = 0;
int strings = 0;
int characters = 0;
int operators = 0;
int delimiters = 0;
%}

%%

"//".*                                                      { }
\"([^\\\n]|\\.)*\"                                         { strings++; }
\'([^\\\n]|\\.)\'                                          { characters++; }
int|float|double|char|break|while|for|continue|switch|auto|bool|if|else|return|void      { keywords++; }
[_a-zA-Z][_a-zA-Z0-9]*                                     { identifiers++; }
==|>=|<=|&&|\|\||!=|=|\+|-|\*|\/|%|\+\+|--|>|<            { operators++; }
\{|\}|\[|\]|\(|\)|;|:|,                                    { delimiters++; }
[ \t\n]+                                                   { }
.                                                          { }

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
    cout << "Strings are " << strings << endl;
    cout << "Characters are " << characters << endl;
    cout << "Operators are " << operators << endl;
    cout << "Delimiters are " << delimiters << endl;

    return 0;
}