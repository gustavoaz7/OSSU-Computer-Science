#lang racket
(provide (all-defined-out))

; let  let*  letrec  define

; let - evaluates all expressions using outer environment
(define (double1 x)
    (let ([x (+ x 3)] [y (+ x 2)])
        (+ x y -5)
    )
)

; let* - environment includes previous bindings
(define (double2 x)
    (let* ([x (+ x 3)] [y (+ x 2)])
        (+ x y -8)
    )
)

; letrec - expressions are evaluated in the environment that includes all bindings
(define (triple x)
    (letrec ([y (+ x 2)]
             [f (lambda (z) (+ z y w x))]
             [w (+ x 7)])
        (f -9)
    )
)

(define (mod2 x)
    (letrec (
        [even? (lambda (x) (if (zero? x) #t (odd? (- x 1))))]
        [odd? (lambda (x) (if (zero? x) #f (even? (- x 1))))]
    )
        (if (even? x) 0 1)
    )
)


; define locally the same as letrec when binding local variables
(define (mod2_b x)
    (define even? (lambda(x)(if (zero? x) #t (odd? (- x 1)))))
    (define odd?  (lambda(x)(if (zero? x) #f (even? (- x 1)))))
    (if (even? x) 0 1)
)
