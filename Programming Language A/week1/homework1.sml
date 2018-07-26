(* HOMEWORK 1 *)


(* Helpers *)
fun YEAR (date: int*int*int) = #1 date;
fun MONTH (date: int*int*int) = #2 date;
fun DAY (date: int*int*int) = #3 date;


(* Q1 *)
fun is_older(d1: int*int*int, d2: int*int*int) =
    if YEAR(d1) < YEAR(d2) then true
    else if YEAR(d1) > YEAR(d2) then false
    else if MONTH(d1) < MONTH(d2) then true
    else if MONTH(d1) > MONTH(d2) then false
    else if DAY(d1) < DAY(d2) then true
    else false;

(* Q2 *)
fun number_in_month (dates: (int*int*int) list, month: int) =
    let
	fun recursion(datesTail: (int*int*int) list, counter: int) =
	    if null datesTail then counter
	    else
		if MONTH(hd datesTail) = month
		then recursion(tl datesTail, counter+1)
		else recursion(tl datesTail, counter)
    in recursion(dates, 0)
    end;

(* Q3 *)
fun number_in_months (dates: (int*int*int) list, months: int list) =
    if null months then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months);

(* Q4  *)
fun dates_in_month (dates: (int*int*int) list, month: int) =
    if null dates then []
    else
	let val accum = dates_in_month(tl dates, month)
	in
	    if MONTH(hd dates) = month
	    then (hd dates)::accum
	    else accum
	end;

(* Q5  obs: list-append operator @  *)
fun dates_in_months (dates: (int*int*int) list, months: int list) =
    if null months then []
    else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months);

(* Q6 *)
fun get_nth (strings: string list, n: int) =
    if n = 1 then hd strings
    else get_nth(tl strings, n-1);

(* Q7  obs: string concatenator operator ^  *)
fun date_to_string(date: int*int*int) =
    let val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in get_nth(months, MONTH(date)) ^ " " ^ Int.toString(DAY(date)) ^ ", " ^ Int.toString(YEAR(date))
    end;

(* Q8 *)
fun number_before_reaching_sum (sum: int, integers: int list) =
    if sum - hd integers <= 0 then 0
    else 1 + number_before_reaching_sum(sum - hd integers, tl integers);

(* Q9 *)
fun what_month (d: int) =
    number_before_reaching_sum(d, [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) + 1;

(* Q10 *)
fun month_range (d1: int, d2: int) =
    if d1 > d2 then []
    else what_month(d1) :: month_range(d1 + 1, d2);

(* Q11 *)
fun oldest (dates: (int*int*int) list) =
    if null dates then NONE
    else let
	fun recursion(olderDate: int*int*int, datesTail: (int*int*int) list) =
	    if null datesTail then SOME olderDate
	    else
		if is_older(olderDate, hd datesTail)
		then recursion(olderDate, tl datesTail)
		else recursion(hd datesTail, tl datesTail)
    in recursion(hd dates, tl dates)
    end;