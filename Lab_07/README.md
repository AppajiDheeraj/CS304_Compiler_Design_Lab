# Lab 07 - Lexical Analysis and Parsing with LEX and YACC

## Question 1: loop constructs

Recognizes `for` and `while` loops, including nested loops. It prints every
token with its lexeme and line number and reports the five required syntax
errors from the Week 7 (S1) problem statement.

## Question 2: function definitions

Recognizes function definitions with typed parameters, statements, loops, and
returns. It reports missing returns, parameter types, and semicolons, along
with nested functions and conflicting return types.

## Build and test

```bash
make
make test
```

Run either parser with standard input or a file:

```bash
./question_1 < loop_input.c
./question_2 < function_input.c
```
