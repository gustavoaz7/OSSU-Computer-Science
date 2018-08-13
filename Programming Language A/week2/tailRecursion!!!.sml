
fun factorial n = if n = 0 then 1 else n*factorial(n-1);

fun fact n = let
  fun recursion (x, acc) = 
    if x = 0 then acc else recursion(x-1, acc*x)
in 
    recursion(n, 1)
end;

(*
    EXPLANATION
In 'factorial', every recursive call needs to be calculated (multiplied by n) to get the final result.
Whereas, in 'fact', the result of the recursive call IS the result of the caller.

    CALL-STACK
FACTORIAL
factorial 3 = 3 * factorial 2
                  factorial 2 = 2 * factorial 1
                                    factorial 1 = 1 * factorial 0
                                                      factorial 0 = 1
                                    factorial 1 = 1 * 1
                  factorial 2 = 2 * 1
factorial 3 = 3 * 2
factoria 3 = 6

FACT:
fact 3 = recursion(3,1) = recursion(2,3) = recursion(1,6) = recursion(0,6) = 6
*)

(*
    TAIL-RECURSION
tail-recursive: recursive calls are tail-calls  (Ex: fact n)
    Methodology:
        Create a helper function that takes an accumulator
        Old base case becomes initial accumulator
        New base case becomes final accumulaor
*)