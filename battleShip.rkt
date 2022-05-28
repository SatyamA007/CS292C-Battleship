; Battleship is a find-the-fleet puzzle based on a grid representing an ocean section with a fleet of ships hidden inside. 
; The goal is to reveal the fleet by logically deducing the location of ship segment. 
; More information:
; http://www.conceptispuzzles.com/index.aspx?uri=puzzle/battleships/techniques

; By - Satyam Awasthi
; CS292C, Spring 22

#lang rosette

(require rosette/lib/angelic)

(include "samplePuzzles.rkt")
(include "parser.rkt")

;; Maximum number used is around max(width, height) + max ship size
;; For a 10x10 grid with ships of up to size 4, a bitwidth of 5 would
;; suffice (not bitwidth 4 because negative numbers)
;; Make it 10 to be safe
(current-bitwidth 10)


;; Global variables
(define row-sum-puzzle (box cpc-row-sum))
(define col-sum-puzzle (box cpc-col-sum))
(define ships-puzzle (box '(4 3 3 2 2 2 1 1 1 1)))
(define constraints-puzzle (box '()))

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

;;;;;;;;;;;;;;;;
;; Puzzle ADT ;;
;;;;;;;;;;;;;;;;

(struct puzzle (height width row-sums col-sums ships matrix) #:transparent)

(define (make-puzzle ships row-sums col-sums)
  (let* ([h (length row-sums)]
         [w (length col-sums)]
         [matrix
          (for/vector ([y h])
            (for/vector ([x w])
              (ormap (lambda (s) (in-ship? s x y)) ships)))])
    (puzzle h w row-sums col-sums ships matrix)))

(define (make-symbolic-puzzle row-sums col-sums)
  (make-puzzle
   (map (lambda (size)
          (make-symbolic-ship size (length row-sums) (length col-sums)))
        ships-puzzle);; conventionally 1 battleship, 2 cruisers, 3 destroyers, 4 submarines
   row-sums col-sums))

(define (ref puzzle x y [default #f])
  (if (or (< x 0) (>= x (puzzle-width puzzle))
          (< y 0) (>= y (puzzle-height puzzle)))
      default
      ;; We could also get rid of the matrix entirely, and instead
      ;; every time we use ref we would run:
      #;(ormap (lambda (s) (in-ship? s x y)) (puzzle-ships puzzle))
      (vector-ref (vector-ref (puzzle-matrix puzzle) y) x)))

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
  (printf "   ~%"))

;;;;;;;;;;;;;;;;;
;; Constraints ;;
;;;;;;;;;;;;;;;;;

;; All submarines are surrounded by water
(define (isolation-constraints puzzle)
  (for/all ([ships (puzzle-ships puzzle)])
    (for ([s ships])
      (match s
        [(ship ssize sx sy svertical?)
         (if svertical?
             (begin
               ;; Water at the ends
               (assert (not (ref puzzle sx (- sy 1) #f)))
               (assert (not (ref puzzle sx (+ sy ssize) #f)))
               ;; Water on the sides, including diagonally
               (for ([y (range -1 (+ ssize 1))])
                 (assert (not (ref puzzle (+ sx 1) (+ y sy) #f)))
                 (assert (not (ref puzzle (- sx 1) (+ y sy) #f)))))
             (begin
               ;; Water at the ends
               (assert (not (ref puzzle (- sx 1) sy #f)))
               (assert (not (ref puzzle (+ sx ssize) sy #f)))
               ;; Water on the sides, including diagonally
               (for ([x (range -1 (+ ssize 1))])
                 (assert (not (ref puzzle (+ sx x) (+ sy 1) #f)))
                 (assert (not (ref puzzle (+ sx x) (- sy 1) #f))))))]))))

(define (sum lst)
  (foldl + 0 lst))

;; Column sums
(define (assert-col-sum puzzle x result)
  (assert (= (sum (map (lambda (y) (if (ref puzzle x y) 1 0))
                       (range (puzzle-height puzzle))))
             result)))

;; Row sums
(define (assert-row-sum puzzle y result)
  (assert (= (sum (map (lambda (x) (if (ref puzzle x y) 1 0))
                       (range (puzzle-width puzzle))))
             result)))

(define (all-constraints puzzle init-fn)
  ;; Constraints based on given submarine and water locations
  (init-fn puzzle)
  ;; Constraints based on subs being separated
  (isolation-constraints puzzle)
  ;; Constraints based on row and column sums
  (for-each (curry assert-col-sum puzzle)
            (range (puzzle-width puzzle))
            (puzzle-col-sums puzzle))
  (for-each (curry assert-row-sum puzzle)
            (range (puzzle-height puzzle))
            (puzzle-row-sums puzzle)))

(define (solve-puzzle #:init-fn fn #:row-sums row-sums #:column-sums col-sums)
  (define puzzle (make-symbolic-puzzle row-sums col-sums))
  (all-constraints puzzle fn)
  (define synth (time (solve (void))))
  (evaluate puzzle synth))


(define (solve-and-print-puzzle #:init-fn fn
                                #:row-sums row-sums #:column-sums col-sums)
  (define puzzle-soln
    (solve-puzzle #:init-fn fn #:row-sums row-sums #:column-sums col-sums))

  (printf "Place ships as follows: ~a~%~%" (puzzle-ships puzzle-soln));concretized puzzle, puzzle-soln has each symbolic constant replaced by a constant c that solves the constraints 
  (print-puzzle puzzle-soln))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Solving the puzzle ;;
;;;;;;;;;;;;;;;;;;;;;;;;
;; Read and set global values from file
(readMap "puzzle-generator/medium/10x10_1.2.3.4.txt" row-sum-puzzle col-sum-puzzle ships-puzzle constraints-puzzle)
(set! ships-puzzle (unbox ships-puzzle))
(set! row-sum-puzzle (unbox row-sum-puzzle))
(set! col-sum-puzzle (unbox col-sum-puzzle))
(set! constraints-puzzle (unbox constraints-puzzle))

;; Initial constraints supplied from the file
(define (init-constraints puzzle)
  (for ([i constraints-puzzle])
    
    (assert (eq? (ref puzzle (list-ref i 0) (list-ref i 1)) (list-ref i 2)))

  ))

;; Solve and print the puzzle using angelic non-determinism 
(solve-and-print-puzzle #:init-fn init-constraints
                        #:row-sums row-sum-puzzle
                        #:column-sums col-sum-puzzle)
                       