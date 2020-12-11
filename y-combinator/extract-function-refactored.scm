;; Trying to use lambda as soon as possible

;; 1 - a recursive factorial
(define zero
  (lambda (n)
    (= n 0)))

(define decr
  (lambda (n)
    (- n 1)))

(define factorial
  (lambda (n)
    (if (zero? n)
        1
        (* n (factorial (decr n))))))

(display 1)(display ":")
(display (factorial 5))(newline)


;; 2 - inject a continuation into factorial

(define part-factorial
  (lambda (self n)
    (if (zero? n)
        1
        (* n (self self (decr n))))))

(define factorial
  (lambda (n)
    (part-factorial part-factorial n)))

(display "1b")(display ":")
(display (factorial 5))(newline)


;; 3 - extract Y
(define part-factorial
  (lambda (self n)
    (if (zero? n)
        1
        (* n (self self (decr n))))))

(define Y
  (lambda (f)
    (lambda (n)
      (f f n))))

(define factorial
  (Y part-factorial))

(display 3)(display ":")
(display (factorial 5))(newline)

; 4 - pull n down in part-factorial
; The goal is to transform part-factorial so that it gets back to its
; original form (without the self self)

(define part-factorial
  (lambda (self)
    (lambda (n)
      (if (zero? n)
          1
          (* n ((self self) (decr n)))))))

(define Y
  (lambda (f)
    (lambda (n)
      ((f f) n))))

(define factorial (Y part-factorial))

(display 4)(display ":")
(display (factorial 5))(newline)

;; 5 - Y to point-free style. Remove reference to n
(define part-factorial
  (lambda (self)
    (lambda (n)
      (if (zero? n)
          1
          (* n ((self self) (decr n)))))))

(define Y
  (lambda (f)
    (f f)))

(define factorial (Y part-factorial))

(display "5")(display ":")
(display (factorial 5))(newline)


;; 6 - self self as a let
(define part-factorial
  (lambda (self)
    (let ((f (lambda (x) ((self self) x))))
      (lambda (n)
        (if (zero? n)
            1
            (* n (f (decr n))))))))

(define Y
  (lambda (f)
    (f f)))

(define factorial (Y part-factorial))

(display 6)(display ":")
(display (factorial 5))(newline)

;; 7 - from let to lambda
(define part-factorial
  (lambda (self)
    ((lambda (f)                        ;; \
       (lambda (n)                      ;; |
         (if (zero? n)                  ;; |  almost-factorial
             1                          ;; |
             (* n (f (decr n))))))      ;; /
     (lambda (x) ((self self) x)))))

(define Y
  (lambda (f)
    (f f)))

(define factorial (Y part-factorial))

(display 7)(display ":")
(display (factorial 5))(newline)



;; 8 - extract domain part
(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define part-factorial
  (lambda (self)
    (almost-factorial
     (lambda (x) ((self self) x)))))

(define Y
  (lambda (f)
    (f f)))

(define factorial
  (Y part-factorial))

(display "8")(display ":")
(display (factorial 5))(newline)


;; 9 - extract almost-factorial out from part-factorial
(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define part-factorial
  (lambda (f)
    (lambda (self)
      (f (lambda (x) ((self self) x))))))

(define Y
  (lambda (f)
    (let ((x (part-factorial f)))
      (x x))))

(define factorial
  (Y almost-factorial))

(display 9)(display ":")
(display (factorial 5))(newline)


;; 10 - from let to lambda

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define part-factorial
  (lambda (f)
    (lambda (self)
      (f (lambda (x) ((self self) x))))))

(define Y
  (lambda (f)
    ((lambda (x)
       (x x))
     (part-factorial f))))

(define factorial
  (Y almost-factorial))

(display 10)(display ":")
(display (factorial 5))(newline)


;; 11 - inline part-factorial



(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define part-factorial
  (lambda (f)
    (lambda (self)
      (f (lambda (x) ((self self) x))))))

(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y almost-factorial))

(display 11)(display ":")
(display (factorial 5))(newline)



;; goal
(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y almost-factorial))

(display 12)(display ":")
(display (factorial 5))(newline)
