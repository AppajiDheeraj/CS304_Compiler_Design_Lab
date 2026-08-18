%{
    #define YYSTYPE double
    #include <bits/stdc++.h>
    using namespace std;
    int yylex();
    void yyerror(const char* message);
%}


%token NUMBER;
%left '+' '-';
%left '*' '/';
%right UMINUS;

%%
input:
    exp '\n' {
        cout << "Result = "<<$1<<endl;
        YYACCEPT;
    };
exp : 
    exp '+' exp {$$ = $1 + $3;} |
    exp '-' exp {$$ = $1 - $3;} |
    exp '*' exp {$$ = $1 * $3;} |
    exp '/' exp {
        if($3 == 0) {
            yyerror("Division by Zero");
            YYABORT;
        }
        $$ = $1/$3;
    }
    | '(' exp ')' {$$ = $2;}
    | '-' exp %prec UMINUS {$$ = -$2;}
    | NUMBER {$$ = $1;}

%%

void yyerror(const char* message){
    cout<<"ERROR"<<string(message)<<endl;
}

int main(){
    cout<<"Enter the expression "<<endl;
    yyparse();
}