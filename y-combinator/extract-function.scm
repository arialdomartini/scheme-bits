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

;; 2 - inject self
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

(display 2)(display ":")
(display (factorial 5))(newline)

;; 3 - pull n down
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

(define Y
  (lambda (f)
    (f f)))

(define factorial (Y part-factorial))

(display 3)(display ":")
(display (factorial 5))(newline)


;; 4 - self self as a let
(define part-factorial
  (lambda (self)
    (let ((f (lambda (x) ((self self) x))))
      (lambda (n)
        (if (zero? n)
            1
            (* n (f (decr n))))))))

(define Y
  (lambda (f)
    (lambda (n)
      ((f f) n))))

(define factorial (Y part-factorial))

(display 4)(display ":")
(display (factorial 5))(newline)

;; 5 - from let to lambda
(define part-factorial
  (lambda (self)
    ((lambda (f)
       (lambda (n)
         (if (zero? n)
             1
             (* n (f (decr n))))))
     (lambda (x) ((self self) x)))))

(define Y
  (lambda (f)
    (lambda (n)
      ((f f) n))))

(define Y
  (lambda (f) (f f)))

(define factorial (Y part-factorial))

(display 5)(display ":")
(display (factorial 5))(newline)

;; 6 - extract domain part

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define Y
  (lambda (f)
    (lambda (self)
      (f
       (lambda (x) ((self self )x))))))

(define factorial
  (lambda (n)
    (((Y almost-factorial)(Y almost-factorial)) n)))

(display 6)(display ":")
(display (factorial 5))(newline)

;; 7 - pull self down
;; this has been already done here!

;; 8 - in factorial, extract part-factorial part-factorial as a let expression

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define Y
  (lambda (f)
    (let ((part-factorial
           (lambda (self) (f (lambda (x) ((self self) x))))))
      (part-factorial part-factorial))))

(define factorial (Y almost-factorial))

(display 8)(display ":")
(display (factorial 5))(newline)


;; 8 - x instead of part-factorial

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define Y
  (lambda (f)
    (let ((x
           (lambda (self) (f (lambda (x) ((self self) x))))))
      (x x))))

(define factorial (Y almost-factorial))

(display 9)(display ":")
(display (factorial 5))(newline)


;; 10 - from let to lambda
(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define Y
  (lambda (f)
    ((lambda (x)
       (x x))
     (lambda (self) (f (lambda (x) ((self self) x)))))))

(define factorial (Y almost-factorial))

(display 10)(display ":")
(display (factorial 5))(newline)


;; 11 - rename self to x
(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define factorial
  ((lambda (x)
     (x x))
   (lambda (x) (almost-factorial (lambda (y) ((x x) y))))))

(display 11)(display ":")
(display (factorial 5))(newline)


;; 12 - extract almost-factorial as a lambda parameter
(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

(define factorial
  (Y almost-factorial))

(display 12)(display ":")
(display (factorial 5))(newline)
