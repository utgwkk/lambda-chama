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

type tyvar = int

type ty =
  | TyVar of tyvar
  | TyFun of ty * ty

let rec string_of_ty = function
  | TyVar i -> "t" ^ string_of_int i
  | TyFun (t1, t2) ->
		match (t1, t2) with
		| TyFun _, _ -> Printf.sprintf "(%s) -> %s" (string_of_ty t1) (string_of_ty t2)
    | _ -> Printf.sprintf "%s -> %s" (string_of_ty t1) (string_of_ty t2)
