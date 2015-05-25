#! /bin/bash

yacc -d pascal.y
lex pascal.l
gcc -c lex.yy.c
gcc -c y.tab.c
gcc -c utils.c
#gcc -c symtab.c
#gcc -c assembler.c
gcc -c main.c
#gcc -o compiler main.o lex.yy.o y.tab.o utils.o symtab.o assembler.o -lfl
gcc -o compiler main.o lex.yy.o y.tab.o utils.o -lfl
rm *.o 
rm lex.yy.c y.tab.*
./compiler test/test1.pas 2>log
