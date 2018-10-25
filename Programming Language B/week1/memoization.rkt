#lang racket
(provide (all-defined-out))

(define (fibonacci1 x)
    (if (or (= x 1) (= x 2))
        1
        (+ (fibonacci1 (- x 1)) (fibonacci1 (- x 2)))
    )
)

(define fibonacci
    (letrec ([memo null]    ; list of pairs (arg . result) 
        [f (lambda (x)
            (let ([ans (assoc x memo)]) ; assoc returns the pair (if there is one) where x is found in #1
                (if ans 
                    (cdr ans)
                    (let ([new-ans (if 
                        (or (= x 1) (= x 2))
                        1
                        (+ (f (- x 1)) (f (- x 2)))
                    )])
                        (begin 
                            (set! memo (cons (cons x new-ans) memo))
                            new-ans
                        )
                    )
                )
            )
        )]
    ) f)
)
