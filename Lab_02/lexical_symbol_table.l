%option noyywrap yylineno

%{
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

struct Symbol {
    string name, tokenType, dataType, storageClass;
    int lineNumber;
};

vector<Symbol> table;
int keywords = 0, identifiers = 0, integers = 0;
int floating = 0, characters = 0, strings = 0;
string dataType = "-", storageClass = "-";

void addSymbol(string name, string token, string type, string storage)
{
    for (Symbol &entry : table) {
        if (entry.name == name && entry.tokenType == token) {
            if (entry.dataType == "-" && type != "-") entry.dataType = type;
            if (entry.storageClass == "-" && storage != "-") entry.storageClass = storage;
            return;
        }
    }
    table.push_back({name, token, type, storage, yylineno});
}

void resetDeclaration()
{
    dataType = storageClass = "-";
}
%}

%x COMMENT

DIGIT       [0-9]
ID          [A-Za-z_][A-Za-z0-9_]*
EXPONENT    [eE][+-]?{DIGIT}+
FLOAT       (({DIGIT}+\.{DIGIT}*|\.{DIGIT}+){EXPONENT}?|{DIGIT}+{EXPONENT})[fFlL]?
INTEGER     (0[xX][0-9A-Fa-f]+|0[bB][01]+|0[0-7]+|{DIGIT}+)[uUlL]*
CHARACTER   \'([^\\\n']|\\.)\'
STRING      \"([^\\\n\"]|\\.)*\"
TYPE        (bool|char|short|int|long|float|double|void|string)
STORAGE     (auto|static|extern|register)
KEYWORD     (alignas|alignof|asm|break|case|catch|class|const|constexpr|continue|default|delete|do|else|enum|explicit|export|false|for|friend|goto|if|inline|mutable|namespace|new|noexcept|nullptr|operator|private|protected|public|return|sizeof|struct|switch|template|this|throw|true|try|typedef|typename|union|using|virtual|volatile|while)

%%

^[ \t]*#[^\n]*             { resetDeclaration(); }
"//"[^\n]*                 { }
"/*"                       { BEGIN(COMMENT); }
<COMMENT>"*/"              { BEGIN(INITIAL); }
<COMMENT>\n|<COMMENT>.      { }

{STRING}                    { strings++; addSymbol(yytext, "String Literal", "char[]", "-"); }
{CHARACTER}                 { characters++; addSymbol(yytext, "Character Constant", "char", "-"); }
{FLOAT}                     {
                                floating++;
                                string type = (yytext[yyleng - 1] == 'f' || yytext[yyleng - 1] == 'F') ? "float" : "double";
                                addSymbol(yytext, "Floating Constant", type, "-");
                            }
{INTEGER}                   { integers++; addSymbol(yytext, "Integer Constant", "int", "-"); }
{STORAGE}                   { keywords++; storageClass = yytext; }
signed|unsigned             { keywords++; dataType = yytext; }
{TYPE}                      {
                                keywords++;
                                if (dataType == "signed" || dataType == "unsigned") dataType += " " + string(yytext);
                                else dataType = yytext;
                            }
{KEYWORD}                   { keywords++; }
{ID}                        { identifiers++; addSymbol(yytext, "Identifier", dataType, storageClass); }
;|\{                        { resetDeclaration(); }
[ \t\r\n]+                { }
.                           { }

%%

int main()
{
    yylex();

    cout << "TOKEN COUNTS\n"
         << "Keywords             : " << keywords << '\n'
         << "Identifiers          : " << identifiers << '\n'
         << "Integer constants    : " << integers << '\n'
         << "Floating constants   : " << floating << '\n'
         << "Character constants  : " << characters << '\n'
         << "String literals      : " << strings << "\n\n"
         << "SYMBOL TABLE\n"
         << left << setw(24) << "Name" << setw(22) << "Token Type"
         << setw(18) << "Data Type" << setw(12) << "Line No." << "Storage Class\n"
         << string(90, '-') << '\n';

    for (const Symbol &entry : table)
        cout << left << setw(24) << entry.name << setw(22) << entry.tokenType
             << setw(18) << entry.dataType << setw(12) << entry.lineNumber
             << entry.storageClass << '\n';
    return 0;
}
