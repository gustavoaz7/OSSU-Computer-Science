
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

(* Q2.a *)
fun card_color (suit, rank) = 
    case suit of
        Spades => Black | Clubs => Black
    |   Diamonds => Red | Hearts => Red;

(* Q2.b *)
fun card_value (suit, rank) = 
    case rank of 
        Num x => x
    | Ace => 11
    | _ => 10;

(* Q2.c *)
fun remove_card (cardList, card, e) = 
    let
        fun recursion (cards, accCards) = 
            case cards of
                [] => raise e
            |   x::x' => if x = card
                        then accCards @ x'
                        else recursion(x' , x::accCards)
    in
        recursion(cardList, [])
    end;

(* Q2.d *)
fun all_same_color (cardList) =
    case cardList of
        [] => true
    | _::[] => true
    | x::(y::y') => (card_color(x) = card_color(y) andalso all_same_color(y::y'));

(* Q2.e *)
fun sum_cards (cardList) = 
    let
        fun recursion (cardList, acc) = 
            case cardList of
                [] => acc
            |   x::x' => recursion(x' , acc+card_value(x))
    in
        recursion(cardList, 0)
    end;

(* Q2.f *)
fun score (cardList, goal) = 
    let
        val sum = sum_cards(cardList)
        val prelim_score = if sum > goal 
                           then 3 * (sum - goal) 
                           else goal - sum
    in
        if all_same_color(cardList) 
        then prelim_score div 2 
        else prelim_score
    end;

(* Q2.g *)
fun officiate (cardList, moves, goal) = 
    let
        fun recursion(remainCards, nextMoves, cardsHeld) = 
            case nextMoves of
                [] => score(cardsHeld, goal)
            |   m::m' => case m of 
                    Discard c => recursion(remainCards, m' , remove_card(cardsHeld, c, IllegalMove))
                |   Draw => case remainCards of 
                        [] => score(cardsHeld, goal)
                    |   c::c' => if sum_cards(c::cardsHeld) > goal
                                 then score(c::cardsHeld, goal)
                                 else recursion(c' , m' , c::cardsHeld)
    in
        recursion(cardList, moves, [])
    end;
