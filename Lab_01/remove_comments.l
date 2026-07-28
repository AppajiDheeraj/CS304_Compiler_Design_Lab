%{
#include <iostream>
using namespace std;
%}

%x COMMENT

%%

"//".*          { }
"/*"            { BEGIN(COMMENT); }
<COMMENT>"*/"   { BEGIN(INITIAL); }
<COMMENT>\n     { cout << endl; }
<COMMENT>.      { }
\n              { cout << endl; }
.               { cout << yytext; }

%%

int yywrap()
{
    return 1;
}

int main()
{
    yylex();
    return 0;
}