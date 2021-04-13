%{
    #include <stdio.h>
    #include <string.h>
    #include "analyseur.tab.h"

	int etatin = 0;
	int colAct, rowAct, celAct;
%}
%start TABLEAU
%%
"<table>"|"<table "[^<>]+">"	{ BEGIN TABLEAU; etatin++; rowAct = 0; return DEBTAB; }
"</table>"	{ if(etatin>0) {etatin-- ; if(etatin==0) { BEGIN INITIAL ; } } return FINTAB; }
"<caption>"|"<caption "[^<>]+">"	{ return DEBCAP; }
"</caption>"	{ return FINCAP; }
"<tr>"|"<tr "[^<>]+">"	{ rowAct++; colAct=0; yylval.row=rowAct; return DEBLIG; }
"</tr>"	{ return FINLIG; }
"<td>"|"<td "[^<>]+">"	{ colAct++; yylval.col=colAct; yylval.typeCel=0; return DEBCEL; }
"</td>"	{ return FINCEL; }
"<th>"|"<th "[^<>]+">"	{ colAct++; yylval.col=colAct; yylval.typeCel=1; return DEBCELENT;  }
"</th>"	{ return FINCELENT; }
"<thead>"|"<thead "[^<>]+">"	{ return DEBHEAD; }
"</thead>"	{ return FINHEAD; }
"<tbody>"|"<tbody "[^<>]+">"	{ return DEBBODY; }
"</tbody>"	{ return FINBODY; }
(\n|\r\n|" ")+	{}
<TABLEAU>[^<>]+ { yylval.texte=strdup(yytext); return CONTENU; }
.	{}

%%
int yywrap(void){
	return 1;
}
/*
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
