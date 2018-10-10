%{
  open Syntax
%}
%token <Syntax.id> ID
%token LPAREN RPAREN
%token LAMBDA DOT
%token EOL

%start main
%type <Syntax.term> main
%%

main:
  Expr EOL { $1 }

Expr:
| LAMBDA i=ID DOT e=Expr { Fun (i, e) }
| AppExpr { $1 }

AppExpr:
| e1=AppExpr e2=AExpr { App (e1, e2) }
| AExpr { $1 }

AExpr:
| i=ID { Var i }
| LPAREN e=Expr RPAREN { e }
