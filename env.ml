type 'a t = (Syntax.id * 'a) list

exception Not_bound

let empty = []

let extend id v env = (id, v) :: env

let lookup id env = try List.assoc id env with Not_found -> raise Not_bound
