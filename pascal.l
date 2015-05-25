%{
#include "globals.h"
#include "y.tab.h"
#include "scan.h"

char tokenString[256];
%}

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
NQUOTE [^']

%%

{A}{R}{R}{A}{Y} return ARRAY; 
{A}{N}{D} return AND; 
{B}{E}{G}{I}{N} return SBEGIN; 
{B}{O}{O}{L}{E}{A}{N} return SBOOLEAN; 
{C}{A}{S}{E} return CASE; 
{C}{H}{A}{R} return SCHAR; 
{C}{O}{N}{S}{T} return CONST; 
{D}{O} return DO; 
{D}{O}{W}{N}{T}{O} return DOWNTO; 
{E}{L}{S}{E} return ELSE; 
{E}{N}{D} return END; 
{F}{A}{L}{S}{E} return FALSE; 
{F}{O}{R} return FOR; 
{F}{U}{N}{C}{T}{I}{O}{N} return FUNCTION; 
{G}{O}{T}{O} return GOTO; 
{I}{F} return IF; 
{I}{N}{T}{E}{G}{E}{R} return SINTEGER; 
{M}{A}{X}{I}{N}{T} return MAXINT; 
{M}{O}{D} return MOD; 
{N}{O}{T} return NOT;
{O}{F} return OF; 
{O}{R} return OR; 
{P}{R}{O}{C}{E}{D}{U}{R}{E} return PROCEDURE; 
{P}{R}{O}{G}{R}{A}{M} return PROGRAM; 
{R}{E}{A}{L} return SREAL; 
{R}{E}{C}{O}{R}{D} return RECORD; 
{R}{E}{P}{E}{A}{T} return REPEAT; 
{T}{H}{E}{N} return THEN; 
{T}{O} return TO; 
{T}{R}{U}{E} return TRUE; 
{T}{Y}{P}{E} return TYPE; 
{U}{N}{T}{I}{L} return UNTIL; 
{V}{A}{R} return VAR; 
{W}{H}{I}{L}{E} return WHILE; 
[a-zA-Z_]([a-zA-Z0-9_])*  return ID; 

":=" return ASSIGN; 
":" return COLON; 
"," return COMMA; 
'({NQUOTE}|'')' return CHAR; 
"/" return DIV; 
"." return DOT; 
".." return DOTDOT; 
"=" return EQUAL; 
">=" return GE; 
">" return GT; 
[0-9]+ return INTEGER; 
"[" return LB; 
"<=" return LE; 
"(" return LP; 
"<" return LT; 
"-" return MINUS; 
"*" return MUL; 
"+" return PLUS; 
"]" return RB; 
[0-9]+"."[0-9]+ return REAL; 
")" return RP; 
";" return SEMI; 
'({NQUOTE}|'')+' return STRING; 
"<>" return UNEQUAL; 

"(*"   |
"{"    { register int c;
     while ((c = input()))
     {
      if (c == '}')
       break;
      else if (c == '*')
      {
       if ((c = input()) == ')')
        break;
       else
        unput (c);
      }
      else if (c == '\n')
       lineno++;
     }
    }

[ \t\f]    ;

\n    lineno++;

%%

int getToken()
{
	static int firstTime = 1;
	int currentToken, i;
	if (firstTime)
	{
		firstTime = 0;
		lineno++;
		yyin = source;
//		yyout = listing;
	}
	currentToken = yylex();
	if (currentToken == ID || currentToken == CHAR || currentToken == INTEGER || currentToken == REAL || currentToken == STRING)
	{
		memset(tokenString, 0, sizeof(tokenString));
		strcpy(tokenString, yytext);
	}
	for (i = 0; tokenString[i]; i++)
		tokenString[i] = tolower(tokenString[i]);
	return currentToken;
}
