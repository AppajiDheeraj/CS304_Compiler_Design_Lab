# Lab 03

## Question 1

```bash
cd Lab_03/Question_1
bison -d arithmetic.y
flex arithmetic.l
cc arithmetic.tab.c lex.yy.c -o arithmetic
./arithmetic
```

## Question 2

```bash
cd Lab_03/Question_2
bison -d string.y
flex string.l
cc string.tab.c lex.yy.c -o string_recognizer
./string_recognizer
```
