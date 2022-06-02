;;;;;;;;;;;;;;
;; Ship ADT ;;
;;;;;;;;;;;;;;

(struct ship (size x y vertical?) #:transparent)

(define (in-ship? s x y)
  (match s
    [(ship ssize sx sy svertical?)
     (if svertical?
         (and (= x sx) (<= sy y (+ sy ssize -1)))
         (and (= y sy) (<= sx x (+ sx ssize -1))))]))

(define (make-symbolic-ship size mapHeight mapWidth)
  (define-symbolic* x y integer?)
  (assert (>= x 0))
  (assert (< x mapWidth))
  (assert (>= y 0))
  (assert (< y mapHeight))
  (define-symbolic* vertical? boolean?)
  (ship size x y vertical?))

;;Print the solved puzzle 

(define (print-puzzle puzzle)
  (printf "    ")
  (for ([x (puzzle-width puzzle)])
    (printf "~a~a" x (if (>= x 10) "" " ")))
  (printf "   ~%~%")

  (for ([y (puzzle-height puzzle)]
        [row-sum (puzzle-row-sums puzzle)])
    (printf "~a~a  " y (if (>= y 10) "" " "))
    (for ([x (puzzle-width puzzle)])
      (printf "~a " (if (ref puzzle x y) "S" "-")))
    (printf " ~a~a~%" (if (>= row-sum 10) "" " ") row-sum))

  ;; Display column sums on the last line
  (printf "~%    ")
  (for ([col-sum (puzzle-col-sums puzzle)])
    (printf "~a~a" col-sum (if (>= col-sum 10) "" " ")))
  (printf "   ~%~%"))


(define (ref puzzle x y [default #f])
  (if (or (< x 0) (>= x (puzzle-width puzzle))
          (< y 0) (>= y (puzzle-height puzzle)))
      default
      ;; We could also get rid of the matrix entirely, and instead
      ;; every time we use ref we would run:
      #;(ormap (lambda (s) (in-ship? s x y)) (puzzle-ships puzzle))
      (vector-ref (vector-ref (puzzle-matrix puzzle) y) x)))
