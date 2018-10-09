type id = string

type exp =
  | Var of id
  | Fun of id * exp
  | App of exp * exp

let rec string_of_exp = function
  | Var i -> i
  | Fun (i, e) -> Printf.sprintf "\\%s.%s" i (string_of_exp e)
  | App (e1, e2) -> Printf.sprintf "(%s %s)" (string_of_exp e1) (string_of_exp e2)
