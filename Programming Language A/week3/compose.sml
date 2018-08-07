fun compose(f, g) = fn x => f(g, x);

fun sqrt_of_n i = Math.sqrt(Real.fromInt(abs(i)));
fun sqrt_of_m i = (Math.sqrt o Real.fromInt o abs) i;
fun sqrt_of_o = Math.sqrt o Real.fromInt o abs;

(* Pipeline !> *)
infix !>

fun x !> f = f(x)

fun sqrt_of_p i = i !> abs !> Real.fromInt !> Math.sqrt;
