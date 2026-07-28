%{
#include <iostream>
#include <cstring>
using namespace std;
%}

%%

int|float|double|char|break|while|for|continue|switch|auto|bool|if|else|return|void    { cout << "Invalid identifier: It is a keyword" << endl; }
[_a-zA-Z][_a-zA-Z0-9]*    { cout << "Valid identifier" << endl; }
[0-9][_a-zA-Z0-9]*        { cout << "Invalid identifier: Cannot start with a digit" << endl; }
\n                         { }
.+                         { cout << "Invalid identifier" << endl; }

%%

int yywrap()
{
    return 1;
}

int main()
{
    cout << "Enter an identifier: ";
    yylex();

    return 0;
}