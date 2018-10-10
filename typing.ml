open Syntax

exception Error of string

let err s = raise (Error s)

let _counter = ref 0

let fresh_tyvar () =
  _counter := !_counter + 1;
  !_counter

let reset_counter () =
  _counter := 0

type tyenv = ty Env.t

type subst = (tyvar * ty) list

let subst_type subs t =
  let rec substitute (tyvar, tyrepl) = function
    | TyVar a -> if a = tyvar then tyrepl else TyVar a
    | TyFun (a, b) ->
        TyFun (substitute (tyvar, tyrepl) a, substitute (tyvar, tyrepl) b)
  in
  List.fold_right substitute subs t

let eqs_of_subst s = List.map (fun (tyv, t) -> (TyVar tyv, t)) s

let subst_eqs s eqs =
  List.map (fun (t1, t2) -> (subst_type s t1, subst_type s t2)) eqs

let rec unify =
  let rec ftv tyvar = function
    | TyFun (a, b) -> ftv tyvar a || ftv tyvar b
    | TyVar a -> tyvar = a
  in
  function
    | [] -> []
    | (t1, t2) :: tl ->
        if t1 = t2 then unify tl
        else
          match (t1, t2) with
          | TyFun (t11, t12), TyFun (t21, t22) ->
              unify ((t11, t21) :: (t12, t22) :: tl)
          | TyVar tv, t ->
              if ftv tv t then
                err (Printf.sprintf "type variable t%d appears inside %s." tv (string_of_ty t))
              else (tv, t) :: (unify @@ subst_eqs [(tv, t)] tl)
          | t, TyVar tv -> unify @@ (TyVar tv, t) :: tl

let rec infer env = function
  | Var i -> ([], Env.lookup i env)
  | Fun (i, t) ->
    let ty_arg = TyVar (fresh_tyvar ()) in
    let newenv = Env.extend i ty_arg env in
    let (s, ty_body) = infer newenv t in
    (s, TyFun (subst_type s ty_arg, ty_body))
  | App (t1, t2) ->
    let (s1, ty_fun) = infer env t1 in
    let (s2, ty_arg) = infer env t2 in
    let ty_ret = TyVar (fresh_tyvar ()) in
    let eqs = (ty_fun, TyFun (ty_arg, ty_ret)) :: eqs_of_subst s1 @ eqs_of_subst s2 in
    let s3 = unify eqs in
    (s3, subst_type s3 ty_ret)

let rec fv = function
  | Syntax.Var i -> MySet.singleton i
  | Syntax.Fun (i, t) -> MySet.diff (fv t) (MySet.singleton i)
  | Syntax.App (t1, t2) -> MySet.union (fv t1) (fv t2)

let type_infer term =
  reset_counter ();
  let fvs = fv term in
  let env =
    List.fold_left (fun env id -> Env.extend id (TyVar (fresh_tyvar ())) env) Env.empty (MySet.to_list fvs) in
  infer env term
