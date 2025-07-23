; This implementation simulates an interpreter using normal-order evaluation

(define (accumulate fn base lst)
  (if (null? lst)
      base
      (fn (car lst) (accumulate fn base (cdr lst)))))

(define (any-zero? exp)
  (cond ((null? exp) #f)
        ((= (calc-eval (car exp)) 0) #t)
        (else (any-zero? (cdr exp)))))

; REPL
(define (calc)
 (display "calc: ")
 (flush)
 (print (calc-eval (read)))
 (calc))

(define (calc-eval exp)
  (cond ((number? exp) exp)
        ((list? exp) (calc-apply (car exp) (cdr exp)))
        (else (error "Bad expression:" exp))))
        
(define (calc-apply fn args)
  (cond ((eq? fn '+) (accumulate (lambda (x y) (+ (calc-eval x) y)) 0 args))
        ((eq? fn '-) 
         (cond ((null? args) (error "No arguments to" fn))
               ((= (length args) 1) (- (calc-eval (car args))))
               (else 
                 (- (calc-eval (car args))
                    (accumulate (lambda (x y) (+ (calc-eval x) y)) 0 (cdr args))))))
        ((eq? fn '*) (accumulate (lambda (x y) (* (calc-eval x) y)) 1 args))
        ((eq? fn '/) 
         (cond ((null? args) (error "No arguments to" fn))
               ((= (length args) 1) (/ 1 (calc-eval (car args))))
               ((any-zero? (cdr args)) (error "No division by 0 allowed"))
               (else 
                 (/ (calc-eval (car args))
                    (accumulate (lambda (x y) (* (calc-eval x) y)) 1 (cdr args))))))
        (else (error "Bad operator:" fn))))
