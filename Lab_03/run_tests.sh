#!/bin/sh
set -eu

bison -d arithmetic.y
flex arithmetic.l
cc arithmetic.tab.c lex.yy.c -o arithmetic
bison -d string_recognizer.y
flex string_recognizer.l
cc string_recognizer.tab.c lex.yy.c -o string_recognizer

test "$(./arithmetic < test_cases/arithmetic_valid.txt)" = "Result = 30"
test "$(./arithmetic < test_cases/arithmetic_precedence.txt)" = "Result = 10"
test "$(./arithmetic < test_cases/arithmetic_bad_operator.txt)" = "Syntax Error: Invalid operator sequence"
test "$(./arithmetic < test_cases/arithmetic_incomplete.txt)" = "Syntax Error: Incomplete expression"
test "$(./arithmetic < test_cases/arithmetic_invalid_symbol.txt)" = "Lexical Error: Invalid symbol '@'"
test "$(./string_recognizer < test_cases/string_valid.txt)" = "Valid String"
test "$(./string_recognizer < test_cases/string_invalid.txt)" = "Invalid String"
printf 'All tests passed.\n'
