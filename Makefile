SOURCES = syntax.ml parser.mly lexer.mll env.mli env.ml mySet.ml mySet.mli typing.ml deBruijn.ml main.ml
RESULT = lambda-chama

OCAMLYACC = menhir

-include OCamlMakefile
