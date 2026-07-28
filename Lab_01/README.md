# Compiler Design Lab 01 - Flex/Lex with C++

This folder contains four Flex/Lex programs for Compiler Design Lab 01.

Each program reads input from standard input. Give input using `<` followed by
the test file path.

## Requirements

Flex and a C++ compiler are required.

```bash
flex --version
g++ --version
```

## Test Cases

All sample inputs are kept in the `test_cases/` folder.

| Test file | Used for | Description |
|---|---|---|
| `test_cases/input_1_3_4.cpp` | Questions 1, 3 and 4 | General C++ input for token counting, token classification and identifier checking. |
| `test_cases/input_2.cpp` | Question 2 | C++ input containing comments for the comment removal program. |

You can add more input files inside `test_cases/` and run them in the same way:

```bash
./program_name < test_cases/your_file_name
```

## Question 1: Token Counter
Write a Lex program to count the number of keywords, identifiers, integers, floating-point numbers, operators, and special symbols present in a given C++ source file.

Counts:

- Keywords
- Identifiers
- Integers
- Floating-point numbers
- Operators
- Special symbols

Build and run:

```bash
flex token_counter.l
g++ lex.yy.c -o token_counter
./token_counter < test_cases/input_1_3_4.cpp
```

## Question 2: Remove Comments
Develop a Lex program to remove single-line (//) and multi-line (/ /) comments from a C++ program while preserving the remaining code.

Build and run:

```bash
flex remove_comments.l
g++ lex.yy.c -o remove_comments
./remove_comments < test_cases/input_2.cpp
```

To save the cleaned output into a file:

```bash
./remove_comments < test_cases/input_2.cpp > output_without_comments.cpp
```

## Question 3: Classify Tokens
Write a Lex program to identify and classify the following tokens from a C++ program: keywords, identifiers, string literals, character literals, operators, and delimiters. Display the total count of each token category.

Classifies C++ tokens into:

- Keywords
- Identifiers
- String literals
- Character literals
- Operators
- Delimiters

Build and run:

```bash
flex classify_tokens.l
g++ lex.yy.c -o classify_tokens
./classify_tokens < test_cases/input_1_3_4.cpp
```

## Question 4: Validate Identifier

Write a Lex program that validates whether a given identifier is a valid C++ identifier according to C++ lexical rules.

Build and run with the provided input file:

```bash
flex validate_identifier.l
g++ lex.yy.c -o validate_identifier
./validate_identifier < test_cases/input_1_3_4.cpp
```

Run manually and type an identifier:

```bash
./validate_identifier
```

Example input:

```text
total_count
```

## Manual Compilation

General command format:

```bash
flex filename.l
g++ lex.yy.c -o output_file
./output_file < test_cases/input_file
```

Example:

```bash
flex token_counter.l
g++ lex.yy.c -o token_counter
./token_counter < test_cases/input_1_3_4.cpp
```

## Files

| File | Description |
|---|---|
| `token_counter.l` | Counts keywords, identifiers, integers, floating-point numbers, operators and special symbols. |
| `remove_comments.l` | Removes single-line and multi-line comments from C++ source code. |
| `classify_tokens.l` | Classifies C++ tokens into keywords, identifiers, strings, characters, operators and delimiters. |
| `validate_identifier.l` | Checks whether the input is a valid C++ identifier. |
| `test_cases/` | Folder containing all sample input files. |
