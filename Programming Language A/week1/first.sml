val x = 5

fun pow (x: int, y: int) =
    if y=0 then 1
    else x * pow(x, y-1)

fun cube (x: int) = pow(x,3)

val cubicFour = cube(4);
val twoToTheSeventh = pow(2,7);
