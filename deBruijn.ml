type index = int

type term =
  | Var of index
  | Fun of term
  | App of term * term

let rec string_of_term = function
  | Var i -> string_of_int i
  | Fun t -> (
      match t with
      | App _ -> Printf.sprintf "\\.(%s)" (string_of_term t)
      | _ -> Printf.sprintf "\\.%s" (string_of_term t)
  )
  | App (t1, t2) -> (
      match t1, t2 with
      | Fun _, Var _ -> Printf.sprintf "(%s) %s" (string_of_term t1) (string_of_term t2)
      | Fun _, Fun _ -> Printf.sprintf "(%s) (%s)" (string_of_term t1) (string_of_term t2)
      | _, App _ -> Printf.sprintf "%s (%s)" (string_of_term t1) (string_of_term t2)
      | _, _ -> Printf.sprintf "%s %s" (string_of_term t1) (string_of_term t2)
  )

let rec body env depth = function
  | Syntax.Var i ->
      let idx = depth - (Env.lookup i env) in
      Var idx
  | Syntax.Fun (i, t) ->
      let newenv = Env.extend i depth env in
      Fun (body newenv (depth + 1) t)
  | Syntax.App (t1, t2) ->
      App (body env depth t1, body env depth t2)

let convert term = body Env.empty 0 term
