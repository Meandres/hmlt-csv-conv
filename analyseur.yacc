%{
	#define YYSTYPE char*	
	#include <stdlib.h>
	#include <stdio.h>
	#include <string.h>
	int yylex();
	int yyerror(char *);
%}
%union
{
	char* texte;
}
%type <texte> tableau liste_lignes ligne cellule liste_cellules description_sans_entetes CONTENU DEBTAB FINTAB DEBCEL FINCEL
%token DEBTAB
%token FINTAB
%token DEBLIG
%token FINLIG
%token DEBCEL
%token FINCEL
%token DEBCELENT
%token FINCELENT
%token DEBHEAD
%token FINHEAD
%token DEBBODY
%token FINBODY
%token DEBCAP
%token FINCAP
%token CONTENU

%start liste_tableaux
%%
liste_tableaux: tableau liste_tableaux { printf("%s\n\n", $1); }
|
tableau: DEBTAB legende blocentetes blocorps_sans_entetes FINTAB
| DEBTAB legende blocorps_avec_entetes FINTAB
| DEBTAB legende blocorps_sans_entetes FINTAB
| DEBTAB blocentetes blocorps_sans_entetes FINTAB
| DEBTAB description_sans_entetes FINTAB { $$ = $2; }
| DEBTAB description_avec_entetes FINTAB
legende: DEBCAP CONTENU FINCAP
blocentetes: DEBHEAD ligne_entetes FINHEAD
ligne_entetes: DEBLIG liste_entetes FINLIG
liste_entetes: entete
| entete liste_entetes
entete: DEBCELENT CONTENU FINCELENT
blocorps_avec_entetes: DEBBODY description_avec_entetes FINBODY
blocorps_sans_entetes: DEBBODY description_sans_entetes FINBODY
description_avec_entetes: ligne_entetes liste_lignes
description_sans_entetes: liste_lignes { $$ = $1; }
liste_lignes: ligne { $$ = $1; }
| ligne liste_lignes { $$ = $1; }
ligne: DEBLIG liste_cellules FINLIG { $$ = $2; }
liste_cellules: cellule { $$ = $1; }
| cellule liste_cellules { $$ = $1; }
cellule: DEBCEL CONTENU FINCEL { $$ = $2;  }
| DEBCEL tableau FINCEL
%%
int main(){
	yyparse();
}
int yyerror( char *s) { printf( "%s\n", s); return 0; }
