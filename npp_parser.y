%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

extern FILE *yyin; // Declare yyin as an external variable

// Buffer to store rule usage messages
#define MAX_RULES 1000
char *rule_buffer[MAX_RULES];
int rule_count = 0;

void log_rule(const char *rule) {
    if (rule_count < MAX_RULES) {
        rule_buffer[rule_count++] = strdup(rule);
    }
}

void print_rules() {
    for (int i = rule_count-1 ; i >= 0 ; --i) {
        printf("%s\n", rule_buffer[i]);
        free(rule_buffer[i]);
    }
}

%}

%union {
    int ival;
    float fval;
    char *str;
}

%token <ival> INTEGERLITERAL
%token <fval> FLOATLITERAL
%token <str> VARIABLE
%token TRUE FALSE

%token INT FLOAT BOOL
%token IF ELSE WHILE

%token ASSIGN_OP EQ_OP NE_OP LT GT LE GE
%token NOT AND OR
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token PLUS MINUS MUL DIV MOD
%token BIT_NOT BIT_AND BIT_OR BIT_XOR

%start Program

%left OR
%left AND
%left BIT_OR
%left BIT_XOR
%left BIT_AND
%left EQ_OP NE_OP
%left LT GT LE GE
%left PLUS MINUS
%left MUL DIV MOD
%left NOT BIT_NOT
%left LPAREN RPAREN

%%

Program:
    StatementList { log_rule("Program -> StatementList"); }
    ;

StatementList:
    StatementList Statement  { log_rule("StatementList -> StatementList Statement"); }
    | /* empty */ { log_rule("StatementList -> empty"); }
    ;

Statement:
    Declaration SEMICOLON { log_rule("Statement -> Declaration ;"); }
    | Assignment SEMICOLON { log_rule("Statement -> Assignment ;"); }
    | Conditional { log_rule("Statement -> Conditional"); }
    | Loop { log_rule("Statement -> Loop"); }
    ;

Declaration:
    DataType VariableList { log_rule("Declaration -> DataType VariableList"); }
    ;

VariableList:
    VARIABLE COMMA VariableList { log_rule("VariableList -> VARIABLE , VariableList"); }
    | VARIABLE { log_rule("VariableList -> VARIABLE"); }
    ;

DataType:
    BOOL { log_rule("DataType -> bool"); }
    | INT { log_rule("DataType -> int"); }
    | FLOAT { log_rule("DataType -> float"); }
    ;

Assignment:
    VARIABLE ASSIGN_OP RValue { log_rule("Assignment -> VARIABLE = RValue"); }
    ;

RValue:
    VARIABLE ASSIGN_OP RValue { log_rule("RValue -> VARIABLE = RValue"); }
    | Expression { log_rule("RValue -> Expression"); }
    ;

Expression: 
    Term TermTail { log_rule("Expression -> Term TtermTail"); }
    ;

TermTail:
    PLUS Term TermTail { log_rule("TermTail -> + Term TermTail"); }
    | MINUS Term TermTail { log_rule("TermTail -> - Term TermTail"); }
    | { log_rule("TermTail -> empty"); }
    ;

Term:  
    Factor FactorTail { log_rule("Tail -> Factor FactorTail"); }
    ;

FactorTail:  
    MUL Factor FactorTail { log_rule("FactorTail -> * Factor FactorTail"); }
    | DIV Factor FactorTail { log_rule("FactorTail -> / Factor FactorTail"); }
    | MOD Factor FactorTail { log_rule("FactorTail -> % Factor FactorTail"); }
    | { log_rule("FactorTail -> empty"); }
    ;

Factor:
    Primary PrimaryTail { log_rule("Factor -> Primary PrimatyTail"); }
    ;

PrimaryTail:
    BIT_AND Primary PrimaryTail { log_rule("PrimaryTail -> & Primary PrimaryTail"); }
    | BIT_OR Primary PrimaryTail { log_rule("PrimaryTail -> | Primary PrimaryTail"); }
    | BIT_XOR Primary PrimaryTail { log_rule("PrimaryTail -> ^ Primary PrimaryTail"); }
    | { log_rule("PrimaryTail -> empty"); }
    ; 
  
Primary:
    BIT_NOT LPAREN Expression RPAREN { log_rule("Primary -> ~ ( Expression )"); }
    | LPAREN Expression RPAREN { log_rule("Primary -> ( Expression )"); }
    | BIT_NOT Literal { log_rule("Primary -> ~ Literal"); }
    | Literal { log_rule("Primary -> Literal"); }
    | BIT_NOT VARIABLE { log_rule("Primary -> ~ VARIABLE"); }
    | VARIABLE { log_rule("Primary -> VARIABLE"); }
    ;

Literal:
    BooleanLiteral { log_rule("Literal -> BooleanLiteral"); }
    | INTEGERLITERAL { log_rule("Literal -> INTEGERLITERAL"); }
    | FLOATLITERAL { log_rule("Literal -> FLOATLITERAL"); }
    ;

BooleanLiteral:
    TRUE { log_rule("BooleanLiteral -> TRUE"); }
    | FALSE { log_rule("BooleanLiteral -> FALSE"); }
    ;

Conditional:
    IfBlock ElseBlock { log_rule("Conditional -> IfBlock ElseBlock"); }
    | IfBlock { log_rule("Conditional -> IfBlock"); }
    ;

IfBlock:
    IF LPAREN Condition RPAREN LBRACE StatementList RBRACE { log_rule("IfBlock -> IF ( Condition ) { StatementList }"); }
    ;

ElseBlock:
    ELSE LBRACE StatementList RBRACE { log_rule("ElseBlock -> ELSE { StatementList }"); }
    ;

Loop:
    WHILE LPAREN Condition RPAREN LBRACE StatementList RBRACE { log_rule("Loop -> WHILE ( Condition ) { StatementList }"); }
    ;

Condition:
    ConditionTerm ConditionTermTail { log_rule("Condition -> ConditionTerm ConditionTermTail"); }
    ;

ConditionTermTail:
    AND ConditionTerm ConditionTermTail { log_rule("ConditionTermTail -> AND ConditionTerm ConditionTermTail"); }
    | OR ConditionTerm ConditionTermTail { log_rule("CT -> OR ConditionTerm ConditionTermTail"); }
    | { log_rule("ConditionTermTail -> empty"); }
    ;

ConditionTerm:
    Assignment { log_rule("ConditionTerm -> Assignment"); }
    | ConditionFactor ConditionFactorTail { log_rule("ConditionTerm -> ConditionFactor ConditionFactorTail"); }
    ;
 
ConditionFactorTail:
    BinaryOperator ConditionFactor ConditionFactorTail { log_rule("ConditionFactorTail -> BinaryOperator ConditionFactor ConditionFactorTail"); }
    | { log_rule("ConditionFactorTail -> empty"); }
    ;

ConditionFactor:
    
      NOT LPAREN Condition RPAREN { log_rule("ConditionFactor -> !(Condition)"); }
    | LPAREN Condition RPAREN {log_rule("ConditionFactor -> ( Condition)");}
    | NOT Literal { log_rule("ConditionFactor -> ! Literal");}
    | NOT VARIABLE  { log_rule("ConditionFactor -> ! VARIABLE");}
    | Literal { log_rule("ConditionFactor ->  Literal");}
    | VARIABLE { log_rule("ConditionFactor -> VARIABLE");}
    ;

BinaryOperator:
    LT { log_rule("BinaryOperator -> LT"); }
    | GT { log_rule("BinaryOperator -> GT"); }
    | LE { log_rule("BinaryOperator -> LE"); }
    | GE { log_rule("BinaryOperator -> GE"); }
    | EQ_OP { log_rule("BinaryOperator -> EQ_OP"); }
    | NE_OP { log_rule("BinaryOperator -> NE_OP"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file; // Set the input stream for the lexer
    }
    int result = yyparse();
    print_rules(); // Print the rules used during parsing
    return result;
}
