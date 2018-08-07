(* old version *)
fun zip (l1, l2, l3) =
    if null l1 andalso null l2 andalso null l3
    then []
    else if null l1 orelse null l2 orelse null l3
    then raise ListLengthMismatch
    else (hd l1, hd l2, hd l3)::zip(tl l1, tl l2, tl l3);

(* new version *)
fun improvedZip list_triple =
    case list_triple of ([], [], []) => []
    (* hd1 and tl1 are variables. Each tuple element is a list, build with at least 2 elements (hd1 and tl1) *)
    |   (hd1::tl1, hd2:tl2, hd3::tl3) => (hd1, hd2, hd3)::improvedZip(tl1, tl2, tl3)
    |   _ => raise ListLengthMismatch;

fun unzip ls =
    case ls of [] => ([], [], [])
    |   (a, b, c)::tl => let val (l1, l2, l3) = unzip tl
                        in (a::l1, b::l2, c::l3)
                        end;


fun nondecreasing xs = 
    case xs of [] => true
    |   x::[] => true
    |   h::(neck::rest) => head <= neck andalso nondecreasing (neck::rest);

