
(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* Q1.a *)
fun all_except_option (str, strList) = 
    let 
        fun recursion (strList, accList) = 
            case strList of 
                [] => NONE
            |   s::s' => if same_string(str, s) 
                    then SOME (accList @ s')
                    else recursion(s' , s::accList)
    in
        recursion(strList, [])
    end;

(* Q1.b *)
fun get_substitutions1 (strListsList, str) = 
    case strListsList of 
        [] => []
    |   s::s' => case all_except_option(str, s) of
                    NONE => get_substitutions1(s', str)
                |   SOME e => e @ get_substitutions1(s', str);


(* Q1.c *)
fun get_substitutions2 (strListsList, str) = 
    let
        fun recursion (strListsList, accListsList) =
            case strListsList of 
                [] => accListsList
            |   s::s' => case all_except_option(str, s) of
                    NONE => recursion(s' , accListsList)
                |   SOME e => recursion(s' , accListsList @ e)
    in
        recursion(strListsList, [])
    end;

(* Q1.d *)
fun similar_names (strListsList, {first = firstName, middle = middleName, last = lastName}) = 
    let
        fun recursion (strList) = 
            case strList of 
                [] => []
            |   s::s' => {first = s, middle = middleName, last = lastName}::recursion(s')
    in
        {first = firstName, middle = middleName, last = lastName}::recursion(get_substitutions2(strListsList, firstName))
    end;


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

