type index = int

exception Error of string
exception Reduction_depth of string

let err s = raise (Error s)

type term =
  | Var of index
  | FreeVar of Syntax.id
  | Fun of term
  | App of term * term

let rec string_of_term = function
  | Var i -> string_of_int i
  | FreeVar i -> i
  | Fun t -> (
      match t with
      | App _ -> Printf.sprintf "\\.(%s)" (string_of_term t)
      | _ -> Printf.sprintf "\\.%s" (string_of_term t)
  )
  | App (t1, t2) -> (
      match t1, t2 with
      | Fun _, Var _ -> Printf.sprintf "(%s) %s" (string_of_term t1) (string_of_term t2)
      | Fun _, _ -> Printf.sprintf "(%s) (%s)" (string_of_term t1) (string_of_term t2)
      | App _, App _ -> Printf.sprintf "%s (%s)" (string_of_term t1) (string_of_term t2)
      | App _, Fun _ -> Printf.sprintf "(%s) (%s)" (string_of_term t1) (string_of_term t2)
      | Var _, App _ -> Printf.sprintf "%s (%s)" (string_of_term t1) (string_of_term t2)
      | _, _ -> Printf.sprintf "%s %s" (string_of_term t1) (string_of_term t2)
  )

let rec body env depth = function
  | Syntax.Var i -> (
    try
      let idx = depth - (Env.lookup i env) in
      Var idx
    with
      Env.Not_bound -> FreeVar i
  )
  | Syntax.Fun (i, t) ->
      let newenv = Env.extend i (depth + 1) env in
      Fun (body newenv (depth + 1) t)
  | Syntax.App (t1, t2) ->
      App (body env depth t1, body env depth t2)

let rec shift c i = function
  | Var n -> Var (if n < c then n else n + i)
  | FreeVar i -> FreeVar i
  | Fun t -> Fun (shift (c + 1) i t)
  | App (t1, t2) -> App (shift c i t1, shift c i t2)

let lift = shift 0

let rec subst t m t1 =
  match t1 with
  | Var n -> if n = m then t else Var n
  | FreeVar i -> FreeVar i
  | Fun t1 ->
      let t' = lift 1 t in
      Fun (subst t' (m + 1) t1)
  | App (t1, t2) -> App (subst t m t1, subst t m t2)

let rec has_redex = function
  | App (Fun _, _) -> true
  | App (t1, t2) -> has_redex t1 || has_redex t2
  | Fun t -> has_redex t
  | _ -> false

let rec beta = function
  | App (Fun t1, t2) ->
      let t2' = lift 1 t2 in
      let t1' = subst t2' 0 t1 in
      lift (-1) t1'
  | App (t1, t2) ->
      if has_redex t1 then App (beta t1, t2)
      else App (t1, beta t2)
  | Fun t -> Fun (beta t)
  | t -> t

let rec fix f n t =
  let old = t in
  let t' = f t in
  if n <= 0 then
    raise (Reduction_depth "Max reduction depth exceeded.")
  else
    if t' = old then (n, t')
    else fix f (n - 1) t'

let convert term verbose max_reduction show_num_steps =
  let reduce =
    if verbose then (fun t -> Printf.printf "-> %s\n" (string_of_term t); beta t)
    else beta
  in
  let (rest_reduction, t) =
    body Env.empty 0 term
    |> fix reduce max_reduction
  in
  if show_num_steps then
    let step = max_reduction - rest_reduction in
    Printf.printf "Reduced in %d steps:\n" step;
    t
  else t
