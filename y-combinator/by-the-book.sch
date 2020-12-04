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
