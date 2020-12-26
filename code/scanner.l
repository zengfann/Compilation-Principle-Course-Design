%{
#include "y.tab.h"
#include <stdio.h>
#include "node.h"
#include <stdlib.h>
int cur_line = 1;
void Print_token(token);
void yyerror(struct Node **AST, const char *msg);
void unrecognized_char(char c);
%}


delim       [ \t]
ws          {delim}+
letter      [A-Za-z]
digit       [0-9]
id          {letter}({letter}|{digit})*
number      {digit}+(\.{digit}+)?


%%
{ws}        /* ignore white spaces */
"("         Print_token(T_LPAREN);yylval.n=new_node("左括号", 0, yytext); return T_LPAREN;   //这里面需要调用y.tab.h中的yylval函数，将词法分析的得到的属性返回到yyparse函数中，供语法分析。
")"         Print_token(T_RPAREN);yylval.n=new_node("右括号", 0, yytext); return T_RPAREN;
"+"         Print_token(T_PLUS);yylval.n=new_node("算数运算符", 0, yytext); return T_PLUS;
"-"         Print_token(T_MINUS);yylval.n=new_node("算数运算符", 0, yytext); return T_MINUS;
"*"         Print_token(T_MUL);yylval.n=new_node("算数运算符", 0, yytext); return T_MUL;    //且return 返回的值是已经在y.tab.h中已经定义好的变量，因此可以直接返回改类型
"/"         Print_token(T_DIV);yylval.n=new_node("算数运算符", 0, yytext); return T_DIV;
"||"        Print_token(T_OR);yylval.n=new_node("逻辑运算符", 0, yytext); return T_OR;
"&&"        Print_token(T_AND);yylval.n=new_node("逻辑运算符", 0, yytext); return T_AND;
"!"         Print_token(T_NOT);yylval.n=new_node("逻辑运算符", 0, yytext); return T_NOT;
"<"         Print_token(T_LT);yylval.n=new_node("关系运算符", 0, yytext); return T_LT;
"<="        Print_token(T_LE);yylval.n=new_node("关系运算符", 0, yytext); return T_LE;
">"         Print_token(T_GT);yylval.n=new_node("关系运算符", 0, yytext); return T_GT;
">="        Print_token(T_GE);yylval.n=new_node("关系运算符", 0, yytext); return T_GE;
"begin"     Print_token(T_BEGIN);yylval.n=new_node("代码段开始", 0, yytext); return T_BEGIN;
"end"       Print_token(T_END);yylval.n=new_node("代码段结束", 0, yytext); return T_END;
"true"      Print_token(T_TRUE);yylval.n=new_node("真", 0, yytext); return T_TRUE;
"false"     Print_token(T_FALSE);yylval.n=new_node("假", 0, yytext); return T_FALSE;
"if"        Print_token(T_IF);yylval.n=new_node("如果", 0, yytext); return T_IF;
"then"      Print_token(T_THEN);yylval.n=new_node("然后", 0, yytext); return T_THEN;
":="        Print_token(T_ASSIGN);yylval.n=new_node("赋值符号", 0, yytext); return T_ASSIGN;
{number}    Print_token(T_NUMBER);yylval.n=new_node("数字", 0, yytext); yylval.n->value=atoi(yytext); return T_NUMBER;
{id}        Print_token(T_ID);yylval.n=new_node("标识符", 0, yytext); return T_ID;
";"         Print_token(T_SEMI);yylval.n=new_node("分号", 0, yytext); return T_SEMI;
\n          cur_line++;
.           unrecognized_char(yytext[0]);
%%


int yywrap(void) {
  return 1;
}



void unrecognized_char(char c) {
  char buf[32] = "unrecognized character: ?";
  buf[24] = c;
  yyerror(NULL, buf);
}

void yyerror(struct Node **AST ,const char *msg) {
  fprintf(stderr, "Error at line %d:\n\t%s\n", cur_line, msg);
  
  exit(1);
}




void Print_token(int token)
{
  char* token_strs[] = {
        "T_LPAREN", "T_RPAREN", "T_PLUS", "T_MINUS", "T_MUL", "T_DIV", "T_BOOLEAN",
        "T_ASSIGN", "T_NUMBER", "T_ID", "T_SEMI", "T_OR",
        "T_AND", "T_NOT", "T_BEGIN", "T_END", "T_TRUE",
        "T_FALSE","T_IF","T_LE","T_GT","T_GE","UMINUS"
    };
    if (token < 258) {
        fprintf(fp,"%d", token);
    } else {
        fprintf(fp,"%s   ", token_strs[token-258]);
        fprintf(fp,"%d   ",token);
        fprintf(fp,"%s   \n",yytext);
    }
}


