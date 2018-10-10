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
      let newenv = Env.extend i (depth + 1) env in
      Fun (body newenv (depth + 1) t)
  | Syntax.App (t1, t2) ->
      App (body env depth t1, body env depth t2)

let rec shift c i = function
  | Var n -> Var (if n < c then n else n + i)
  | Fun t -> Fun (shift (c + 1) i t)
  | App (t1, t2) -> App (shift c i t1, shift c i t2)

let lift = shift 0

let rec subst t m t1 =
  match t1 with
  | Var n -> if n = m then t else Var n
  | Fun t1 ->
      let t' = lift 1 t in
      Fun (subst t' (m + 1) t1)
  | App (t1, t2) -> App (subst t m t1, subst t m t2)

let rec beta = function
  | App (Fun t1, t2) ->
      let t2' = lift 1 t2 in
      let t1' = subst t2' 0 t1 in
      lift (-1) t1'
  | App (t1, t2) -> App (beta t1, beta t2)
  | Fun t -> Fun (beta t)
  | t -> t

let rec fix f t =
  let old = t in
  let t' = f t in
  if t' = old then t'
  else fix f t'

let convert term =
  body Env.empty 0 term
  |> fix beta
