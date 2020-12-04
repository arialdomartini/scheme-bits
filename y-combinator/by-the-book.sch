;; Following the steps in https://mvanier.livejournal.com/2897.html

;; 1
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


;; 4 - self self as a let; this fails in strict languages

(define (part-factorial self)
  (let ((f (self self)))
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)


;; 5 - self self as a let, for languages

(define (part-factorial self)
  (let ((f (lambda (x) ((self self) x))))
    (lambda (n)
      (if (zero? n)
          1
          (* n (f (decr n)))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)
