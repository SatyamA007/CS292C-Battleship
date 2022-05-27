(define (readMap puzzleFile rowSum colSum shipsPuzzle constraintsPuzzle)

    (define puzzleStr 
        (file->lines "puzzle-generator/easy/10x10_1.2.3.4.txt"))
    (set-box! rowSum (map string->number (string-split (list-ref puzzleStr 0) " ")))
    (set-box! colSum (map string->number (string-split (list-ref puzzleStr 1) " ")))
    (set-box! shipsPuzzle '())
    (set-box! constraintsPuzzle '())

  (for ([ln (list-tail puzzleStr 2)])
    (set! ln (string-trim ln))
    (cond 
      [(string-prefix? ln "n:")
      (print (string->number (substring ln 3)))]
      [(string-prefix? ln "m:")
      (print (string->number (substring ln 3)))]
      [(string-prefix? ln "battleships:")
      (for  ([i (string->number (substring ln 13))])
        (set-box! shipsPuzzle (append (unbox shipsPuzzle) '(4)))
      )]
      [(string-prefix? ln "cruisers:")
      (for  ([i (string->number (substring ln 10))])
        (set-box! shipsPuzzle (append (unbox shipsPuzzle) '(3)))
      )]
      [(string-prefix? ln "destroyers:")  
      (for  ([i (string->number (substring ln 12))])
        (set-box! shipsPuzzle (append (unbox shipsPuzzle) '(2)))
      )]
      [(string-prefix? ln "submarines:")  
      (for  ([i (string->number (substring ln 12))])
        (set-box! shipsPuzzle (append (unbox shipsPuzzle) '(1)))
      )]
      [else 
      (cond 
      [(non-empty-string? ln)
      (define params (map string->number (string-split ln " ")))
      (define isShip (if (eq? (list-ref params 2) 0) #f #t))
      (set-box! constraintsPuzzle (append (unbox constraintsPuzzle) (list(list (list-ref params 0) (list-ref params 1) isShip ))))
      ])])      
  )

    ; (set! shipsPuzzle (unbox shipsPuzzle))
    ; (set! rowSum (unbox rowSum))
    ; (set! colSum (unbox colSum))

)




;(readMap "samplePuzzle" rowSum colSum shipsPuzzle constraintsPuzzle)



;(print (map path->string (directory-list "easy")))

