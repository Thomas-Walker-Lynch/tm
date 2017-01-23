#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#

(in-package #:tm)


;;--------------------------------------------------------------------------------
;; accessing data
;;
  (defun-typed r ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜ok #'echo)
        )
      ➜
      [cont-ok (car (head tm))]
      ))

  (defun-typed esr ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜ok #'echo)
        (➜rightmost (λ()(error 'step-from-rightmost)))
        &allow-other-keys
        )
      ➜
      (if
        (cdr (head tm))
        [➜ok (cadr (head tm))]
        [➜rightmost]
        )))

  (defun-typed w ((tm list-tm) instance &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        &allow-other-keys
        )
      ➜
      (setf (car (head tm)) instance)
      [➜ok]
      ))

  (defun-typed esw ((tm list-tm) instance &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        (➜rightmost (be ∅))
        &allow-other-keys
        )
      ➜
      (if
        (cdr (head tm))
        (progn
          (setf (cadr (head tm)) instance)
          [➜ok]
          )
        [➜rightmost]
        )))

;;--------------------------------------------------------------------------------
;; absolute head placement
;;
  (defun-typed cue-leftmost ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        &allow-other-keys
        )
      ➜
      (setf (head tm) (tape tm))
      [➜ok]
      ))

;;--------------------------------------------------------------------------------
;; head stepping
;;
  (defun-typed s ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        (➜rightmost (be ∅))
        &allow-other-keys
        )
      ➜
      (if 
        (cdr (head tm))
        (progn
          (setf (head tm) (cdr (head tm)))
          [➜ok]
          )
        [➜rightmost]
        )))

;;--------------------------------------------------------------------------------
;; cell allocation
;;
  (defun-typed a ((tm list-tm) instance &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        &allow-other-keys
        )
      ➜
      (let(
            (next-cell (cdr (head tm)))
            )
        (rplacd (head tm) (cons instance next-cell))
        [➜ok]
        )))

;;--------------------------------------------------------------------------------
;; location
;;  
  (defun-typed on-leftmost ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜t (be t))
        (➜∅ (be ∅))
        &allow-other-keys
        )
      ➜
      (if (eq (head tm) (tape tm)) [➜t] [➜∅])
      ))

  (defun-typed on-rightmost ((tm list-tm) &optional ➜)
    (destructuring-bind
      (&key
        (➜t (be t))
        (➜∅ (be ∅))
        &allow-other-keys
        )
      ➜
      (if (¬ (cdr (head tm))) [➜t] [➜∅])
      ))
