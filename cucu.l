%{
	#include <stdio.h>
	#define YYSTYPE char*
	#include "y.tab.h"

	extern void yyerror(char* msg);
	long long int LINE = 1;
	long long int CHAR = 0;
	void updateLineChar(char* str);
%}

%%

\/\*.*\*\/				{updateLineChar(yytext);}

if						{fprintf(yyout, "KEYWORD: %s\n", yytext); updateLineChar(yytext); yylval = strdup(yytext); return IF;}
while					{fprintf(yyout, "KEYWORD: %s\n", yytext); updateLineChar(yytext); yylval = strdup(yytext); return WHILE;}
else					{fprintf(yyout, "KEYWORD: %s\n", yytext); updateLineChar(yytext); yylval = strdup(yytext); return ELSE;}
return					{fprintf(yyout, "KEYWORD: %s\n", yytext); updateLineChar(yytext); yylval = strdup(yytext); return RETURN;}
(char[ \t]*\*|int)		{fprintf(yyout, "TYPE: %s\n", yytext); updateLineChar(yytext); yylval = malloc(strlen(yytext)+1); strcpy(yylval, yytext); return TYPE;}
\(						{fprintf(yyout, "LPAREN: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\)						{fprintf(yyout, "RPAREN: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\{						{fprintf(yyout, "LBRACE: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\}						{fprintf(yyout, "RBRACE: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
([!=><]=|\>|\<)			{fprintf(yyout, "RELATIONAL_OPERATOR: %s\n", yytext); updateLineChar(yytext); yylval = malloc(strlen(yytext)+1); strcpy(yylval, yytext); return R_OP;}
\[						{fprintf(yyout, "RBRACKET: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\]						{fprintf(yyout, "RBRACKET: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\+						{fprintf(yyout, "ADD: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\-						{fprintf(yyout, "SUB: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\*						{fprintf(yyout, "MUL: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
\/						{fprintf(yyout, "DIV: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
=						{fprintf(yyout, "ASSIGN: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
;						{fprintf(yyout, "SEMI_COLON: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}
,						{fprintf(yyout, "COMMA: %s\n", yytext); yylval = strdup(yytext); updateLineChar(yytext); return yytext[0];}

[a-zA-Z][a-zA-Z0-9_]*	{fprintf(yyout, "ID: %s\n", yytext); updateLineChar(yytext); yylval = malloc(strlen(yytext)+1); strcpy(yylval, yytext); return ID;}
[0-9]+					{fprintf(yyout, "NUM: %s\n", yytext); updateLineChar(yytext); yylval = malloc(strlen(yytext)+1); strcpy(yylval, yytext); return NUM;}

[ \t\n]*				{updateLineChar(yytext);}
.						{fprintf(yyout, "INVALID: %s\n", yytext); updateLineChar(yytext); return yytext[0]; yylval = strdup(yytext); return yytext[0];}

<<EOF>>					{return END;}

%%

void updateLineChar(char* str){
	while(*str != '\0'){
		if(*str == '\n'){
			LINE++;
			CHAR = 0;
		}else{
			CHAR++;
		}
		str++;
	}
}