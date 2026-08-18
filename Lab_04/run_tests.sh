#!/bin/sh
set -eu

flex string_recognizer.l

check() {
    expected=$1
    program=$2
    input=$3
    actual=$(printf '%s\n' "$input" | "./$program" 2>/dev/null || true)
    [ "$actual" = "$expected" ] || {
        printf '%s: %s -> expected %s, got %s\n' "$program" "$input" "$expected" "$actual"
        exit 1
    }
}

bison -d question_1a.y
cc question_1a.tab.c lex.yy.c -o question_1a
for input in 101 1001 10001 1110001; do check VALID question_1a "$input"; done
check INVALID question_1a 100

bison -d question_1b.y
cc question_1b.tab.c lex.yy.c -o question_1b
for input in 012 0012 00012 000012; do check VALID question_1b "$input"; done
check INVALID question_1b 00112

echo "All Week 5 checks passed."
