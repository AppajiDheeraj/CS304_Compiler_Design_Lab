# CS304 Compiler Design Lab

This repository contains Flex/Lex programs written with C++ actions, test cases,
and build commands for the CS304 Compiler Design Lab.

## Labs

- [Lab 01](Lab_01/README.md): token counting and classification, comment
  removal, and C++ identifier validation.
- [Lab 02](Lab_02/README.md): lexical analysis with a detailed symbol table,
  plus array and function declaration analysis.
- [Lab 03](Lab_03/README.md): arithmetic evaluation and string recognition
  using Flex and Bison.
- [Lab 04](Lab_04/README.md): Week 5 string recognition using the given YACC
  grammars.

Each program reads input using standard input redirection:

```bash
cd Lab_01 # or Lab_02
flex filename.l
g++ lex.yy.c -o program_name
./program_name < test_cases/input_file
```

## 📚 Theory & Viva Cheatsheet

A Miro board with theory notes, diagrams, and viva preparation material for all lab assignments:

🔗 [Compiler Design — Theory & Viva Cheatsheet (Miro Board)](https://miro.com/app/board/uXjVH3HReGc=/?share_link_id=61726013400)
