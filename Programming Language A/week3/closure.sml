(* 
    Lexical Scope
We use environment where the function was defined, not the one where it is being called.

    Closure
It is the combination of a function and the environment from which it was declared.


val x = 10
fun f(y) = x + y
         = 10 + y
val x = 1
val y = 5
val z = f(x + y)
        f(1 + 5) = f(6) = 10 + 6 = 16

*)

