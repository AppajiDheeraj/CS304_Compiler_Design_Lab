# Lab 04 - Syntax Analysis Using YACC (Bison)

This folder implements the Week 5 (S1) string-recognition grammars using one
shared Flex lexer and two Bison parsers.

## Question 1A

Recognizes one or more `1` characters followed by one or more `0` characters
and a final `1`:

```text
S -> 1S | 1A
A -> 0A | 01
```

```bash
flex string_recognizer.l
bison -d question_1a.y
cc question_1a.tab.c lex.yy.c -o question_1a
printf '1110001\n' | ./question_1a
```

## Question 1B

Recognizes one or more `0` characters followed by exactly one `1` and one `2`:

```text
S -> 0S | 012
```

```bash
flex string_recognizer.l
bison -d question_1b.y
cc question_1b.tab.c lex.yy.c -o question_1b
printf '00012\n' | ./question_1b
```

Run all assignment examples and invalid checks with:

```bash
chmod +x run_tests.sh
./run_tests.sh
```
