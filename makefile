#Ilya Meignan--Masson et Thomas Juliat
#l'entrée se fait à partir de l'entrée par défaut (<)
analyseur:
	bison -o analyseur.tab.c -d analyseur.yacc
	flex analyseur.lex
	gcc -o analyseur analyseur.tab.c lex.yy.c
