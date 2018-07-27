fun sum_list ls = 
    case ls of 
        [] => 0
    |   x::ls' => x + sum_list ls';

fun append (xs, ys) = 
    case xs of 
        [] => ys
    |   x::xs' => x::append(xs', ys);



datatype 'a option = NONE | SOME of 'a

datatype ('a,'b) tree = Node of 'a * ('a,'b) tree * ('a,'b) tree | Leaf of 'b

fun sum_tree tr = 
    case tr of 
        Leaf i => i
    |   Node(i, lt, rg) => i + sum_tree lt + sum_tree rg;

