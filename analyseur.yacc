%{
	#include <stdlib.h>
	#include <stdio.h>
	#include <string.h>
	int yylex();
	int yyerror(char *);
	int prevLen=-1;
	int len=0;
%}
%union
{
	int typeCel;
	int col;
	int row;
	char* texte;
};
%token <texte> DEBTAB
%token <texte> FINTAB
%token <texte> FINLIG
%token <texte> FINCEL
%token <texte> FINCELENT
%token <texte> DEBHEAD
%token <texte> FINHEAD
%token <texte> DEBBODY
%token <texte> FINBODY
%token <texte> DEBCAP
%token <texte> FINCAP
%token <row> DEBLIG
%token <col, typeCel> DEBCEL
%token <col, typeCel> DEBCELENT
%token <texte> CONTENU
%type <texte> cellule entete
%start liste_tableaux
%%
liste_tableaux: liste_tableaux tableau
| tableau { prevLen=-1; printf("\n"); }
tableau: DEBTAB legende blocentetes blocorps_sans_entetes FINTAB
| DEBTAB legende blocorps_avec_entetes FINTAB
| DEBTAB legende blocorps_sans_entetes FINTAB
| DEBTAB blocentetes blocorps_sans_entetes FINTAB
| DEBTAB description_sans_entetes FINTAB
| DEBTAB description_avec_entetes FINTAB
legende: DEBCAP CONTENU FINCAP { printf("%s\n", $2); }
blocentetes: DEBHEAD ligne_entetes FINHEAD
ligne_entetes: DEBLIG liste_entetes FINLIG {printf("\n"); }
liste_entetes: entete { printf("%s;", $1); }
| liste_entetes entete { printf("%s", $2); }
entete: DEBCELENT CONTENU FINCELENT { $$=$2; }
blocorps_avec_entetes: DEBBODY description_avec_entetes FINBODY
blocorps_sans_entetes: DEBBODY description_sans_entetes FINBODY
description_avec_entetes: ligne_entetes liste_lignes
description_sans_entetes: liste_lignes
liste_lignes: ligne
| ligne liste_lignes
ligne: DEBLIG liste_cellules FINLIG {
	printf("\n");
  if(prevLen==-1){
		prevLen=len;
		len=0;
	}
	else{
		if(len!=prevLen)
			yyerror("Les lignes n'ont pas le même nombre de cellules");
		else{
			prevLen=len;
			len=0;
		}
	}
}
liste_cellules: cellule { printf("%s;", $1); }
| liste_cellules cellule { printf("%s", $2); }
cellule: DEBCEL CONTENU FINCEL { $$=$2; len++; }
//| DEBCEL tableau FINCEL
%%
int main(){
	yyparse();
}
int yyerror(char *s) { printf( "%s\n", s); exit(0); }
