#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <limits.h>

extern char tokenString[256];
extern int lineno;

extern FILE *source;
extern FILE *code;

typedef enum {RoutineK, ConstDeclK, ConstK, TypeDeclK, TypeK, RecordK, NameListK, SimpleK, VarDeclK, FuncProcK, ParaK, StmtK, DirectionK, CaseK, ExpressionListK, ExpressionK, ExprK, TermK, FactorK} NodeKind;
typedef enum {TypeSimpleK, TypeArrayK, TypeRecordK} TypeKind;
typedef enum {CharK, IntegerK, RealK, StringK, BooleanK, IdK, SNameListK, DotDotK} SimpleKind;
typedef enum {FuncK, ProcK} FuncProcKind;
typedef enum {VarK, ValK} ParaKind;
typedef enum {AssignK, SProcK, CompoundK, IfK, RepeatK, WhileK, ForK, SCaseK, GotoK} StmtKind;
typedef enum {ToK, DowntoK} DirectionKind;
typedef enum {GeK, GtK, LeK, LtK, EqualK, UnequalK} ExpressionKind;
typedef enum {PlusK, MinusK, OrK} ExprKind;
typedef enum {MulK, DivK, ModK, AndK} TermKind;

typedef struct treeNode
{
	struct treeNode *child[5];
	struct treeNode *sibling, *lsibling;
	char *id, *id2;
	int is_minus;
	int label;
	int dest;
	int is_not;
	int size, t_size, low_bound;
	NodeKind nodekind;
	union {
		TypeKind type_kind;
		SimpleKind simple_kind;
		FuncProcKind func_proc_kind;
		ParaKind para_kind;
		StmtKind stmt_kind;
		DirectionKind direction_kind;
		ExpressionKind expression_kind;
		ExprKind expr_kind;
		TermKind term_kind;
	} kind;
	union {
		int int_value;
		float real_value;
		char *str_value;
	} value;
} TreeNode;

#endif

