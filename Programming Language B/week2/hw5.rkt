;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

; a)
(define (racketlist->mupllist rl)
  (if (null? rl)
      (aunit)
      (apair (car rl) (racketlist->mupllist (cdr rl)))    
  )
)

; b)
(define (mupllist->racketlist ml)
  (if (aunit? ml)
      null
      (cons
        (apair-e1 ml)
        (mupllist->racketlist (apair-e2 ml))
      )
  )
)

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(int? e) e]
        [(closure? e) e]
        [(fun? e)
          (closure env e)
        ]
        [(ifgreater? e)
          (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
                [v2 (eval-under-env (ifgreater-e2 e) env)])
            (if (and (int? v1) (int? v2))
              (if (> (int-num v1) (int-num v2))
                (eval-under-env (ifgreater-e3 e) env)
                (eval-under-env (ifgreater-e4 e) env)
              )
              (error "MUPL ifgreater applied to non-number")
            )
          )
        ]
        [(mlet? e)
          (eval-under-env
            (mlet-body e)
            (cons
              (cons
                (mlet-var e)
                (eval-under-env 
                  (mlet-e e)
                  env
                )
              )
              env
            )
          )
        ]
        [(call? e)
          (let ([v1 (eval-under-env (call-funexp e) env)]
                [v2 (eval-under-env (call-actual e) env)])
            (if (closure? v1)
              (let ([c-fun (closure-fun v1)]
                    [c-env (closure-env v1)])
                (eval-under-env
                  (fun-body c-fun)
                  (if (fun-nameopt c-fun)
                    (cons 
                      (cons (fun-nameopt c-fun) v1)
                      (cons
                        (cons (fun-formal c-fun) v2)
                        c-env
                      )
                    )
                    (cons
                      (cons (fun-formal c-fun) v2)
                      c-env
                    )
                  )
                )
              )
            (error "MUPL call applied to non-closure")
            )
          )
        ]
        [(apair? e)
          (apair
            (eval-under-env (apair-e1 e) env)
            (eval-under-env (apair-e2 e) env)  
          )
        ]
        [(fst? e)
          (let ([val (eval-under-env (fst-e e) env)])
            (if (apair? val)
              (apair-e1 val)
              (error "MUPL fst applied to non-pair")
            )
          )
        ]
        [(snd? e)
          (let ([val (eval-under-env (snd-e e) env)])
            (if (apair? val)
              (apair-e2 val)
              (error "MUPL snd applied to non-pair")
            )
          )
        ]
        [(isaunit? e)
          (if (aunit? (eval-under-env (isaunit-e e) env))
            (int 1)
            (int 0)
          )
        ]
        [(aunit? e)
          (aunit)
        ]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        