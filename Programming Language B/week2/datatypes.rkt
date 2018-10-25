#lang racket
(provide (all-defined-out))

; We can have a list holding a mix of datatypes (unstructured)
(define (funny-sum xs)
    (cond [(null? xs) 0]
          [(number? (car xs)) 
            (+ (car xs) (funny-sum (cdr xs)))
          ]
          [(string? (car xs)) 
            (+ (string-length (car xs)) (funny-sum (cdr xs)))
          ]
    )
)

; Structured
(struct const (int) #:transparent)
(struct negate (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct multiply (e1 e2) #:transparent)

(define (eval-exp e)
  (cond [(const? e) e]
        [(negate? e)
            (const (- (const-int (eval-exp (negate-e e)))))]
        [(add? e)
            (let ([v1 (const-int (eval-exp (add-e1 e)))]
                  [v2 (const-int (eval-exp (add-e2 e)))])
            (const (+ v1 v2)))]
        [(multiply? e) 
            (let ([v1 (const-int (eval-exp (multiply-e1 e)))]
                  [v2 (const-int (eval-exp (multiply-e2 e)))])
            (const (* v1 v2)))]
        [#t (error "eval-exp expected an exp")]
    )
)
