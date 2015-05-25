#include "globals.h"
#include "utils.h"

char *copyString(char *s)
{
	int n;
	char *t;
	if (s == NULL)
		return NULL;
	n = strlen(s) + 1;
	t = malloc(n);
	strcpy(t, s);
	return t;
}

TreeNode *newRoutineNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = RoutineK;
	return t;
}

TreeNode *newConstDeclNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ConstDeclK;
	return t;
}

TreeNode *newConstNode(SimpleKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ConstK;
	t->kind.simple_kind = kind;
	return t;	
}

TreeNode *newTypeDeclNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = TypeDeclK;
	return t;
}

TreeNode *newTypeNode(TypeKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = TypeK;
	t->kind.type_kind = kind;
	return t;	
}

TreeNode *newRecordNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = RecordK;
	return t;		
}

TreeNode *newNameListNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = NameListK;
	return t;			
}

TreeNode *newSimpleNode(SimpleKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = SimpleK;
	t->kind.simple_kind = kind;
	return t;		
}

TreeNode *newVarDeclNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = VarDeclK;
	return t;
}

TreeNode *newFuncProcNode(FuncProcKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = FuncProcK;
	t->kind.func_proc_kind = kind;
	return t;			
}

TreeNode *newParaNode(ParaKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ParaK;
	t->kind.para_kind = kind;
	return t;			
}

TreeNode *newStmtNode(StmtKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = StmtK;
	t->kind.stmt_kind = kind;
	return t;			
}

TreeNode *newDirectionNode(DirectionKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = DirectionK;
	t->kind.direction_kind = kind;
	return t;			
}

TreeNode *newCaseNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = CaseK;
	return t;	
}

TreeNode *newExpressionListNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ExpressionListK;
	return t;	
}

TreeNode *newExpressionNode(ExpressionKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ExpressionK;
	t->kind.expression_kind = kind;
	return t;			
}

TreeNode *newExprNode(ExprKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = ExprK;
	t->kind.expr_kind = kind;
	return t;			
}

TreeNode *newTermNode(TermKind kind)
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = TermK;
	t->kind.term_kind = kind;
	return t;			
}

TreeNode *newFactorNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	t->nodekind = FactorK;
	return t;			
}

TreeNode *newIdNode()
{
	TreeNode *t = malloc(sizeof(TreeNode));
	memset(t, 0, sizeof(TreeNode));
	return t;				
}
