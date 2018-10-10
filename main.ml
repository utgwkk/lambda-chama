let rec repl () =
  print_string "# ";
  flush stdout;
  let term = Parser.main Lexer.main (Lexing.from_channel stdin) in
  let (_, ty) = Typing.type_infer term in
  Printf.printf "%s : %s\n" (Syntax.string_of_term term) (Syntax.string_of_ty ty);
  repl ()

let () = repl ()
