#ifndef _UTILS_H_
#define _UTILS_H_

char *copyString(char *s);

TreeNode *newRoutineNode();
TreeNode *newConstDeclNode();
TreeNode *newConstNode(SimpleKind kind);
TreeNode *newTypeDeclNode();
TreeNode *newTypeNode(TypeKind kind);
TreeNode *newRecordNode();
TreeNode *newNameListNode();
TreeNode *newSimpleNode(SimpleKind kind);
TreeNode *newVarDeclNode();
TreeNode *newFuncProcNode(FuncProcKind kind);
TreeNode *newParaNode(ParaKind kind);
TreeNode *newStmtNode(StmtKind kind);
TreeNode *newDirectionNode(DirectionKind kind);
TreeNode *newCaseNode();
TreeNode *newExpressionListNode();
TreeNode *newExpressionNode(ExpressionKind kind);
TreeNode *newExprNode(ExprKind kind);
TreeNode *newTermNode(TermKind kind);
TreeNode *newFactorNode();
TreeNode *newIdNode();

#endif
