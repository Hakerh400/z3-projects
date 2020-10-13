(declare-datatypes () ((Num _1 _2 _3 _4)))
(define-sort RowN () (Array Num Num))
(define-sort RowB () (Array Num Bool))
(define-sort GridN () (Array Num RowN))
(define-sort GridB () (Array Num RowB))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(define-const min Num _1)
(define-const max Num _4)

(declare-fun succ (Num) Num)
(declare-fun pred (Num) Num)

(assert (= (succ _1) _2))
(assert (= (succ _2) _3))
(assert (= (succ _3) _4))

(assert (forall ((n Num))
  (= (pred (succ n)) n)
))

(declare-const gridN GridN)
(declare-const gridB GridB)

(define-fun getN ((x Num) (y Num)) Num
  (select (select gridN y) x)
)

(define-fun getB ((x Num) (y Num)) Bool
  (select (select gridB y) x)
)

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

; Ssame white numbers cannot appear in the same row or column

(assert (forall ((x Num) (y Num))
  (=> (getB x y)
    (not (exists ((x1 Num) (y1 Num))
      (and
        (not (= (= x1 x) (= y1 y)))
        (getB x1 y1)
        (= (getN x y) (getN x1 y1))
      )
    ))
  )
))

; Two black numbers cannot be adjacent

(assert (forall ((x Num) (y Num))
  (=> (not (getB x y))
    (and
      (=> (not (= x min)) (getB (pred x) y))
      (=> (not (= y min)) (getB x (pred y)))
      (=> (not (= x max)) (getB (succ x) y))
      (=> (not (= y max)) (getB x (succ y)))
    )
  )
))

; All white numbers must be connected

(declare-fun remove-island (GridB Num Num) GridB)
(declare-fun overlap (GridB GridB) GridB)

(assert (forall ((grid GridB) (x Num) (y Num))
  (= (remove-island grid x y)
    (ite (getB x y)
      (overlap
        (ite (not (= x min)) (remove-island (store grid y (store (select grid y) x false)) (pred x) y) grid)
      (overlap
        (ite (not (= y min)) (remove-island (store grid y (store (select grid y) x false)) x (pred y)) grid)
      (overlap
        (ite (not (= x max)) (remove-island (store grid y (store (select grid y) x false)) (succ x) y) grid)
        (ite (not (= y max)) (remove-island (store grid y (store (select grid y) x false)) x (succ y)) grid)
      )))
      grid
    )
  )
))

(assert (forall ((a GridB) (b GridB) (c GridB))
  (= (= (overlap a b) c)
    (forall ((x Num) (y Num))
      (= (select (select c y) x)
        (and
          (select (select a y) x)
          (select (select b y) x)
        )
      )
    )
  )
))

(assert (forall ((x Num) (y Num))
  (=> (getB x y)
    (=
      (remove-island gridB x y)
      ((as const GridB) ((as const RowB) false))
    )
  )
))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(assert (and
  (= (getN _1 _1) _3) (= (getN _2 _1) _1) (= (getN _3 _1) _2) (= (getN _4 _1) _2)
  (= (getN _1 _2) _2) (= (getN _2 _2) _3) (= (getN _3 _2) _4) (= (getN _4 _2) _2)
  (= (getN _1 _3) _2) (= (getN _2 _3) _2) (= (getN _3 _3) _1) (= (getN _4 _3) _2)
  (= (getN _1 _4) _4) (= (getN _2 _4) _2) (= (getN _3 _4) _3) (= (getN _4 _4) _1)
))

(assert (getB _2 _1))

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

(check-sat)