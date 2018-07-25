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

