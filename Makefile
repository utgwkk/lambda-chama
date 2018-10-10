SOURCES = syntax.ml parser.mly lexer.mll env.mli env.ml typing.ml main.ml
RESULT = lambda-chama

OCAMLYACC = menhir

-include OCamlMakefile
