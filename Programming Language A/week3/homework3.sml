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



(* Q9.a *)
fun count_wildcards p = g (fn x => 1) (fn x => 0) p;

(* Q9.b *)
fun count_wild_and_variable_lengths p = g (fn x => 1) String.size(p);

(* Q9.c *)
fun count_some_var (str, p) = g (fn x => 0) (fn x => if x = str then 1 else 0) p;

(* Q10 *)
fun check_pat p = 
    let
        fun list_of_variables p acc = 
            case p of
                Variable x => x::acc
            |   ConstructorP (_, p') => list_of_variables p' acc
            |   TupleP ps => List.foldl(fn (p', acc') => (list_of_variables p' []) @ acc') [] ps
            |   _ => acc
        fun isUnique strList =
            case strList of 
                [] => true
            |   s::s' => if List.exists(fn x => x = s) s' then false else isUnique s'
    in
        isUnique(list_of_variables p [])
    end;

(* Q11 *)
fun match (v, p) = 
    case (v, p) of
        (v, Wildcard) => SOME []
    |   (v, Variable s) => SOME [(s, v)]
    |   (Unit, UnitP) => SOME []
    |   (Const a, ConstP b) => if a = b then SOME [] else NONE
    |   (Tuple vs, TupleP ps) => if List.length vs = List.length ps
                                    then all_answers match (ListPair.zip(vs, ps))
                                    else NONE
    |   (Constructor (s, v), ConstructorP(s', p')) => if s = s' then match(v, p') else NONE
    |   _ => NONE;

(* Q12 *)
fun first_match v ps = SOME (first_answer(fn p => match(v, p)) ps) handle NoAnswer => NONE;
