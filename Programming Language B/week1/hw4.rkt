
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

; Q1
(define (sequence low high stride)
    (if (< high low) null (cons low (sequence (+ low stride) high stride)))
)

; Q2
(define (string-append-map xs suffix) 
    (map (lambda (x) (string-append x suffix)) xs)
)

; Q3
(define (list-nth-mod xs n)
    (cond [(< n 0) (error "list-nth-mod: negative number")]
          [(null? xs) (error "list-nth-mod: empty list")]
          [#t (car (list-tail xs (remainder n (length xs))))] 
    )
)

; Q4
(define (stream-for-n-steps s n)
    (if (= n 0) null
        (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))
    )
)

; Q5
(define funny-number-stream
    (letrec (
        [f (lambda (x) 
            (if (= (remainder x 5) 0)
                (cons (* x -1) (lambda () (f (+ x 1))))
                (cons x (lambda () (f (+ x 1))))
            )
        )])
    (lambda () (f 1)))
)

; Q6
(define dan-then-dog
    (letrec (
        [f (lambda () (cons "dan.jpg" g))]
        [g (lambda () (cons "dog.jpg" f))]
    ) f)
)
