%option noyywrap yylineno

%{
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

struct Entry {
    string name, category, dataType, dimensions, parameters;
    int lineNumber;
};

vector<Entry> table;
string currentType;

string trim(string text)
{
    size_t first = text.find_first_not_of(" \t,;");
    size_t last = text.find_last_not_of(" \t,;");
    return first == string::npos ? "" : text.substr(first, last - first + 1);
}

void getTypeAndName(string text, char marker, string &type, string &name)
{
    string head = trim(text.substr(0, text.find(marker)));
    size_t space = head.find_last_of(" \t");
    name = head.substr(space + 1);
    type = trim(head.substr(0, space));

    string storage[] = {"auto ", "static ", "extern ", "register "};
    for (const string &word : storage)
        if (type.find(word) == 0) type.erase(0, word.length());
}

string getDimensions(string text)
{
    string dimensions;
    size_t open = text.find('[');
    while (open != string::npos) {
        size_t close = text.find(']', open);
        if (!dimensions.empty()) dimensions += " x ";
        dimensions += trim(text.substr(open + 1, close - open - 1));
        open = text.find('[', close);
    }
    return dimensions;
}

void addArray(string text, bool hasType)
{
    string name, type = currentType;
    if (hasType) {
        getTypeAndName(text, '[', type, name);
        currentType = type;
    } else {
        name = trim(text.substr(0, text.find('[')));
    }
    table.push_back({name, "Array", type, getDimensions(text), "-", yylineno});
}

void addFunction(string text)
{
    string type, name;
    getTypeAndName(text, '(', type, name);

    size_t open = text.find('('), close = text.rfind(')');
    string parameters = trim(text.substr(open + 1, close - open - 1));
    int count = 0;
    if (!parameters.empty() && parameters != "void") {
        count = 1;
        for (char ch : parameters)
            if (ch == ',') count++;
    }
    table.push_back({name, "Function", type, "-", to_string(count), yylineno});
}
%}

%x COMMENT

WS          [ \t]+
OPTWS       [ \t]*
ID          [A-Za-z_][A-Za-z0-9_]*
STORAGE     (auto|static|extern|register)
TYPE        (((signed|unsigned){WS})?(void|bool|char|short|int|long|float|double)|std::string|string)
DIMENSION   \[[^]\n]*\]
FUNCTION    ({STORAGE}{WS})?{TYPE}{WS}+{ID}{OPTWS}\([^()\n]*\)
ARRAY       ({STORAGE}{WS})?{TYPE}{WS}+{ID}{OPTWS}{DIMENSION}({OPTWS}{DIMENSION})?
MORE_ARRAY  ,{OPTWS}{ID}{OPTWS}{DIMENSION}({OPTWS}{DIMENSION})?

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
