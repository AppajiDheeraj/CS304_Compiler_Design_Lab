.PHONY: all clean test

all: question_1 question_2

question_1: question_1.l question_1.y
	bison -d question_1.y
	flex -o question_1.lex.c question_1.l
	cc -o $@ question_1.tab.c question_1.lex.c

question_2: question_2.l question_2.y
	bison -d question_2.y
	flex -o question_2.lex.c question_2.l
	cc -o $@ question_2.tab.c question_2.lex.c

test: all
	./run_tests.sh

clean:
	rm -f question_1 question_2 *.tab.c *.tab.h *.lex.c *.output
