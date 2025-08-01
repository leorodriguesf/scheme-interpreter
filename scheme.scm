; This implementation simulates an interpreter using applicative-order evaluation

(define (accumulate fn base lst)
  (if (null? lst)
      base
      (fn (car lst) (accumulate fn base (cdr lst)))))

(define (any-zero? lst)
  (cond ((null? lst) #f)
        ((= (car lst) 0) #t)
        (else (any-zero? (cdr lst)))))

; REPL
(define (calc)
 (display "calc: ")
 (flush)
 (print (calc-eval (read)))
 (calc))

(define (calc-eval exp)
  (cond ((number? exp) exp)
        ; Mutual recursion 
        ((list? exp) (calc-apply (car exp) (map calc-eval (cdr exp))))
        (else (error "Bad expression:" exp))))
        
(define (calc-apply fn args)
  (cond ((eq? fn '+) (accumulate + 0 args))
        ((eq? fn '-) (cond ((null? args) (error "No arguments to" fn))
                           ((= (length args) 1) (- (car args)))
                           (else (- (car args) (accumulate + 0 (cdr args))))))
        ((eq? fn '*) (accumulate * 1 args))
        ((eq? fn '/) (cond ((null? args) (error "No arguments to" fn))
                           ((= (length args) 1) (/ 1 (car args)))
                           ((any-zero? (cdr args)) (error "No division by 0 allowed"))
                           (else (/ (car args) (accumulate * 1 (cdr args))))))
        (else (error "Bad operator:" fn))))
