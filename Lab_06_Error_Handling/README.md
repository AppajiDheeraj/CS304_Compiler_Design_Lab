# Lab 06 - Error Handling

This version of Lab 06 keeps the original conditional and iterative grammars
and reports focused syntax errors with line numbers.

## Question 1: if-else and nested if

```bash
bison -d -o question_1.tab.cpp question_1.y
flex -o lex.yy.cpp question_1.l
g++ question_1.tab.cpp lex.yy.cpp -o question_1
./question_1
```

Example input:

```text
if (a > b) x = 10; else x = 20;
```

## Question 2: while, for, and nested loops

```bash
bison -d -o question_2.tab.cpp question_2.y
flex -o lex.yy.cpp question_2.l
g++ question_2.tab.cpp lex.yy.cpp -o question_2
./question_2
```

Example input:

```text
while (i < 10) i = i + 1;
```

Press `Ctrl+D` after typing input. The parser identifies missing semicolons,
missing parentheses, invalid expressions, and unexpected tokens. Generated
`.cpp`, `.hpp`, and executable files are build output and need not be submitted.
