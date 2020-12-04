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


;; inject self
(define (part-factorial self n)
  (if (zero? n)
      1
      (* n (self self (decr n)))))

(define (factorial n)
  (part-factorial part-factorial n))

(display (factorial 5))(newline)


;; pull n down

(define (part-factorial self)
  (lambda (n)
    (if (zero? n)
        1
        (* n ((self self) (decr n))))))

(define (factorial n)
  ((part-factorial part-factorial) n))

(display (factorial 5))(newline)
