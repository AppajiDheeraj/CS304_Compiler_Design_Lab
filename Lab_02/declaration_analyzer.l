%option noyywrap yylineno

%{
#include <algorithm>
#include <iomanip>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

using namespace std;

struct Declaration {
    string name;
    string category;
    string dataType;
    string dimensions;
    string parameterCount;
    int lineNumber;
};

vector<Declaration> symbolTable;

string trim(const string &value)
{
    size_t first = value.find_first_not_of(" \t\r\n");
    if (first == string::npos) {
        return "";
    }
    size_t last = value.find_last_not_of(" \t\r\n");
    return value.substr(first, last - first + 1);
}

int countParameters(const string &parameters)
{
    string text = trim(parameters);
    if (text.empty() || text == "void") {
        return 0;
    }

    int count = 1;
    int nestedDepth = 0;
    for (char ch : text) {
        if (ch == '<' || ch == '(' || ch == '[') {
            nestedDepth++;
        } else if (ch == '>' || ch == ')' || ch == ']') {
            nestedDepth--;
        } else if (ch == ',' && nestedDepth == 0) {
            count++;
        }
    }
    return count;
}

void addDeclaration(const Declaration &declaration)
{
    for (const Declaration &entry : symbolTable) {
        if (entry.name == declaration.name &&
            entry.category == declaration.category &&
            entry.lineNumber == declaration.lineNumber) {
            return;
        }
    }
    symbolTable.push_back(declaration);
}

void analyzeDeclaration(const string &lexeme, int lineNumber)
{
    static const regex declarationPattern(
        R"(^\s*(?:(auto|static|extern|register)\s+)?((?:(?:signed|unsigned)\s+)?(?:void|bool|char|short|int|long|float|double)|std::string|string)\s+(.+?)\s*([;{])\s*$)");
    smatch declarationMatch;
    if (!regex_match(lexeme, declarationMatch, declarationPattern)) {
        return;
    }

    string dataType = trim(declarationMatch[2].str());
    string declarator = trim(declarationMatch[3].str());

    static const regex functionPattern(
        R"(^([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*$)");
    smatch functionMatch;
    if (regex_match(declarator, functionMatch, functionPattern)) {
        addDeclaration({functionMatch[1].str(), "Function", dataType, "-",
                        to_string(countParameters(functionMatch[2].str())),
                        lineNumber});
        return;
    }

    static const regex arrayPattern(
        R"((?:^|,)\s*([A-Za-z_][A-Za-z0-9_]*)\s*\[\s*([^\]]*)\s*\](?:\s*\[\s*([^\]]*)\s*\])?)");
    for (sregex_iterator it(declarator.begin(), declarator.end(), arrayPattern), end;
         it != end; ++it) {
        string dimensions = trim((*it)[2].str());
        if ((*it)[3].matched) {
            dimensions += " x " + trim((*it)[3].str());
        }
        addDeclaration({(*it)[1].str(), "Array", dataType, dimensions, "-",
                        lineNumber});
    }
}

void printSymbolTable()
{
    cout << "ARRAY AND FUNCTION SYMBOL TABLE\n";
    cout << left << setw(20) << "Name"
         << setw(14) << "Category"
         << setw(20) << "Data/Return Type"
         << setw(20) << "Dimensions"
         << setw(14) << "Parameters"
         << "Line No." << '\n';
    cout << string(98, '-') << '\n';

    for (const Declaration &entry : symbolTable) {
        cout << left << setw(20) << entry.name
             << setw(14) << entry.category
             << setw(20) << entry.dataType
             << setw(20) << entry.dimensions
             << setw(14) << entry.parameterCount
             << entry.lineNumber << '\n';
    }
}
%}

%x COMMENT

WS          [ \t]+
STORAGE     (auto|static|extern|register)
SIGN        (signed|unsigned)
BASETYPE    (void|bool|char|short|int|long|float|double)
TYPE        (({SIGN}{WS})?{BASETYPE}|std::string|string)
DECLARATION ^[ \t]*({STORAGE}{WS})?{TYPE}{WS}+[^;{}\n]+[;{]
FUNCTIONDEF ^[ \t]*({STORAGE}{WS})?{TYPE}{WS}+[^;{}\n]+\)[ \t]*\n[ \t]*\{

%%

"//"[^\n]*                  { }
"/*"                        { BEGIN(COMMENT); }
<COMMENT>"*/"               { BEGIN(INITIAL); }
<COMMENT>\n                 { }
<COMMENT>.                  { }
{FUNCTIONDEF}                {
                                int startLine = yylineno;
                                for (int i = 0; i < yyleng; i++) {
                                    if (yytext[i] == '\n') {
                                        startLine--;
                                    }
                                }
                                analyzeDeclaration(yytext, startLine);
                            }
{DECLARATION}               { analyzeDeclaration(yytext, yylineno); }
\n                          { }
.                           { }

%%

int main()
{
    yylex();
    printSymbolTable();
    return 0;
}
