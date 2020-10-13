(declare-datatypes () ((Num _1 _2 _3 _4 _5)))
(define-sort RowN () (Array Num Num))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(define-const min Num _1)
(define-const max Num _5)

(declare-fun succ (Num) Num)
(declare-fun pred (Num) Num)

(assert (= (succ _1) _2))
(assert (= (succ _2) _3))
(assert (= (succ _3) _4))
(assert (= (succ _4) _5))

(assert (forall ((n Num))
  (= (pred (succ n)) n)
))

(declare-const rowN RowN)

(define-fun getN ((i Num)) Num
  (select rowN i)
)

(assert (forall ((x Num) (y Num))
  (=>
    (= (getN x) (getN y))
    (= x y)
  )
))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(declare-fun between (Num Num Num) Bool)
(declare-fun has-left (Num Num) Bool)
(declare-fun has-right (Num Num) Bool)

(assert (forall ((x Num) (y Num) (z Num) (i Num))
  (=> (= (getN i) y)
    (= (between x y z) (and
      (not (= i min))
      (not (= i max))
      (or
        (and
          (has-left (pred i) x)
          (has-right (succ i) z)
        )
        (and
          (has-left (pred i) z)
          (has-right (succ i) x)
        )
      )
    ))
  )
))

(assert (forall ((i Num) (x Num))
  (= (has-left i x)
    (or
      (= (getN i) x)
      (and
        (not (= i min))
        (has-left (pred i) x)
      )
    )
  )
))

(assert (forall ((i Num) (x Num))
  (= (has-right i x)
    (or
      (= (getN i) x)
      (and
        (not (= i max))
        (has-right (succ i) x)
      )
    )
  )
))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(assert (and
  (between _2 _1 _3)
  (between _3 _4 _5)
  (between _1 _4 _5)
  (between _2 _4 _1)
  (between _5 _2 _3)
))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(assert (= (getN _1) _3))
(assert (= (getN _2) _1))
(assert (= (getN _3) _4))
(assert (= (getN _4) _2))
(assert (= (getN _5) _5))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(check-sat)