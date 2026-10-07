#include <algorithm>
#include <iostream>
#include <map>
#include <regex>
#include <set>
#include <stdexcept>
#include <string>
#include <vector>
using namespace std;
using Rule = vector<string>; // Empty rule means epsilon.
using Grammar = map<string, vector<Rule>>;
string fresh(const string& base, set<string>& used) {
    for (int i = 1;; ++i)
        if (string name = base + to_string(i); used.insert(name).second) return name;
}

Rule tokenize(const string& text, const vector<string>& names) {
    if (text == "#" || text == "ε" || text == "epsilon") return {};
    Rule rule;
    for (size_t pos = 0; pos < text.size();) {
        if (text[pos] == '"') {
            auto end = text.find('"', pos + 1);
            if (end == string::npos || end == pos + 1) throw runtime_error("invalid quoted terminal");
            rule.push_back(text.substr(pos + 1, end - pos - 1)); pos = end + 1;
        } else {
            // Longest known nonterminal, otherwise one terminal character.
            auto it = find_if(names.begin(), names.end(), [&](const string& name) { return text.compare(pos, name.size(), name) == 0; });
            if (it == names.end()) rule.push_back(text.substr(pos++, 1));
            else { rule.push_back(*it); pos += it->size(); }
        }
    }
    for (const auto& symbol : rule)
        if (symbol == "#" || symbol == "ε" || symbol == "epsilon") throw runtime_error("epsilon must be alone");
    return rule;
}

bool removeEpsilon(Grammar& grammar, const vector<string>& names) {
    set<string> nullable;
    bool changed;
    do {
        changed = false;
        for (const auto& name : names)
            for (const auto& rule : grammar[name])
                if (all_of(rule.begin(), rule.end(), [&](const string& s) { return nullable.count(s) != 0; }))
                    changed |= nullable.insert(name).second;
    } while (changed);
    bool startNullable = nullable.count(names.front()) != 0;
    for (const auto& name : names) {
        vector<Rule> expanded;
        for (const auto& rule : grammar[name]) {
            vector<Rule> variants(1);
            for (const auto& symbol : rule) {
                size_t count = variants.size();
                bool optional = nullable.count(symbol) != 0;
                if (optional) for (size_t i = 0; i < count; ++i) {
                    Rule copy = variants[i]; variants.push_back(copy);
                }
                for (size_t i = optional ? count : 0; i < variants.size(); ++i)
                    variants[i].push_back(symbol);
            }
            for (const auto& variant : variants)
                if (!variant.empty() && find(expanded.begin(), expanded.end(), variant) == expanded.end()) expanded.push_back(variant);
        }
        grammar[name] = expanded;
    }
    return startNullable;
}

void removeLeftRecursion(Grammar& grammar, vector<string>& names, set<string>& used) {
    vector<string> originals = names;
    for (size_t i = 0; i < originals.size(); ++i) {
        const string& name = originals[i];
        for (size_t j = 0; j < i; ++j) {
            vector<Rule> replaced;
            for (const auto& rule : grammar[name]) {
                if (!rule.empty() && rule[0] == originals[j]) {
                    for (const auto& prefix : grammar[originals[j]]) {
                        Rule next = prefix; next.insert(next.end(), rule.begin() + 1, rule.end());
                        replaced.push_back(next);
                    }
                } else replaced.push_back(rule);
            }
            grammar[name] = replaced;
        }
        vector<Rule> recursive, ordinary;
        for (const auto& rule : grammar[name]) {
            if (!rule.empty() && rule[0] == name) {
                if (rule.size() > 1) recursive.emplace_back(rule.begin() + 1, rule.end());
            } else ordinary.push_back(rule);
        }
        if (recursive.empty()) { grammar[name] = ordinary; continue; } // Drops A -> A.
        if (ordinary.empty()) { grammar[name].clear(); continue; } // No finite words.
        string helper = fresh(name + "_R", used); names.push_back(helper);
        for (auto& rule : ordinary) rule.push_back(helper);
        for (auto& rule : recursive) rule.push_back(helper);
        grammar[name] = ordinary;
        grammar[helper] = recursive; grammar[helper].push_back({});
    }
}

void leftFactor(Grammar& grammar, vector<string>& names, set<string>& used) {
    for (size_t index = 0; index < names.size(); ++index) {
        string name = names[index];
        while (true) {
            Rule best; const auto& rules = grammar[name];
            for (size_t i = 0; i < rules.size(); ++i)
                for (size_t j = i + 1; j < rules.size(); ++j) {
                    size_t k = 0;
                    while (k < min(rules[i].size(), rules[j].size()) && rules[i][k] == rules[j][k]) ++k;
                    if (k > best.size()) best.assign(rules[i].begin(), rules[i].begin() + k);
                }
            if (best.empty()) break;
            string helper = fresh(name + "_F", used); names.push_back(helper);
            vector<Rule> remaining;
            for (const auto& rule : rules) {
                if (rule.size() >= best.size() && equal(best.begin(), best.end(), rule.begin()))
                    grammar[helper].emplace_back(rule.begin() + best.size(), rule.end());
                else remaining.push_back(rule);
            }
            best.push_back(helper); remaining.push_back(best);
            grammar[name] = remaining;
        }
    }
}

int main() {
    try {
        int count; if (!(cin >> count) || count <= 0) throw runtime_error("enter a positive rule count");
        vector<pair<string, string>> input;
        vector<string> names; set<string> used;
        const regex validName("[A-Za-z_][A-Za-z_0-9']*");
        for (int i = 0; i < count; ++i) {
            string lhs, rhs;
            if (!(cin >> lhs >> rhs)) throw runtime_error("expected: Nonterminal alternatives");
            if (!regex_match(lhs, validName)) throw runtime_error("invalid nonterminal: " + lhs);
            if (rhs.rfind("->", 0) == 0) throw runtime_error("enter alternatives without -> for " + lhs);
            if (used.insert(lhs).second) names.push_back(lhs); input.emplace_back(lhs, rhs);
        }
        string extra;
        if (cin >> extra) throw runtime_error("remove spaces inside alternatives");
        string start = names.front(); vector<string> longest = names;
        stable_sort(longest.begin(), longest.end(), [](const string& a, const string& b) { return a.size() > b.size(); });
        Grammar grammar;
        for (const auto& [lhs, rhs] : input) {
            size_t begin = 0;
            while (true) {
                auto bar = rhs.find('|', begin);
                string alternative = rhs.substr(begin, bar - begin);
                if (alternative.empty()) throw runtime_error("empty alternative in " + lhs);
                grammar[lhs].push_back(tokenize(alternative, longest));
                if (bar == string::npos) break; begin = bar + 1;
            }
        }
        for (const auto& name : names) {
            for (const auto& rule : grammar[name]) used.insert(rule.begin(), rule.end());
        }
        bool nullableStart = removeEpsilon(grammar, names);
        removeLeftRecursion(grammar, names, used);
        leftFactor(grammar, names, used);
        if (nullableStart) {
            string newStart = fresh(start + "_Start", used);
            grammar[newStart] = {{start}, {}};
            names.insert(names.begin(), newStart); start = newStart;
        }
        cout << "Start symbol: " << start << '\n';
        for (const auto& name : names) {
            cout << name << " -> "; const auto& rules = grammar[name];
            if (rules.empty()) cout << "∅"; // No productions.
            for (size_t i = 0; i < rules.size(); ++i) {
                if (i) cout << " | "; if (rules[i].empty()) cout << "ε";
                else for (size_t j = 0; j < rules[i].size(); ++j) {
                    if (j) cout << ' '; const string& symbol = rules[i][j];
                    cout << (symbol.size() > 1 && !grammar.count(symbol) ? "\"" + symbol + "\"" : symbol);
                }
            }
            cout << '\n';
        }
    } catch (const exception& error) {
        cerr << "Error: " << error.what() << '\n'; return 1;
    }
}
