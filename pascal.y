%{
    #include "globals.h"
    #include "utils.h"
    #include "scan.h"
    #include "parse.h"
    
    #define YYDEBUG 1 //does not have any egg use. Tao
    #define YYSTYPE TreeNode *
    static TreeNode *savedTree;
    static int yylex();
%}

%token DOT PROGRAM ID SEMI CONST EQUAL INTEGER REAL CHAR STRING FALSE MAXINT TRUE TYPE ARRAY LB RB OF RECORD END COLON COMMA SBOOLEAN SCHAR SINTEGER SREAL LP RP DOTDOT MINUS VAR FUNCTION PROCEDURE ASSIGN SBEGIN IF THEN ELSE REPEAT UNTIL WHILE DO FOR TO DOWNTO CASE GOTO GE GT LE LT UNEQUAL PLUS OR MUL DIV MOD AND NOT

%%

program          : PROGRAM id_tmp SEMI routine DOT
                     {
                        $4->id = $2->id;
                        savedTree = $4;
                     }
                 ;
id_tmp           : ID {$$ = newIdNode(); $$->id = copyString(tokenString);}
                 ;
routine          : const_part type_part var_part routine_part compound_stmt
                     {
                        $$ = newRoutineNode();
                        $$->child[0] = $1;
                        $$->child[1] = $2;
                        $$->child[2] = $3;
                        $$->child[3] = $4;
                        $$->child[4] = $5;
                     }
                 ;
const_part       : CONST const_expr_list {$$ = $2;}
                 | {$$ = NULL;}
                 ;
const_expr_list  : const_expr_list id_tmp EQUAL const_value SEMI
                     {
                        TreeNode *t = $1;
                        TreeNode *newNode = newConstDeclNode();
                        newNode->id = $2->id;
                        newNode->child[0] = $4;
                        if (t != NULL)
                        {
                            while (t->sibling != NULL)
                                t = t->sibling;
                            t->sibling = newNode;
                            $$ = $1;
                        }
                        else
                            $$ = newNode;
                     }
                 | id_tmp EQUAL const_value SEMI
                     {
                      $$ = newConstDeclNode();
                      $$->id = $1->id;
                      $$->child[0] = $3;
                     }
                 ;
const_value      : INTEGER
                   {
                      $$ = newConstNode(IntegerK);
                      $$->value.int_value = atoi(tokenString);
                   }
                 | REAL
                   {
                      $$ = newConstNode(RealK);
                      $$->value.real_value = atof(tokenString);
                   }
                 | CHAR
                   {
                      $$ = newConstNode(CharK);
                      $$->value.int_value = tokenString[1];
                   }
                 | STRING
                   {
                      $$ = newConstNode(StringK);
                      $$->value.str_value = copyString(tokenString);
                   }
                 | FALSE
                   {
                      $$ = newConstNode(BooleanK);
                      $$->value.int_value = 0;
                   }
                 | MAXINT
                   {
                      $$ = newConstNode(IntegerK);
                      $$->value.int_value = INT_MAX;
                   }
                 | TRUE
                   {
                      $$ = newConstNode(BooleanK);
                      $$->value.int_value = 1;
                   }
                 ;
type_part        : TYPE type_decl_list {$$ = $2;}
                 | {$$ = NULL;}
                 ;
type_decl_list   : type_decl_list id_tmp EQUAL type_decl SEMI
                    {
                        TreeNode *t = $1;
                        TreeNode *newNode = newTypeDeclNode();
                        newNode->id = $2->id;
                        newNode->child[0] = $4;
                        if (t != NULL)
                        {
                            while (t->sibling != NULL)
                                t = t->sibling;
                            t->sibling = newNode;
                            $$ = $1;
                        }
                        else
                            $$ = newNode;
                    }
                 | id_tmp EQUAL type_decl SEMI
                    {
                        $$ = newTypeDeclNode();
                        $$->id = $1->id;
                        $$->child[0] = $3;
                    }
                 ;
type_decl        : simple_type_decl
                   {
                    $$ = newTypeNode(TypeSimpleK);
                    $$->child[0] = $1;
                   }
                 | array_type_decl {$$ = $1;}
                 | record_type_decl {$$ = $1;}
                 ;
array_type_decl  : ARRAY LB simple_type_decl RB OF type_decl
                     {
                        $$ = newTypeNode(TypeArrayK);
                        $$->child[0] = $3;
                        $$->child[1] = $6;
                     }
                 ;
record_type_decl : RECORD field_decl_list END
                    {
                      $$ = newTypeNode(TypeRecordK);
                      $$->child[0] = $2;
                    }
                 ;
field_decl_list  : field_decl_list name_list COLON type_decl SEMI
                     {
                        TreeNode *t = $1;
                        TreeNode *newNode = newRecordNode();
                        newNode->child[0] = $2;
                        newNode->child[1] = $4;
                        if (t != NULL)
                        {
                            while (t->sibling != NULL)
                                t = t->sibling;
                            t->sibling = newNode;
                            $$ = $1;
                        }
                        else
                            $$ = newNode;
                     }
                 | name_list COLON type_decl SEMI
                     {
                        $$ = newRecordNode();
                        $$->child[0] = $1;
                        $$->child[1] = $3;
                     }
                 ;
name_list        : name_list COMMA ID
                     {
                      TreeNode *t = $1;
                      TreeNode *newNode = newNameListNode();
                      newNode->id = copyString(tokenString);
                      if (t != NULL)
                      {
                          while (t->sibling != NULL)
                              t = t->sibling;
                          t->sibling = newNode;
                          $$ = $1;
                      }
                      else
                          $$ = newNode;
                     }
                 | ID
                   {
                    $$ = newNameListNode();
                    $$->id = copyString(tokenString);
                   }
                 ;
simple_type_decl : SBOOLEAN
                  {
                    $$ = newSimpleNode(BooleanK);
                  }
                 | SCHAR
                   {
                     $$ = newSimpleNode(CharK);
                   }
                 | SINTEGER
                   {
                     $$ = newSimpleNode(IntegerK);
                   }
                 | SREAL
                   {
                     $$ = newSimpleNode(RealK);
                   }
                 | ID
                   {
                     $$ = newSimpleNode(IdK);
                     $$->id = copyString(tokenString);
                   }
                 | LP name_list RP
                   {
                     $$ = newSimpleNode(SNameListK);
                     $$->child[0] = $2;
                   }
                 | const_value DOTDOT const_value
                   {
                     $$ = newSimpleNode(DotDotK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | MINUS const_value DOTDOT const_value
                   {
                       $$ = newSimpleNode(DotDotK);
                       $2->is_minus = 1;
                     $$->child[0] = $2;
                     $$->child[1] = $4;
                   }
                 | MINUS const_value DOTDOT MINUS const_value
                   {
                       $$ = newSimpleNode(DotDotK);
                       $2->is_minus = 1;
                     $$->child[0] = $2;
                     $5->is_minus = 1;
                     $$->child[1] = $5;
                   }
                 | id_tmp DOTDOT ID
                   {
                     $$ = newSimpleNode(DotDotK);
                     $$->id = $1->id;
                     $$->id2 = copyString(tokenString);
                   }
                 ;
var_part         : VAR var_decl_list {$$ = $2;}
                 | {$$ = NULL;}
                 ;
var_decl_list    : var_decl_list name_list COLON type_decl SEMI
                     {
                      TreeNode *t = $1;
                      TreeNode *newNode = newVarDeclNode();
                      newNode->child[0] = $2;
                      newNode->child[1] = $4;
                      if (t != NULL)
                      {
                          while (t->sibling != NULL)
                              t = t->sibling;
                          t->sibling = newNode;
                          $$ = $1;
                      }
                      else
                          $$ = newNode;
                     }
                 | name_list COLON type_decl SEMI
                   {
                    $$ = newVarDeclNode();
                    $$->child[0] = $1;
                    $$->child[1] = $3;
                   }
                 ;
routine_part     : routine_part_list {$$ = $1;}
                 | {$$ = NULL;}
                 ;
routine_part_list: routine_part func_proc_decl
                   {
                    TreeNode *t = $1;
                    if (t != NULL)
                    {
                        while (t->sibling != NULL)
                            t = t->sibling;
                        t->sibling = $2;
                        $$ = $1;
                    }
                    else
                        $$ = $2;
                   }
                 | func_proc_decl {$$ = $1;}
                 ;
func_proc_decl   : FUNCTION id_tmp parameters COLON simple_type_decl SEMI routine SEMI
                    {
                        $$ = newFuncProcNode(FuncK);
                        $$->id = $2->id;
                        $7->id = $2->id;
                        $$->child[0] = $3;
                        $$->child[1] = $5;
                        $$->child[2] = $7;
                    }
                 | PROCEDURE id_tmp parameters SEMI routine SEMI
                   {
                       $$ = newFuncProcNode(ProcK);
                       $$->id = $2->id;
                       $5->id = $2->id;
                       $$->child[0] = $3;
                       $$->child[1] = $5;
                   }
                 ;
parameters       : LP para_decl_list RP {$$ = $2;}
                 | {$$ = NULL;}
                 ;
para_decl_list   : para_decl_list SEMI para_type_list
                    {
                        TreeNode *t = $1;
                        if (t != NULL)
                        {
                            while (t->sibling != NULL)
                                t = t->sibling;
                            t->sibling = $3;
                            $$ = $1;
                        }
                        else
                            $$ = $3;
                    }
                 | para_type_list {$$ = $1;}
                 ;
para_type_list   : VAR name_list COLON simple_type_decl
                   {
                       $$ = newParaNode(VarK);
                       $$->child[0] = $2;
                       $$->child[1] = $4;
                   }
                 | name_list COLON simple_type_decl
                   {
                       $$ = newParaNode(ValK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 ;
stmt_list        : stmt_list stmt SEMI
                   {
                    TreeNode *t = $1;
                    if (t != NULL)
                    {
                        while (t->sibling != NULL)
                            t = t->sibling;
                        t->sibling = $2;
                        $$ = $1;
                    }
                    else
                        $$ = $2;
                   }
                 | {$$ = NULL;}
                 ;
stmt             : stmt_label COLON non_label_stmt
                   {
                     $3->label = atoi($1->id);
                     $$ = $3;
                   }
                 | non_label_stmt {$$ = $1;}
                 ;
stmt_label       : INTEGER {$$ = newIdNode(); $$->id = copyString(tokenString);}
                 ;
non_label_stmt   : assign_stmt {$$ = $1;}
                 | proc_stmt {$$ = $1;}
                 | compound_stmt {$$ = $1;}
                 | if_stmt {$$ = $1;}
                 | repeat_stmt {$$ = $1;}
                 | while_stmt {$$ = $1;}
                 | for_stmt {$$ = $1;}
                 | case_stmt {$$ = $1;}
                 | goto_stmt {$$ = $1;}
                 ;
assign_stmt      : id_tmp ASSIGN expression
                   {
                      $$ = newStmtNode(AssignK);
                      $$->id = $1->id;
                      $$->child[0] = $3;
                   }
                 | id_tmp LB expression RB ASSIGN expression
                   {
                      $$ = newStmtNode(AssignK);
                      $$->id = $1->id;
                      $$->child[0] = $3;
                      $$->child[1] = $6;
                   }
                 | id_tmp DOT id_tmp ASSIGN expression
                   {
                      $$ = newStmtNode(AssignK);
                      $$->id = $1->id;
                      $$->id2 = $3->id;
                      $$->child[0] = $5;
                   }
                 ;
proc_stmt        : ID
                   {
                    $$ = newStmtNode(SProcK);
                    $$->id = copyString(tokenString);
                   }
                 | id_tmp LP expression_list RP
                   {
                    $$ = newStmtNode(SProcK);
                    $$->id = $1->id;
                    $$->child[0] = $3;
                   }
                 ;
compound_stmt    : SBEGIN stmt_list END
                   {
                    $$ = newStmtNode(CompoundK);
                    $$->child[0] = $2;
                   }
                 ;
if_stmt          : IF expression THEN stmt ELSE stmt
                   {
                      $$ = newStmtNode(IfK);
                      $$->child[0] = $2;
                      $$->child[1] = $4;
                      $$->child[2] = $6;
                   }
                 | IF expression THEN stmt
                   {
                      $$ = newStmtNode(IfK);
                      $$->child[0] = $2;
                      $$->child[1] = $4;
                   }
                 ;
repeat_stmt      : REPEAT stmt_list UNTIL expression
                   {
                      $$ = newStmtNode(RepeatK);
                      $$->child[0] = $2;
                      $$->child[1] = $4;
                   }
                 ;
while_stmt       : WHILE expression DO stmt
                    {
                        $$ = newStmtNode(WhileK);
                        $$->child[0] = $2;
                        $$->child[1] = $4;
                    }
                 ;
for_stmt         : FOR id_tmp ASSIGN expression direction expression DO stmt
                    {
                      $$ = newStmtNode(ForK);
                      $$->id = $2->id;
                      $$->child[0] = $4;
                      $$->child[1] = $5;
                      $$->child[2] = $6;
                      $$->child[3] = $8;
                    }
                 ;
direction        : TO
                   {
                    $$ = newDirectionNode(ToK);
                   }
                 | DOWNTO
                   {
                    $$ = newDirectionNode(DowntoK);
                   }
                 ;
case_stmt        : CASE expression OF case_expr_list END
                   {
                    $$ = newStmtNode(SCaseK);
                    $$->child[0] = $2;
                    $$->child[1] = $4;
                   }
                 ;
case_expr_list   : case_expr_list case_expr
                   {
                       TreeNode *t = $1;
                       if (t != NULL)
                       {
                           while (t->sibling != NULL)
                               t = t->sibling;
                           t->sibling = $2;
                           $$ = $1;
                       }
                       else
                           $$ = $2;
                   }
                 | case_expr {$$ = $1;}
                 ;
case_expr        : const_value COLON stmt SEMI
                   {
                    $$ = newCaseNode();
                    $$->child[0] = $1;
                    $$->child[1] = $3;
                   }
                 | id_tmp COLON stmt SEMI
                   {
                    $$ = newCaseNode();
                    $$->id = $1->id;
                    $$->child[0] = $3;
                   }
                 ;
goto_stmt        : GOTO INTEGER
                   {
                    $$ = newStmtNode(GotoK);
                    $$->dest = atoi(tokenString);
                   }
                 ;
expression_list  : expression_list COMMA expression
                   {
                      TreeNode *t = $1;
                      TreeNode *newNode = newExpressionListNode();
                      newNode->child[0] = $3;
                      if (t != NULL)
                      {
                          while (t->sibling != NULL)
                              t = t->sibling;
                          t->sibling = newNode;
                          $$ = $1;
                      }
                      else
                          $$ = newNode;
                   }
                 | expression 
                   {
                      $$ = newExpressionListNode();
                      $$->child[0] = $1;
                   }
                 ;
expression       : expression GE expr
                   {
                       $$ = newExpressionNode(GeK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expression GT expr
                   {
                       $$ = newExpressionNode(GtK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expression LE expr
                   {
                       $$ = newExpressionNode(LeK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expression LT expr
                   {
                       $$ = newExpressionNode(LtK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expression EQUAL expr
                   {
                       $$ = newExpressionNode(EqualK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expression UNEQUAL expr
                   {
                       $$ = newExpressionNode(UnequalK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                   }
                 | expr
                   {
                       $$ = $1;
                   }
                 ;            
expr             : expr PLUS term
                   {
                     $$ = newExprNode(PlusK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | expr MINUS term
                   {
                     $$ = newExprNode(MinusK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | expr OR term
                   {
                     $$ = newExprNode(OrK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | term
                   {
                     $$ = $1;
                   }
                 ;      
term             : term MUL factor
                   {
                     $$ = newTermNode(MulK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | term DIV factor
                   {
                     $$ = newTermNode(DivK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | term MOD factor
                   {
                     $$ = newTermNode(ModK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | term AND factor
                   {
                     $$ = newTermNode(AndK);
                     $$->child[0] = $1;
                     $$->child[1] = $3;
                   }
                 | factor
                   {
                     $$ = $1;
                   }
                 ;
factor           : ID
                   {
                       $$ = newFactorNode();
                       $$->id = copyString(tokenString);
                   }
                 | id_tmp LP expression_list RP
                   {
                       $$ = newFactorNode();
                       $$->id = $1->id;
                       $$->child[0] = $3;
                   }
                 | const_value
                   {
                       $$ = newFactorNode();
                       $$->child[0] = $1;
                   }
                 | LP expression RP
                   {
                       $$ = newFactorNode();
                       $$->child[0] = $2;
                   }
                 | NOT factor
                   {
                       $2->is_not = 1;
                       $$ = $2;
                   }
                 | MINUS factor
                   {
                       $2->is_minus = 1;
                       $$ = $2;
                   }
                 | id_tmp LB expression RB
                   {
                       $$ = newFactorNode();
                       $$->id = $1->id;
                       $$->child[1] = $3;
                   }
                 | id_tmp DOT ID
                   {
                       $$ = newFactorNode();
                       $$->id = $1->id;
                       $$->id2 = copyString(tokenString);
                   };

%%

int yyerror(char *message)
{
    printf("Syntax Error at Line %d: %s\n", lineno, message);
    return 0;
}

static int yylex()
{
    return getToken();
}

TreeNode *parse()
{
    yydebug = 1;
    yyparse();
    return savedTree;
}
