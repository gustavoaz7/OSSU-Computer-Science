exception UnwantedCondition of int

fun f n =
    if n = 0 then raise List.Empty
    else if n = 1 then raise (UnwantedCondition 4)
    else n * n;

val x = (f 1 handle List.Empty => 42) handle UnwantedCondition n => f n
(* x = 16 *)
(* x = f 1 -> UnwantedCondition 4 => f 4 -> 4 * 4 -> 16 *)