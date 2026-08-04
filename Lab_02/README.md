# Compiler Design Lab 02 - Lexical Analysis Using Lex

This folder contains the two Lex/Flex programs assigned in Week 3 (S1). Both
programs read a C++ source program from standard input and print their results
to standard output.

## Requirements

```bash
flex --version
g++ --version
```

## Question 1: Token Analysis and Symbol Table

`lexical_symbol_table.l` identifies and counts keywords, identifiers, integer
constants, floating-point constants, character constants, and string literals.
It also displays a symbol table with each unique identifier or constant, its
token type, applicable data type, first line number, and applicable storage
class (`auto`, `static`, `extern`, or `register`).

Build and run:

```bash
flex lexical_symbol_table.l
g++ lex.yy.c -o lexical_symbol_table
./lexical_symbol_table < test_cases/token_input.cpp
```

## Question 2: Array and Function Declaration Analysis

`declaration_analyzer.l` identifies one-dimensional and two-dimensional arrays,
function declarations, and function definitions. It prints their names,
categories, data or return types, array dimensions, function parameter counts,
and source line numbers.

Build and run:

```bash
flex declaration_analyzer.l
g++ lex.yy.c -o declaration_analyzer
./declaration_analyzer < test_cases/declaration_input.cpp
```

The declaration analyzer supports the fundamental C++ types, signed/unsigned
types, `string`/`std::string`, and the `auto`, `static`, `extern`, and `register`
storage-class specifiers used in the assignment.

## Files

| File | Description |
|---|---|
| `lexical_symbol_table.l` | Question 1 token counter and symbol-table generator. |
| `declaration_analyzer.l` | Question 2 array/function declaration analyzer. |
| `test_cases/token_input.cpp` | Sample input covering every Question 1 token category. |
| `test_cases/declaration_input.cpp` | Sample input covering arrays, prototypes, and definitions. |
