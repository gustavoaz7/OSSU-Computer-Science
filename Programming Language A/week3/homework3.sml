(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	    val r = g f1 f2 
    in
        case p of
            Wildcard        => f1 ()
        | Variable x        => f2 x
        | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
        | ConstructorP(_,p) => r p
        | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* Q1 *)
fun only_capitals strList = List.filter(fn str => Char.isUpper(String.sub(str, 0))) strList;

(* Q2 *)
fun longest_string1 strList = List.foldl(fn (str, acc) => 
    if String.size(str) > String.size(acc)
    then str
    else acc) "" strList;

(* Q3 *)
fun longest_string2 strList = List.foldl(fn (str, acc) => 
    if String.size(str) >= String.size(acc)
    then str
    else acc) "" strList;

(* Q4 *)
fun longest_string_helper f strList = List.foldl(fn (str, acc) =>
    if f(String.size(str), String.size(acc))
    then str
    else acc) "" strList;

val longest_string3 = longest_string_helper(fn (a, b) => a > b);

val longest_string4 = longest_string_helper(fn (a, b) => a >= b);

(* Q5 *)
val longest_capitalized = longest_string1 o only_capitals;

(* Q6 *)
val rev_string = String.implode o rev o String.explode;



(* Q7 *)
fun first_answer f xs = 
    case xs of 
        [] => raise NoAnswer
    |   x::xs' => case f(x) of
                    SOME v => v
                |   NONE => first_answer f xs';

(* Q8 *)
fun all_answers f xs =
    let
        fun recursion remain acc =
            case remain of
                [] => SOME acc 
            |   x::xs' => case f(x) of
                            NONE => NONE
                        |   SOME v => recursion (xs') (v @ acc)
    in
        recursion (xs) []
    end;
