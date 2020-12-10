;; Following the steps in https://mvanier.livejournal.com/2897.html

;; 1 - a recursive factorial
(define (zero? n)
  (= n 0))
(define (decr n)
  (- n 1))

(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (decr n)))))

(display (factorial 5))(newline)


;; 2 - inject self
(define (part-factorial self n)
  (if (zero? n)
      1
      (* n (self self (decr n)))))

(define (factorial n)
  (part-factorial part-factorial n))

(display (factorial 5))(newline)


;; 3 - pull n down

(define (part-factorial self)
  (lambda (n)
    (if (zero? n)
        1
        (* n ((self self) (decr n))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 4 - self self as a let; this only works with lazy languages;
;; It would fail in strict languages

(define (part-factorial self)
  (let ((f (self self)))
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 4 - self self as a let, for strict languages

(define (part-factorial self)
  (let ((f (lambda (x) ((self self) x))))
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 5 - from let to lambda

(define (part-factorial self)
  ((lambda (f)
     (lambda (n)
       (if (zero? n)
           1
           (* n (f (decr n))))))
   (lambda (x) ((self self) x))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 6 - extract domain part

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define (part-factorial self)
  (almost-factorial
   (lambda (x) ((self self) x))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 7 - pull self down

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

(define factorial
  (lambda (n)
    ((part-factorial part-factorial) n)))

(display (factorial 5))(newline)

;; 8 - in factorial, extract part-factorial part-factorial as a let expression

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define factorial
    (let ((part-factorial
           (lambda (self) (almost-factorial (lambda (x) ((self self) x))))))
      (part-factorial part-factorial)))

(display 8)(display ":")
(display (factorial 5))(newline)

;; 9 - x instead of part-factorial

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define factorial
    (let ((x
           (lambda (self) (almost-factorial (lambda (y) ((self self) y))))))
      (x x)))

(display 9)(display ":")
(display (factorial 5))(newline)


;; 10 - from let to lambda

(define almost-factorial
  (lambda (f)
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define factorial
    ((lambda (x) (x x))
           (lambda (self) (almost-factorial (lambda (y) ((self self) y))))))


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
    ((lambda (x) (x x))
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

(define factorial (Y almost-factorial))

(display 12)(display ":")
(display (factorial 5))(newline)
