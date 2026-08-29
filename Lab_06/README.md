# Lab 06 - Conditional and Iterative Statements Using YACC

This lab contains one YACC grammar (`.y`) and one Flex lexer (`.l`) for each
question.

## Question 1: if-else and nested if

```bash
bison -d question_1.y
flex question_1.l
cc question_1.tab.c lex.yy.c -o question_1
printf 'if (a > b) x = 10; else x = 20;\n' | ./question_1
```

It accepts assignments, nested `if` statements, and optional `{ ... }` blocks.
The standard matched/unmatched grammar attaches each `else` to the nearest
unmatched `if`, as C does.

## Question 2: while, nested loops, and the supplied for-loop example

```bash
bison -d question_2.y
flex question_2.l
cc question_2.tab.c lex.yy.c -o question_2
printf 'while (i < 10) i = i + 1;\n' | ./question_2
```

`question_2.y` also accepts the supplied `for (initialization; condition;
update) statement` example. Missing parentheses, semicolons, or malformed
expressions produce a clear syntax error.
