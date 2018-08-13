fun map (f, xs) =
    case xs of
	    [] => []
        | x::x' => (f x)::(map(f, x'));

val arrayPlusOne = map ((fn x => x+1), [4, 8, 12, 16])

val heads = map (hd, [[1, 2], [3, 4], [5, 6, 7]])



fun filter (f,xs) =
    case xs of
	    [] => []
        | x::x' => if f x
		  then x::(filter (f, x'))
		  else filter (f, x');

fun is_even v = (v mod 2 = 0);

fun all_even xs = filter(is_even, xs);
	
fun all_even_snd xs = filter((fn (_, v) => is_even v), xs);



fun fold (f, acc, xs) =
    case xs of 
	    [] => acc
    |   x::xs' => fold (f, f(acc, x), xs');

fun f1 xs = fold ((fn (x,y) => x+y), 0, xs);

fun f2 (xs,lo,hi) = 
    fold ((fn (x,y) => 
	    x + (if y >= lo andalso y <= hi then 1 else 0)),
        0, xs);

fun f3 (xs,s) =
    let 
	    val i = String.size s
    in
	    fold((fn (x,y) => x andalso String.size y < i), true, xs)
    end;

fun f4 (g,xs) = fold((fn(x,y) => x andalso g y), true, xs);

fun f3a (xs,s) =
    let
	    val i = String.size s
    in
	    f4(fn y => String.size y < i, xs)
    end;