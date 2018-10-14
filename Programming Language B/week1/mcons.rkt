#lang racket
(provide (all-defined-out))

; cons cells are immutable
(define x (cons 14 null))   ; '(14)
(define y x)
(set! x (cons 42 null))     ; '(42)
(define z (car y))          ; '(14)

; mutable - mcons  mcar  mcdr  set-mcar!  set-mcdr!
(define mpr (mcons 1 (mcons #t "hi")))
(set-mcdr! (mcdr mpr) "bye")
(define bye (mcdr (mcdr mpr)))
