#!/bin/sh
set -eu
cd "$(dirname "$0")"
binary=$(mktemp)
actual=$(mktemp)
expected=$(mktemp)
trap 'rm -f "$binary" "$actual" "$expected"' EXIT
g++ -std=c++17 -Wall -Wextra -pedantic grammar.cpp -o "$binary"

printf '2\nS Aa|b\nA Sc|ε\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: S
S -> a | A a | b
A -> a c A_R1 | b c A_R1
A_R1 -> a c A_R1 | ε
EOF
diff -u "$expected" "$actual"

printf '1\nS abc|abd|ae|b\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: S
S -> b | a S_F2
S_F1 -> c | d
S_F2 -> e | b S_F1
EOF
diff -u "$expected" "$actual"

printf '1\nA Aa|ε\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: A_Start1
A_Start1 -> A | ε
A -> a A_R1
A_R1 -> a A_R1 | ε
EOF
diff -u "$expected" "$actual"

printf '2\nExpr Expr+Term|Term\nTerm "id"\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: Expr
Expr -> Term Expr_R1
Term -> "id"
Expr_R1 -> + Term Expr_R1 | ε
EOF
diff -u "$expected" "$actual"

printf '2\nA B\nB A\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: A
A -> B
B -> ∅
EOF
diff -u "$expected" "$actual"

printf '3\nS AAb|c\nA ε|a\nS ad|ae\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: S
S -> b | c | A S_F1 | a S_F2
A -> a
S_F1 -> b | A b
S_F2 -> d | e
EOF
diff -u "$expected" "$actual"

printf '2\nS Sa|b\nS_R1 x\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: S
S -> b S_R2
S_R1 -> x
S_R2 -> a S_R2 | ε
EOF
diff -u "$expected" "$actual"

printf '1\nS a|ab\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: S
S -> a S_F1
S_F1 -> ε | b
EOF
diff -u "$expected" "$actual"

printf '2\nA Ab|B\nB b\n' | "$binary" > "$actual"
cat > "$expected" <<'EOF'
Start symbol: A
A -> B A_R1
B -> b
A_R1 -> b A_R1 | ε
EOF
diff -u "$expected" "$actual"

if printf '1\nS a|\n' | "$binary" > /dev/null 2>&1; then
    echo 'Expected malformed input to fail' >&2
    exit 1
fi
if printf '1\nS -> a\n' | "$binary" > /dev/null 2>&1; then
    echo 'Expected arrow input to fail' >&2
    exit 1
fi
if printf '2\nA Ab | B\nB b\n' | "$binary" > /dev/null 2>&1; then
    echo 'Expected spaces inside alternatives to fail' >&2
    exit 1
fi
echo 'Lab 08 checks passed'
