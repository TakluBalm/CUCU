%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYSTYPE char*

	extern FILE* yyin;
	extern FILE* yyout;
	extern int LINE, CHAR;
	extern void yyerror(char* msg);
	extern int yylex();
%}

%token ID NUM TYPE IF WHILE ELSE RETURN R_OP YYEOF

%%

LANGUAGE:	PROGRAM YYEOF	{printf("\nProgram is syntactically correct\n\n\t__Program_Begin__\n%s\n\n\t__Program_End__", $1);}
;

PROGRAM:	ELEMENT			{$$ = malloc(strlen($1)+2); sprintf($$, "%s\n", $1); free($1);}
| 			PROGRAM ELEMENT	{$$ = malloc(strlen($2) + strlen($1) +3); sprintf($$, "%s\n%s\n", $1, $2); free($2);}
;

ELEMENT:	VAR_DECL				{$$ = malloc(sizeof(char)*(strlen($1) + 4)); sprintf($$, "-> %s", $1); free($1);}
|			FUNC_HEADER	LINE_END	{$$ = malloc(sizeof(char)*100); sprintf($$, "-> newFunction(%s)", $1);}
|			DEF						{$$ = $1;}
;

DEF:	FUNC_HEADER STMT	{$$ = malloc(sizeof(char)*500); sprintf($$, "-> functionDefinition\t(%s)\n\n___Body_Begin___\n\n%s\n\n___Body_End___", $1, $2);}
;

VAR_DECL:	TYPE ID	LINE_END		{$$ = malloc(sizeof(char)*100); sprintf($$, "newVariable(Type: %s, Name: %s)", $1, $2); free($1); free($2);}
;

FUNC_HEADER:	TYPE ID '(' ARG_LIST ')'	{$$ = malloc(sizeof(char)*100); sprintf($$, "returnType: %s funcName: %s funcArgs: %s", $1, $2, $4); free($1); free($2); free($4);}
|				TYPE ID '(' ')'				{$$ = malloc(sizeof(char)*100); sprintf($$, "returnType: %s funcName: %s", $1, $2); free($1); free($2);}
;

ARG_LIST:	TYPE ID					{$$ = malloc(sizeof(char)*200); sprintf($$, "%s", $2); free($1); free($2);}
|			ARG_LIST ',' TYPE ID	{$$ = $1; sprintf($$, "%s, %s", $1, $4); free($3); free($4);}
;

LINE_END:	';'
|			LINE_END ';'
;

STMT:	AS_STMT		{$$ = $1;}
|		CALL_STMT	{$$ = $1;}
|		RET_STMT	{$$ = $1;}
|		COND_STMT	{$$ = $1;}
|		LOOP_STMT	{$$ = $1;}
|		BLOCK_STMT	{$$ = $1;}
;

AS_STMT:	ID '=' ARITH_EXPR LINE_END			{$$ = malloc(sizeof(char)*100); sprintf($$, "ASSIGN(LHS=%s,RHS=%s)", $1, $3); free($1); free($3);}
;

FUNC_CALL:	ID '(' PARAM_LIST ')'				{$$ = malloc(sizeof(char)*100); sprintf($$, "FUNC_CALL(name: %s, parameters: %s)", $1, $3); free($1); free($3);}
|			ID '('')'							{$$ = malloc(sizeof(char)*100); sprintf($$, "FUNC_CALL(name: %s, parameters: NONE)", $1); free($1);}
;

CALL_STMT: FUNC_CALL LINE_END					{$$ = $1;}

PARAM_LIST: ARITH_EXPR							{$$ = malloc(sizeof(char)*100); sprintf($$, "%s", $1); free($1);}
|			PARAM_LIST ',' ARITH_EXPR			{$$ = $1; sprintf($$, "%s, %s", $1, $3); free($3);}
;

RET_STMT:	RETURN ARITH_EXPR LINE_END			{$$ = malloc(sizeof(char)*100); sprintf($$, "return(%s)", $2);}
;

COND_STMT:	IF '(' BOOL_EXPR ')' BLOCK_STMT						{$$ = malloc(sizeof(char)*500); sprintf($$, "ifCondition(%s)\n\t___If_Begin___\n%s\n\t___If_End___\n", $3, $5); free($3); free($5);}
|			IF '(' BOOL_EXPR ')' BLOCK_STMT ELSE BLOCK_STMT		{$$ = malloc(sizeof(char)*500); sprintf($$, "ifCondition(%s)\n\t___If_Begin___\n%s\n\t___If_End___\n\t___Else_Begin___\n%s\n\t___Else_End___\n", $3, $5, $7); free($3); free($5); free($7);}
;

LOOP_STMT: WHILE '(' BOOL_EXPR ')' BLOCK_STMT					{$$ = malloc(sizeof(char)*500); sprintf($$, "Loop Statements:\n%s\n", $5);}
;

BLOCK_STMT: '{''}'												{$$ = malloc(sizeof(char)*strlen("Empty Block\n")); sprintf($$, "Empty Block\n");}
|			'{' STMT_LIST '}'									{$$ = $2;}
;

STMT_LIST:	STMT							{$$ = malloc(sizeof(char)*500); sprintf($$, "%s", $1);}
|			VAR_DECL						{$$ = malloc(sizeof(char)*500); sprintf($$, "%s", $1);}
|			STMT_LIST STMT					{$$ = $1; sprintf($$, "%s\n%s", $1, $2);}
|			STMT_LIST VAR_DECL				{$$ = $1; sprintf($$, "%s\n%s", $1, $2);}
;

ARITH_EXPR:	FACTOR							{$$ = malloc(sizeof(char)*100); sprintf($$, "%s", $1); free($1);}
|			ARITH_EXPR '+' FACTOR			{$$ = malloc(strlen($1)+strlen($3)+7); sprintf($$, "ADD(%s,%s)", $1, $3); free($1); free($3);}
|			ARITH_EXPR '-' FACTOR			{$$ = malloc(strlen($1)+strlen($3)+7); sprintf($$, "SUB(%s,%s)", $1, $3); free($1); free($3);}
;

FACTOR:	TERM								{$$ = malloc(sizeof(char)*100); sprintf($$, "%s", $1); free($1);}
|		FACTOR '*' TERM						{$$ = malloc(strlen($1)+strlen($3)+7); sprintf($$, "MUL(%s,%s)", $1, $3); free($1); free($3);}
|		FACTOR '/' TERM						{$$ = malloc(strlen($1)+strlen($3)+7); sprintf($$, "DIV(%s,%s)", $1, $3); free($1); free($3);}
;

TERM:	ID									{$$ = $1;}
|		INT									{$$ = $1;}
|		FUNC_CALL 							{$$ = $1;}
|		'(' ARITH_EXPR ')'					{$$ = malloc(sizeof(char)*(strlen($2)+3)); sprintf($$, "(%s)", $2);}
;

INT:	NUM									{$$ = malloc(sizeof(char)*(strlen($1) + 6)); sprintf($$, "INT(%s)", $1); free($1);}
|		'-' NUM								{$$ = malloc(sizeof(char)*(strlen($1) + 7)); sprintf($$, "INT(-%s)", $2); free($2);}
;

BOOL_EXPR:	ARITH_EXPR R_OP ARITH_EXPR 		{$$ = malloc(sizeof(char)*(strlen($1) + strlen($2) + strlen($3) + 3)); sprintf($$, "%s %s %s", $1, $2, $3);}
;

%%

int main(){
	yyin = fopen("input.txt", "r");
	yyout = fopen("lexer.txt", "w");
	stdout = fopen("parser.txt", "w");
	yyparse();
}

void yyerror(char* msg){
	printf("Program Syntax Incorrect\nError at line:char = %d:%d\tDid not expect: %s", LINE, CHAR, yylval);
}