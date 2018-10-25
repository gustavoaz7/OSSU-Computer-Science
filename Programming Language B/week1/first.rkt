#lang racket

(provide (all-defined-out))

(define h "Hello World!")

(define x 3)
(define cube (lambda (x) (* x x x))) ; lambda is racket's "function" keyword
(define (cube1 x) (* x x x))

(define (pow x y) 
    (if (= y 0) 1 (* x (pow x (- y 1))))) ; (if e1 e2 e3) - No then/else
