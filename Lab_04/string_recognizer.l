%option noyywrap

%%

[012]       { return yytext[0]; }
[ \t\r]+    { }
\n          { return '\n'; }
.           { return yytext[0]; }

%%
