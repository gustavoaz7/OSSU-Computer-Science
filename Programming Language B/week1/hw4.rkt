
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

; Q7
(define (stream-add-zero s)
    (lambda () (cons (cons 0 (car (s))) (stream-add-zero (cdr (s)))))
)

; Q8
(define (cycle-lists xs ys)
    (letrec (
        [f (lambda (z) (cons (cons (list-nth-mod xs z) (list-nth-mod ys z)) (lambda () (f (+ z 1)))))]
    ) (lambda () (f 0)))
)

; Q9
(define (vector-assoc v vec)
    (letrec (
        [f (lambda (x) 
            (cond [(>= x (vector-length vec)) #f]
                  [(not (pair? (vector-ref vec x))) (f (+ x 1))]
                  [#t (let ([pr (vector-ref vec x)])
                        (if (equal? (car pr) v) pr (f (+ x 1))))
                  ]
            )
        )]
    ) (f 0))
)

; Q10
(define (cached-assoc xs n)
    (letrec 
        ([cache (make-vector n #f)]
         [i 0])
        (lambda (x)
            (let ([cached-ans (vector-assoc x cache)])
                (if 
                    cached-ans 
                    cached-ans
                    (begin 
                        (vector-set! cache i (assoc x xs))
                        (set! i (remainder (+ i 1) n))
                        (vector-assoc x cache)
                    )
                )
            )
        )
    )
)
