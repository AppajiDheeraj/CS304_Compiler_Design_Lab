# Lab 08 — Left recursion and left factoring

Build and run:

```bash
g++ -std=c++17 -Wall -Wextra -pedantic grammar.cpp -o grammar
./grammar
```

Enter the number of production lines, followed by one production per line.
The first left-hand side is the start symbol. Repeated left-hand sides are
allowed. Each line is exactly `Nonterminal alternatives`: one space between
the two fields, with **no spaces inside the alternatives**. Use `|` between
alternatives and write epsilon as `ε`, `epsilon`, or `#` on its own.

```text
3
E E+T|T
T T*F|F
F (E)|"id"
```

Known nonterminal names are matched longest first. Other unquoted characters
are single-character terminals; quote a multi-character terminal such as
`"id"`. Avoid terminal names that are also nonterminal names.

The program first expands nullable symbols, then removes indirect and direct
left recursion, then repeatedly factors common prefixes. A new start symbol
preserves the empty string when the original start symbol was nullable.
Generated names ending in `_R`, `_F`, and `_Start` are fresh nonterminals.
`∅` in the output means a nonterminal has no productions (empty language).
Like any explicit epsilon expansion, input with many nullable occurrences can
produce exponentially many alternatives.

Run the check with `./run_tests.sh`.
