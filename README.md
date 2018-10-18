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

## Presentation

- [つくってあそぼ ラムダ計算インタプリタ / Implement an Interpreter of Lambda Calculus](https://speakerdeck.com/kmc_jp/implement-an-interpreter-of-lambda-calculus) (Japanese)

## License

GPL
