(* NONE has type 'a option
   SOME has type t option *)
(* isOME has type 'a option -> bool
   valOf has type 'a option -> 'a *)

fun max (x: int list) =
    if null x then NONE
    else
	let fun max_nonEmpty (x: int list) =
		if null (tl x) then hd x
		else
		    let val ans = max_nonEmpty(tl x)
		    in
			if hd x > ans then hd x else ans
		    end
	in SOME (max_nonEmpty x)
	end;

