#lang racket
(provide (all-defined-out))

; Assuming all elements are numbers or lists of numbers
(define (sumOfList xs)
    (if (null? xs) 0 
        (if (number? (car xs))
            (+ (car xs) (sumOfList (cdr xs)))
            (+ (sumOfList (car xs)) (sumOfList (cdr xs)))
        )
    )
)

; COND  [e1 e2]
    ; if e1 then e2
    ; [e1 e2] [e3 e4] [e5 e6] [#t e7]  (last if expression should be true (works like else))
(define (sumOfList1 xs)
    (cond [(null? xs) 0]
          [(number? (car xs)) (+ (car xs) (sum1 (cdr xs)))]
          [#t (+ (sumOfList1 (car xs)) (sumOfList1 (cdr xs)))]
    )
)

; OBS > Every value other than #f is evaluated to true
(if 1 1 0)          ; 1
(if "str" 1 0)      ; 1
(if (list 2 3) 1 0) ; 1
(if null 1 0)       ; 1
(if #f 1 0)         ; 0