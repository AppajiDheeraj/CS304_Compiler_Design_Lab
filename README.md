# CS304 Compiler Design Lab

Lab 01 contains four Flex/Lex programs written with C++ actions, test cases,
and build commands.

```bash
cd Lab_01
```

All sample inputs are inside `Lab_01/test_cases/`. Each program reads input
using standard input redirection:

```bash
flex filename.l
g++ lex.yy.c -o program_name
./program_name < test_cases/input_file
```

See [Lab 01 instructions and execution guide](Lab_01/README.md).

## 📚 Theory & Viva Cheatsheet

A Miro board with theory notes, diagrams, and viva preparation material for all lab assignments:

🔗 [Compiler Design — Theory & Viva Cheatsheet (Miro Board)](https://miro.com/app/board/uXjVH3HReGc=/?share_link_id=61726013400)
