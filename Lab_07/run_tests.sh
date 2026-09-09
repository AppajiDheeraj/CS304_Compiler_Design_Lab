#!/bin/sh
set -eu

expect_ok() {
    output=$(printf '%s\n' "$2" | "./$1" 2>&1)
    printf '%s' "$output" | grep -q 'Parsing successful'
}

expect_error() {
    if output=$(printf '%s\n' "$3" | "./$1" 2>&1); then
        echo "$2 unexpectedly succeeded" >&2
        exit 1
    fi
    printf '%s' "$output" | grep -q "$2"
    if printf '%s' "$output" | grep -q 'Parsing successful'; then
        echo "$2 was incorrectly reported as successful" >&2
        exit 1
    fi
}

expect_ok question_1 'for (int i = 0; i < 10; i++) { while (i < 5) { } }'
expect_error question_1 'missing semicolon in for-loop header' 'for (int i = 0 i < 10; i++) { }'
expect_error question_1 'missing semicolon in for-loop header' 'for (int i = 0; i < 10 i++) { }'
expect_error question_1 'missing condition in while loop' 'while () { }'
expect_error question_1 "missing closing brace '}'" 'while (i < 2) {'
expect_error question_1 'unrecognized loop construct' 'repeat (i < 2) { }'
expect_error question_1 'unsupported update expression' 'for (i = 0; i < 10; i + 1) { }'
expect_error question_1 'Lexical error' 'while (i < 2) { @ }'

expect_ok question_2 'int add(int a, int b) { return a + b; } float half(float x) { return x / 2.0; }'
expect_error question_2 'missing return statement' 'int f(int x) { x = 1; }'
expect_error question_2 'missing parameter type' 'int f(x) { return x; }'
expect_error question_2 'missing semicolon in function body' 'int f(int x) { x = 1 return x; }'
expect_error question_2 'invalid nested function definition' 'int f(int x) { int g(int y) { return y; } return x; }'
expect_error question_2 'conflicting types in multiple return statements' 'int f(int x) { return 1; return 2.0; }'
expect_error question_2 'Lexical error' 'int f(int x) { return @x; }'

echo 'All Week 7 checks passed.'
