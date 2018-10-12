# lambda-chama

## Requirements

- menhir

## Usage

```console
$ opam install menhir
$ make
$ ./lambda-chama
# ./lambda-chama -v # for verbose mode
```

## Grammar

```
<input> ::= <term> <eoi>
<term> ::= <alphabet> | \<alphabet>.<term> | <term> <term> | (<term>)
<alphabet> ::= a | b | ... | y | z
<eoi> ::= \n
```

## License

GPL
