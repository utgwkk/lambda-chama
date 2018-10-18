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

## Options

|Options|Description|
|:-|:-|
|-v|Verbose mode. Show each step of beta-reduction.|
|--no-type-inference|Do not infer types.|
|--max-reduction=N|Abort reduction at N steps.|

## Grammar

```
<input> ::= <term> <eoi>
<term> ::= <alphabet> | \<alphabets>.<term> | <term> <term> | (<term>)
<alphabet> ::= a | b | ... | y | z
<alphabets> ::= <alphabet> | <alphabet> <alphabets>
<eoi> ::= \n
```

## License

GPL
