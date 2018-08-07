datatype specialType = FourInts of int * int * int * int | Str of string | UniqueType

val a = Str;
val b = Str "hello world";
(* val c = FourInts(1,2,3);  Error *)
val d = FourInts(1,2,3,4);
val e = UniqueType;
(* val f = UniqueType(2); Error *)
(* val g = UniqueType "what"; Error *)


(* f has type specialType -> string *)
fun f (x: specialType) = 
    case x of UniqueType => "Unique"
        | Str s => s
        | FourInts(i1, i2, i3, i4) => Int.toString(i1+i2+i3+i4)



(* Useful for enumerations and identification *)
datatype suit = Club | Diamond | Heart | Spade
datatype deck = Jack | Queen | King | Ace | Num of int
type card = suit * deck

fun is_king_of_heart (c: card) = 
    c = (Heart, King)
    (* #1 c = Heart andalso #2 c =  King; *)



datatype exp = Constant of int | Negative of int | Add of exp*exp | Multiply of exp*exp

fun eval e = 
    case e of 
        Constant i => i
    |   Negative i => ~i
    |   Add(e1, e2) => eval(e1) + eval(e2)
    |   Multiply(e1, e2) => eval(e1) * eval(e2);

fun max e = case e of
        Constant i => i
    |   Negative i => ~1
    |   Add(e1, e2) => Int.max(max e1, max e2)
    |   Multiply(e1, e2) => Int.max(max e1, max e2);

val  test = Add(Constant 19, Negative 4);
val nineteen = max test;
