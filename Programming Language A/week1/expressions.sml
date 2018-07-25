(* expressions and nested functions *)

fun list1toN (n: int) =
    let fun count (from: int) =
	    if from = n then n::[] else from::count(from+1)
    in count(1)
    end;


fun max (x: int list) =
    if null x then 0
    else if null (tl x) then hd x
    else let val ans = max(tl x)
	 in if hd x > ans then hd x else ans
	 end; 



