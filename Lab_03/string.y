%{
    #include <bits/stdc++.h>
    using namespace std;
    int yylex();
    void yyerror(const char* message);
%}

%%
input:
    exp '\n' {
        cout <<"VALID"<<endl;
        YYACCEPT;
    };
exp : 
    'a' exp | 'a' 'b';
%%

void yyerror(const char* message){
    cout<<"INVALID"<<endl;
}

int main(){
    cout<<"Enter the string "<<endl;
    yyparse();
}