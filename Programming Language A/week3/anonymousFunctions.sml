fun n_times (f,n,x) = 
    if n = 0
    then x
    else f(n_times(f, n-1, x));

fun trile_n_times (n,x) = n_times((fn y => 3*y), n, x);
(* Anonymous functions cannot be used recursively because there is no name to call it again *)
