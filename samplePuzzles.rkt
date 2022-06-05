;; Solving the example puzzle
#;(define (example-puzzle-fn puzzle)
  ;; Constraints from the ship pieces
  (assert (ref puzzle 5 2))
  (assert (or (and (ref puzzle 5 1) (ref puzzle 5 3)) ;; Vertical
              (and (ref puzzle 4 2) (ref puzzle 6 2)))) ;; Horizontal

  (assert (ref puzzle 3 5))
  (assert (ref puzzle 3 6))
  (assert (not (ref puzzle 3 4)))

  ;; Constraints from the water
  (assert (not (ref puzzle 0 0)))
  (assert (not (ref puzzle 2 8))))
#;(solve-and-print-puzzle #:init-fn example-puzzle-fn
                        #:row-sums '(2 3 5 1 1 1 1 0 1 5)
                        #:column-sums '(4 0 3 3 0 3 1 1 4 1))

;; Solution for the example puzzle
#;(define example-puzzle-soln
  (make-puzzle
   (list (ship 4 6 9 #f)
         (ship 3 5 1 #t) (ship 3 8 0 #t)
         (ship 2 2 2 #f) (ship 2 3 5 #t) (ship 2 0 1 #t)
         (ship 1 2 9 #f) (ship 1 2 0 #f) (ship 1 0 8 #t) (ship 1 0 4 #t))
   '(2 3 5 1 1 1 1 0 1 5)
   '(4 0 3 3 0 3 1 1 4 1)))

#;(all-constraints example-puzzle-soln (const #t))


  
;; Example puzzle from Microsoft College Puzzle Challenge 2017, Sea Shanties
(define (cpc-puzzle-fn puzzle)
  ;; Constraints from the ship piece
  (assert (not (ref puzzle 1 2)))
  (assert (ref puzzle 2 2))
  (assert (ref puzzle 3 2))
  (assert (ref puzzle 4 2))

  ;; Constraints from the water
  (assert (not (ref puzzle 0 8))))

(define cpc-row-sum '(2 1 3 2 4 3 1 2 1 1))
(define cpc-col-sum '(2 0 1 2 3 4 2 3 1 2))
