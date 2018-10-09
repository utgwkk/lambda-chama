let rec repl () =
  print_string "# ";
  flush stdout;
  let e = Parser.main Lexer.main (Lexing.from_channel stdin) in
  print_endline (Syntax.string_of_exp e);
  repl ()

let () = repl ()
