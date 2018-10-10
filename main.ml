let rec repl () =
  print_string "# ";
  flush stdout;
  let term = Parser.main Lexer.main (Lexing.from_channel stdin) in
  print_endline (Syntax.string_of_term term);
  repl ()

let () = repl ()
