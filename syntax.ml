type id = string

type exp =
  | Var of id
  | Fun of id * exp
  | App of exp * exp

let rec string_of_exp = function
  | Var i -> i
  | Fun (i, e) -> (
      match e with
      | App _ -> Printf.sprintf "\\%s.(%s)" i (string_of_exp e)
      | _ -> Printf.sprintf "\\%s.%s" i (string_of_exp e)
  )
  | App (e1, e2) -> (
      match e1, e2 with
      | Fun _, Var _ -> Printf.sprintf "(%s) %s" (string_of_exp e1) (string_of_exp e2)
      | Fun _, Fun _ -> Printf.sprintf "(%s) (%s)" (string_of_exp e1) (string_of_exp e2)
      | _, App _ -> Printf.sprintf "%s (%s)" (string_of_exp e1) (string_of_exp e2)
      | _, _ -> Printf.sprintf "%s %s" (string_of_exp e1) (string_of_exp e2)
  )
