# Compiler Design Lab 03 - Syntax Analysis Using YACC (Bison)

This folder implements Week 4 (S1) Assignment 4 using Flex and Bison.

## Requirements

```bash
flex --version
bison --version
cc --version
```

## Question 1: Arithmetic Expression Evaluation

`arithmetic.y` evaluates expressions containing `+`, `-`, `*`, `/`, and parentheses with the correct precedence and left associativity. It reports invalid operator sequences, incomplete expressions, invalid symbols, and division by zero.

```bash
bison -d arithmetic.y
flex arithmetic.l
cc arithmetic.tab.c lex.yy.c -o arithmetic
./arithmetic < test_cases/arithmetic_precedence.txt
```

## Question 2: String Recognition

`string_recognizer.y` recognizes the grammar `S → aS | ab`, which accepts `ab`, `aab`, `aaab`, and so on.

```bash
bison -d string_recognizer.y
flex string_recognizer.l
cc string_recognizer.tab.c lex.yy.c -o string_recognizer
./string_recognizer < test_cases/string_valid.txt
```

## Check All Sample Cases

```bash
./run_tests.sh
```

Generated parser, lexer, and executable files are intentionally not tracked.
