(* all elements in a list must share the same type (int, bool, etc.)!! *)

(* you can create a list by adding a new element to a list like so  1::[2,3] *)
val a = [2, 3];
val seq = 1::[2, 3];

(* 'null' is a function that evaluates to true if [] (empty list)  *)
val listIsEmpty = null [];  (* true *)
val seqIsEmptyList = null(seq); (* false *)

(* 'hd' (head) is a function that returns the first el of a list
   'tl' (tail) is a function that returns the rest of the list *)
val first = hd(seq); (* 1 *)
val rest = tl(seq); (* [2, 3] *)


 
(*  FUNCTIONS  *)

fun sum_list_int (x: int list) =
    if null x then 0 else hd x + sum_list_int(tl x);

fun countdown (x: int) =
    if x = 0 then []  else x:: countdown(x-1);

fun append (x: int list, y: int list) =
    if null(x) then y else (hd x)::append((tl x), y);
