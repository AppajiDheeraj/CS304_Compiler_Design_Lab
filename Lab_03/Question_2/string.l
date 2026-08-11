%option noyywrap

%%

[ab]      { return yytext[0]; }
[ \t\r]+  { }
\n        { return '\n'; }
.         { return yytext[0]; }

%%
