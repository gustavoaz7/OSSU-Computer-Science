fun swap (pair : int*int) = (#2 pair, #1 pair)

fun sum_pair_int (p1 : int*int) = (#1 p1 + #2 p1)

fun sum_two_pairs (p1 : int*int, p2 : int*int) =
    sum_pair_int(p1) + sum_pair_int(p2)

fun div_mod (a : int, b : int) = (a div b, a mod b)

fun sort_pair (p : int*int) =
    if (#1 p) < (#2 p) then p else (#2 p, #1 p)
