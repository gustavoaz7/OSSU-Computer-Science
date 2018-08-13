val x = ref 42 
val y = ref 42 
val z = x
val _ = x := 43
val w = (!y) + (!z) (* = 85 *)

val cbs : (int -> unit) list ref = ref []

fun onKeyEvent f = cbs := f::(!cbs);

fun onEvent e = 
    let
        fun loop fs =
            case fs of
                [] => ()
            |   f:fs' => (f e; loop fs')
    in
      loop (!cbs)
    end;

