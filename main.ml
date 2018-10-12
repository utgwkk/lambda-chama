let verbose = ref false

let rec repl () =
  print_string "# ";
  flush stdout;
  try
    let term = Parser.main Lexer.main (Lexing.from_channel stdin) in
    let (_, ty) = Typing.type_infer term in
    let indexed_term = DeBruijn.convert term !verbose in
    Printf.printf "%s : %s\n" (DeBruijn.string_of_term indexed_term) (Syntax.string_of_ty ty);
    repl ()
  with
    | Typing.Error s ->
        Printf.printf "Error on type inference: %s\n" s;
        repl ()

let usage = "Usage: " ^ Sys.argv.(0) ^ " [-v]"

let aspec = Arg.align [
  ("-v", Arg.Unit (fun () -> verbose := true),
  Printf.sprintf "Verbose mode. (default: %b)" !verbose)
]

let () =
  Arg.parse aspec ignore usage;
  repl ()
