{
  open Parser
}

rule main = parse
    [' ' '\t']+ { main lexbuf }
  | ['\n'] { EOL }
  | ['a'-'z'] { ID (Lexing.lexeme lexbuf) }
  | '\\' { LAMBDA }
  | '.' { DOT }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | eof { exit 0 }
