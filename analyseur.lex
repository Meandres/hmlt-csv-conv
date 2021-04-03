%{
    #include <stdio.h>
    #include "analyseur.tab.h"
    #include <string.h>

    struct tab {
        struct listeSymbole *contenu;
        struct tab *tabsuivant;
    };

    struct listeSymbole {
        int cellule;
        int col;
        int row;
        char *contenu;
        struct listeSymbole *queue;
    };

    void push_back(struct tab *tableau, int typeCel, int colCel, int rowCel, char *contenu);
    void printTab(struct listeSymbole *liste);


	struct tab tableDesSymboles={NULL, NULL};
	int etatin = 0;
	int colAct, rowAct, celAct;
	struct listeSymbole *curr=&(struct listeSymbole){0, 0, 0, "0", NULL};
	struct tab *currTab = &tableDesSymboles;
	struct tab *nextTab;

%}
%start TABLEAU
%%
"<table>"|"<table "[^<>]+">"	{ printf("Début de tableau\n"); BEGIN TABLEAU; etatin++; rowAct = 0; return DEBTAB; }
"</table>"	{ printf("Fin de tableau\n"); if(etatin>0) {etatin-- ; if(etatin==0) { BEGIN INITIAL ; } } currTab->tabsuivant=nextTab; currTab=nextTab; nextTab=&(struct tab){NULL, NULL}; return FINTAB; }
"<caption>"|"<caption "[^<>]+">"	{ printf("Début de légende\n"); celAct=1; return DEBCAP; }
"</caption>"	{ printf("Fin de légende\n"); return FINCAP; }
"<tr>"|"<tr "[^<>]+">"	{ printf("Début de ligne\n"); rowAct++; colAct=0; return DEBLIG; }
"</tr>"	{ printf("Fin de ligne\n"); return FINLIG; }
"<td>"|"<td "[^<>]+">"	{ printf("Début de cellule\n"); colAct++; return DEBCEL; }
"</td>"	{ printf("Fin de cellule\n"); return FINCEL; }
"<th>"|"<th "[^<>]+">"	{ printf("Début de cellule d'en-tête\n"); celAct=2; return DEBCELENT;  }
"</th>"	{ printf("Fin de cellule d'en-tête\n"); return FINCELENT; }
"<thead>"|"<thead "[^<>]+">"	{ printf("Début de bloc d'en-têtes\n"); return DEBHEAD; }
"</thead>"	{ printf("Fin de bloc d'en-têtes\n"); return FINHEAD; }
"<tbody>"|"<tbody "[^<>]+">"	{ printf("Début de bloc de corps\n"); return DEBBODY; }
"</tbody>"	{ printf("Fin de bloc de corps\n"); return FINBODY; }
(\n|\r\n|" ")+	{}
<TABLEAU>[^<>]+ { printf("Contenu de cellule/en-tête/légende\n"); push_back(currTab, celAct, colAct, rowAct, yytext); yylval.texte=strdup(yytext); return CONTENU; }
.	{}

%%

void push_back(struct tab *tableau, int typeCel, int colCel, int rowCel, char *contenuCel){
	struct listeSymbole *teteLec=tableau->contenu;
	if(tableau->contenu == NULL){
		tableau->contenu=(struct listeSymbole *)malloc(sizeof(struct listeSymbole));
		tableau->contenu->cellule=typeCel;
		tableau->contenu->col=colCel;
		tableau->contenu->row=rowCel;
    tableau->contenu->contenu=malloc(sizeof(char)*strlen(contenuCel));
		strcpy(tableau->contenu->contenu, contenuCel);
		tableau->contenu->queue=NULL;
	}
	else{
		while(teteLec->queue != NULL){
			teteLec=teteLec->queue;
		}
		teteLec->queue=(struct listeSymbole *)malloc(sizeof(struct listeSymbole));
		teteLec->queue->cellule=typeCel;
		teteLec->queue->col=colCel;
		teteLec->queue->row=rowCel;
    teteLec->queue->contenu=malloc(sizeof(char)*strlen(contenuCel));
		strcpy(teteLec->queue->contenu, contenuCel);
		teteLec->queue->queue=NULL;
	}
}
void printTab(struct listeSymbole *liste){
	struct listeSymbole *teteLec=liste;
	while(teteLec != NULL){
		printf("\tType %i, en (%i, %i) : %s\n", teteLec->cellule, teteLec->row, teteLec->col, teteLec->contenu);
		teteLec=teteLec->queue;
	}
}

int yywrap(void){
	return 1;
}
/*
int yywrap(){
	struct tab *tabs=&tableDesSymboles;
	if(tabs->contenu==NULL) { printf("Aucun tableau trouvé dans ce fichier"); }
	else {
		int tabCpt=0;
		while(tabs !=NULL){
			printf("Tableau n°%i :\n", tabCpt);
			printTab(tabs->contenu);
			tabs=tabs->tabsuivant; tabCpt++;
		}
	}
	return 1;
}

int main(int argc, char *argv[]) {
	if(argc> 1)
	{
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){ return 1;}
	}
	yylex();
	fclose(yyin);
	return 0;
}*/
