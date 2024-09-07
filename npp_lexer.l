%{
#include "npp_parser.tab.h"
%}

digit       [0-9]
identifier  [_a-zA-Z][_a-zA-Z0-9]*

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"bool"      { return BOOL; }
"true"      { return TRUE; }
"false"     { return FALSE; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"="         { return ASSIGN_OP; }
"=="        { return EQ_OP; }
"!="        { return NE_OP; }
"<"         { return LT; }
">"         { return GT; }
"<="        { return LE; }
">="        { return GE; }
"!"         { return NOT; }
"&&"        { return AND; }
"||"        { return OR; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
","         { return COMMA; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"%"         { return MOD; }
"~"         { return BIT_NOT; }
"&"         { return BIT_AND; }
"|"         { return BIT_OR; }
"^"         { return BIT_XOR; }
{identifier}  { yylval.str = strdup(yytext); return VARIABLE; }
{digit}+     { yylval.ival = atoi(yytext); return INTEGERLITERAL; }
{digit}+"."{digit}* { yylval.fval = atof(yytext); return FLOATLITERAL; }
{digit}*"."{digit}+ { yylval.fval = atof(yytext); return FLOATLITERAL; }
" "         { /* ignore whitespace */ }
\n          { /* ignore newline */ }
.           { printf("Undefined character error: %s\n", yytext); exit(1); }

%%

int yywrap(void) {
    return 1;
}

