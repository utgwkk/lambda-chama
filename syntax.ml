type id = string

type term =
  | Var of id
  | Fun of id * term
  | App of term * term

let rec string_of_term = function
  | Var i -> i
  | Fun (i, e) -> (
      match e with
      | App _ -> Printf.sprintf "\\%s.(%s)" i (string_of_term e)
      | _ -> Printf.sprintf "\\%s.%s" i (string_of_term e)
  )
  | App (e1, e2) -> (
      match e1, e2 with
      | Fun _, Var _ -> Printf.sprintf "(%s) %s" (string_of_term e1) (string_of_term e2)
      | Fun _, Fun _ -> Printf.sprintf "(%s) (%s)" (string_of_term e1) (string_of_term e2)
      | _, App _ -> Printf.sprintf "%s (%s)" (string_of_term e1) (string_of_term e2)
      | _, _ -> Printf.sprintf "%s %s" (string_of_term e1) (string_of_term e2)
  )
