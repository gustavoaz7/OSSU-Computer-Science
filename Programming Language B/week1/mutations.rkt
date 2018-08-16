#lang racket
(provide (all-defined-out))

(define a 10)
(define f (lambda (x) (+ x a)))
(define b (+ a 5))  ; 15
(set! a 1)  ; mutates a
(define z (f 2))    ; 3
(define w b)        ; 15

; Avoiding mutation of a variables referenced in a function
(define e 3)
(define g 
    (let ([e e]) 
        (lambda (x) (+ x e))
    )
)