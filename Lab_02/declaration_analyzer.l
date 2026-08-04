%option noyywrap yylineno

%{
#include <algorithm>
#include <iomanip>
#include <iostream>
#include <regex>
#include <string>
#include <vector>
using namespace std;

struct Entry {
    string name, category, dataType, dimensions, parameters;
    int lineNumber;
};

vector<Entry> table;

string trim(string text)
{
    size_t first = text.find_first_not_of(" \t\r\n");
    size_t last = text.find_last_not_of(" \t\r\n;{");
    return first == string::npos ? "" : text.substr(first, last - first + 1);
}

void analyze(string text)
{
    static const regex declaration(
        R"(^\s*(?:(?:auto|static|extern|register)\s+)?((?:(?:signed|unsigned)\s+)?(?:void|bool|char|short|int|long|float|double)|std::string|string)\s+(.+))");
    smatch match;
    if (!regex_search(text, match, declaration)) return;

    string type = match[1], part = trim(match[2]);
    size_t open = part.find('(');

    if (open != string::npos) {
        string name = trim(part.substr(0, open));
        string params = trim(part.substr(open + 1, part.rfind(')') - open - 1));
        int count = (params.empty() || params == "void") ? 0 : 1 + std::count(params.begin(), params.end(), ',');
        table.push_back({name, "Function", type, "-", to_string(count), yylineno});
        return;
    }

    static const regex array(
        R"(([A-Za-z_][A-Za-z0-9_]*)\s*\[\s*([^\]]*)\s*\](?:\s*\[\s*([^\]]*)\s*\])?)");
    for (sregex_iterator it(part.begin(), part.end(), array), end; it != end; ++it) {
        string dimensions = trim((*it)[2]);
        if ((*it)[3].matched) dimensions += " x " + trim((*it)[3]);
        table.push_back({(*it)[1], "Array", type, dimensions, "-", yylineno});
    }
}
%}

%x COMMENT

WS          [ \t]+
STORAGE     (auto|static|extern|register)
TYPE        (((signed|unsigned){WS})?(void|bool|char|short|int|long|float|double)|std::string|string)
CANDIDATE   ^[ \t]*({STORAGE}{WS})?{TYPE}{WS}+[^;{}\n]+[;{]?

%%

"//"[^\n]*                 { }
"/*"                       { BEGIN(COMMENT); }
<COMMENT>"*/"              { BEGIN(INITIAL); }
<COMMENT>\n|<COMMENT>.      { }
{CANDIDATE}                 { analyze(yytext); }
\n|.                          { }

%%

int main()
{
    yylex();

    cout << "ARRAY AND FUNCTION SYMBOL TABLE\n"
         << left << setw(20) << "Name" << setw(14) << "Category"
         << setw(20) << "Data/Return Type" << setw(20) << "Dimensions"
         << setw(14) << "Parameters" << "Line No.\n"
         << string(98, '-') << '\n';

    for (const Entry &entry : table)
        cout << left << setw(20) << entry.name << setw(14) << entry.category
             << setw(20) << entry.dataType << setw(20) << entry.dimensions
             << setw(14) << entry.parameters << entry.lineNumber << '\n';
    return 0;
}
