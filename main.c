#include "globals.h"
#include "parse.h"
//#include "assembler.h"

int lineno;

FILE *source;
FILE *code;

TreeNode *parseTree;

int main(int argc, char **argv)
{
	source = fopen(argv[1], "r");
	parseTree = parse();
	fclose(source);
	//code = fopen(argv[2], "w");
	//assembler(parseTree);
	//fclose(code);
	return 0;
}
