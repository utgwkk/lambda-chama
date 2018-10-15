let verbose = ref false

let no_type_inference = ref true

let rec repl () =
  print_string "# ";
  flush stdout;
  try
    let term = Parser.main Lexer.main (Lexing.from_channel stdin) in
    if !no_type_inference then
      let indexed_term = DeBruijn.convert term !verbose in
      Printf.printf "%s\n" (DeBruijn.string_of_term indexed_term);
      repl ()
    else
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
  Printf.sprintf "Verbose mode. (default: %b)" !verbose);
  ("--no-type-inference", Arg.Unit (fun () -> no_type_inference := true),
  Printf.sprintf "Disable type inference. (default: %b)" !no_type_inference);
]

let () =
  Arg.parse aspec ignore usage;
  repl ()
