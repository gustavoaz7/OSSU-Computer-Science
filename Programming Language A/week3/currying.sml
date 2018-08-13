fun tripleSorted (x,y,z) = z >= y andalso y >= x;

val s1 = tripleSorted (1,2,3);


val tripleSortedCurry = fn x => fn y => fn z => z >= y andalso y >= x;

val s2 = (((tripleSortedCurry 1) 2) 3)
val s2a = tripleSortedCurry 1 2 3


fun tripleSortedCurrySuger x y z = z>= y andalso y >= x;

val s3 = tripleSortedCurrySuger 1 2 3
