#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  These routines specialize the tm-derived functions.  They are intended to be faster
  while producing the exact same results.  Hence, commenting out any one of these
  routines should not have any logically verifiable effect on the program.


|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; accessing data
;;

;;--------------------------------------------------------------------------------
;; absolute head placement
;;

;;--------------------------------------------------------------------------------
;;  head location predicates
;;

  (defmethod on-rightmost
    (
      (tm0 tm-list)
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      )
    (if
      (cdr (HA tm0))
      (funcall cont-false)
      (funcall cont-true)
      ))

  (defmethod on-leftmost
    (
      (tm0 tm-list)
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      )
    (if
      (eq (cdr (tape tm0)) (cdr (HA tm0)))
      (funcall cont-true)
      (funcall cont-false)
      ))

;;--------------------------------------------------------------------------------
;; head stepping
;;


;;--------------------------------------------------------------------------------
;; deallocating cells
;;




        
