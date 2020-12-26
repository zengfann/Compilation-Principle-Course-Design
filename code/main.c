#include <stdio.h>
#include <unistd.h>
#include "node.h"

int yyparse(struct Node **);

int main(int argc, char **argv) {
  int mode = 1;
  char ch;
  fp = fopen("cifafenxi.txt", "w+"); //打开存词法分析的文件
  fprintf(fp,"%s","..........词法分析结果为.............\n");
  fprintf(fp,"%s","类型   Token   符号\n");
  while ((ch = getopt(argc, argv, "tc")) != -1) {
    switch (ch) {
    case 't':
      mode = 0;
      break;
    case 'c':
      mode = 1;
      break;
    default:
      fprintf(stderr, "unknown option: %c\n", ch);
    }
  }
  // 抽象语法树
  struct Node *AST;
  if (yyparse(&AST) == 0) {
    if (mode) {
      genTAC(AST);
    } else {
      printAST(AST);
    }
  }
  fclose(fp);
  return 0;
}