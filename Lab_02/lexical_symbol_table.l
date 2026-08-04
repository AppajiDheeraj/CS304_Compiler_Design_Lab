%option noyywrap yylineno

%{
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

struct Symbol {
    string name;
    string tokenType;
    string dataType;
    int lineNumber;
    string storageClass;
};

vector<Symbol> symbolTable;
int keywordCount = 0;
int identifierCount = 0;
int integerCount = 0;
int floatingCount = 0;
int characterCount = 0;
int stringCount = 0;

string currentDataType;
string currentStorageClass;
bool declarationInProgress = false;

void addSymbol(const string &name, const string &tokenType,
               const string &dataType, int lineNumber,
               const string &storageClass)
{
    for (Symbol &symbol : symbolTable) {
        if (symbol.name == name && symbol.tokenType == tokenType) {
            if (symbol.dataType == "-" && dataType != "-") {
                symbol.dataType = dataType;
            }
            if (symbol.storageClass == "-" && storageClass != "-") {
                symbol.storageClass = storageClass;
            }
            return;
        }
    }

    symbolTable.push_back({name, tokenType, dataType, lineNumber,
                           storageClass});
}

void printSymbolTable()
{
    cout << "\nSYMBOL TABLE\n";
    cout << left << setw(24) << "Name"
         << setw(22) << "Token Type"
         << setw(18) << "Data Type"
         << setw(12) << "Line No."
         << "Storage Class" << '\n';
    cout << string(90, '-') << '\n';

    for (const Symbol &symbol : symbolTable) {
        cout << left << setw(24) << symbol.name
             << setw(22) << symbol.tokenType
             << setw(18) << symbol.dataType
             << setw(12) << symbol.lineNumber
             << symbol.storageClass << '\n';
    }
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

^[ \t]*#[^\n]*              {
                                currentDataType.clear();
                                currentStorageClass.clear();
                                declarationInProgress = false;
                            }
"//"[^\n]*                  { /* Ignore a single-line comment. */ }
"/*"                        { BEGIN(COMMENT); }
<COMMENT>"*/"               { BEGIN(INITIAL); }
<COMMENT>\n                 { /* yylineno is updated automatically. */ }
<COMMENT>.                  { }

{STRING}                    {
                                stringCount++;
                                addSymbol(yytext, "String Literal", "char[]",
                                          yylineno, "-");
                            }
{CHARACTER}                 {
                                characterCount++;
                                addSymbol(yytext, "Character Constant", "char",
                                          yylineno, "-");
                            }
{FLOAT}                     {
                                floatingCount++;
                                addSymbol(yytext, "Floating Constant", "double",
                                          yylineno, "-");
                            }
{INTEGER}                   {
                                integerCount++;
                                addSymbol(yytext, "Integer Constant", "int",
                                          yylineno, "-");
                            }
{STORAGE}                   {
                                keywordCount++;
                                currentStorageClass = yytext;
                                declarationInProgress = true;
                            }
{TYPE}                      {
                                keywordCount++;
                                if (currentDataType.empty()) {
                                    currentDataType = yytext;
                                } else {
                                    currentDataType += " ";
                                    currentDataType += yytext;
                                }
                                declarationInProgress = true;
                            }
signed|unsigned             {
                                keywordCount++;
                                currentDataType = yytext;
                                declarationInProgress = true;
                            }
{KEYWORD}                   { keywordCount++; }
{ID}                        {
                                identifierCount++;
                                addSymbol(yytext, "Identifier",
                                          declarationInProgress ? currentDataType : "-",
                                          yylineno,
                                          declarationInProgress && !currentStorageClass.empty()
                                              ? currentStorageClass : "-");
                            }
;                           {
                                currentDataType.clear();
                                currentStorageClass.clear();
                                declarationInProgress = false;
                            }
\{                          {
                                currentDataType.clear();
                                currentStorageClass.clear();
                                declarationInProgress = false;
                            }
[ \t\r\n]+                 { }
.                           { }

%%

int main()
{
    yylex();

    cout << "TOKEN COUNTS\n";
    cout << "Keywords             : " << keywordCount << '\n';
    cout << "Identifiers          : " << identifierCount << '\n';
    cout << "Integer constants    : " << integerCount << '\n';
    cout << "Floating constants   : " << floatingCount << '\n';
    cout << "Character constants  : " << characterCount << '\n';
    cout << "String literals      : " << stringCount << '\n';

    printSymbolTable();
    return 0;
}
