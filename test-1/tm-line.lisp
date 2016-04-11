#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  Quantification

|#

(in-package #:tm)

(defun test-tm-line-0 ()
  (let(
        (tm-src (mk 'tm-line 0 5))
        (tm-dst (mk 'tm-list))
        )
    (⟳ (λ(cont-loop cont-return)
         (as tm-dst (r tm-src))
         (s tm-src cont-loop cont-return)
         ))
    (equal
      (cdr (to-list tm-dst))
      [0 1 2 3 4 5]
      )
    ))
(test-hook test-tm-line-0)

(defun test-tm-line-1 ()
  (let(
        (m 9)
        (tm-src (mk 'tm-line 1 20 2))
        (tm-dst (mk 'tm-list))
        )
    (⟳ (λ(cont-loop cont-return)
         (let((x (r tm-src)))
           (let((y (+ (/ (1- (expt x 2)) 2) (* m x))))
             (as tm-dst y)
             (s tm-src cont-loop cont-return)
             ))))
    (equal
      (cdr (to-list tm-dst))
      [9 31 57 87 121 159 201 247 297 351]
      )))
(test-hook test-tm-line-1)
