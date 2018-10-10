let rec repl () =
  print_string "# ";
  flush stdout;
  let term = Parser.main Lexer.main (Lexing.from_channel stdin) in
  let (_, ty) = Typing.type_infer term in
  let indexed_term = DeBruijn.convert term in
  Printf.printf "%s : %s\n" (DeBruijn.string_of_term indexed_term) (Syntax.string_of_ty ty);
  repl ()

let () = repl ()
