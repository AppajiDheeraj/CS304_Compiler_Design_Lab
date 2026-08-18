%option noyywrap

%{
    #include"string.tab.h"
    #include<bits/stdc++.h>
    using namespace std;
%}

%%
[ab] {return yytext[0];};
[ \t]+;
\n {return '\n';}
.;
%%