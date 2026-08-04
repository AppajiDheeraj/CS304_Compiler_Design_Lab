%option noyywrap yylineno

%{
#include <iostream>
#include <string>
#include <vector>
using namespace std;

struct Entry {
    string name, category, type, dimensions, parameters;
    int line;
};

vector<Entry> table;
string currentType;

string trim(string text)
{
    size_t first = text.find_first_not_of(" \t,;");
    if (first == string::npos) return "";
    return text.substr(first, text.find_last_not_of(" \t,;") - first + 1);
}

void splitHead(string text, char marker, string &type, string &name)
{
    string head = trim(text.substr(0, text.find(marker)));
    size_t space = head.find_last_of(" \t");
    type = trim(head.substr(0, space));
    name = head.substr(space + 1);
}

string dimensions(string text)
{
    size_t first = text.find('['), close = text.find(']', first);
    string result = trim(text.substr(first + 1, close - first - 1));
    size_t second = text.find('[', close);
    if (second != string::npos) {
        close = text.find(']', second);
        result += " x " + trim(text.substr(second + 1, close - second - 1));
    }
    return result;
}

void addArray(string text, bool typed)
{
    string name, type = currentType;
    if (typed) {
        splitHead(text, '[', type, name);
        currentType = type;
    } else {
        if (type.empty()) return;
        name = trim(text.substr(0, text.find('[')));
    }
    table.push_back({name, "Array", type, dimensions(text), "-", yylineno});
}

void addFunction(string text)
{
    string type, name;
    splitHead(text, '(', type, name);
    size_t open = text.find('('), close = text.rfind(')');
    string params = trim(text.substr(open + 1, close - open - 1));
    int count = (params.empty() || params == "void") ? 0 : 1;
    for (char ch : params) if (ch == ',') count++;
    table.push_back({name, "Function", type, "-", to_string(count), yylineno});
}
%}

%x COMMENT

WS          [ \t]+
OPTWS       [ \t]*
ID          [A-Za-z_][A-Za-z0-9_]*
TYPE        (((signed|unsigned){WS})?(void|bool|char|short|int|long|float|double)|std::string|string)
DIM         \[[^]\n]*\]
FUNCTION    {TYPE}{WS}+{ID}{OPTWS}\([^()\n]*\)
ARRAY       {TYPE}{WS}+{ID}{OPTWS}{DIM}({OPTWS}{DIM})?
MORE_ARRAY  ,{OPTWS}{ID}{OPTWS}{DIM}({OPTWS}{DIM})?

%%

"//"[^\n]*                 { }
"/*"                       { BEGIN(COMMENT); }
<COMMENT>"*/"              { BEGIN(INITIAL); }
<COMMENT>\n|<COMMENT>.      { }
{FUNCTION}                  { addFunction(yytext); }
{ARRAY}                     { addArray(yytext, true); }
{MORE_ARRAY}                { addArray(yytext, false); }
;                           { currentType.clear(); }
\n|.                          { }

%%

int main()
{
    yylex();
    cout << "Name\tCategory\tData/Return Type\tDimensions\tParameter Count\tLine Number\n";
    for (const Entry &entry : table)
        cout << entry.name << '\t' << entry.category << '\t' << entry.type
             << '\t' << entry.dimensions << '\t' << entry.parameters
             << '\t' << entry.line << '\n';
    return 0;
}
