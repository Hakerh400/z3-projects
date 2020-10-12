(define-const size Int 6)

(declare-fun get-num (Int Int) Int)
(declare-fun marked (Int Int) Bool)

(define-fun getn ((x Int) (y Int) (val Int)) Bool
  (= (get-num x y) val)
)

(define-fun getm ((x Int) (y Int)) Int
  (ite (marked x y) (get-num x y) 0)
)

(assert (and
  (getn 1 1 1) (getn 2 1 3) (getn 3 1 5) (getn 4 1 2) (getn 5 1 9) (getn 6 1 7)
  (getn 1 2 8) (getn 2 2 3) (getn 3 2 2) (getn 4 2 7) (getn 5 2 6) (getn 6 2 8)
  (getn 1 3 1) (getn 2 3 3) (getn 3 3 2) (getn 4 3 7) (getn 5 3 9) (getn 6 3 5)
  (getn 1 4 7) (getn 2 4 4) (getn 3 4 8) (getn 4 4 8) (getn 5 4 8) (getn 6 4 1)
  (getn 1 5 4) (getn 2 5 4) (getn 3 5 4) (getn 4 5 1) (getn 5 5 1) (getn 6 5 5)
  (getn 1 6 3) (getn 2 6 6) (getn 3 6 3) (getn 4 6 2) (getn 5 6 5) (getn 6 6 9)
))

(define-fun check ((i Int)) Bool
  (and (>= i 1) (<= i size))
)

(define-fun check ((x Int) (y Int)) Bool
  (and (check x) (check y))
)

(define-fun check-row ((i Int)) Bool
  (<= (+ (getm 1 i) (getm 2 i) (getm 3 i) (getm 4 i) (getm 5 i) (getm 6 i)) 9)
)

(define-fun check-col ((i Int)) Bool
  (<= (+ (getm i 1) (getm i 2) (getm i 3) (getm i 4) (getm i 5) (getm i 6)) 9)
)

(define-fun check-row-and-col ((i Int)) Bool
  (and
    (check-row i)
    (check-col i)
  )
)

(assert (and
  (check-row-and-col 1) (check-row-and-col 2) (check-row-and-col 3)
  (check-row-and-col 4) (check-row-and-col 5) (check-row-and-col 6)
))

(define-fun check-num ((i Int)) Bool
  (exists ((x Int) (y Int))
    (and
      (check x y)
      (marked x y)
      (getn x y i)
      (not (exists ((x1 Int) (y1 Int))
        (and
          (check x1 y1)
          (not (and (= x x1) (= y y1)))
          (marked x1 y1)
          (getn x1 y1 i)
        )
      ))
    )
  )
)

(assert (and
  (check-num 1) (check-num 2) (check-num 3)
  (check-num 4) (check-num 5) (check-num 6)
  (check-num 7) (check-num 8) (check-num 9)
))

(assert (marked 3 6))

(check-sat)