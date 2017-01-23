#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

The entanglements slot for ea-tm holds a list-solo-tm.

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; copying
;;  
  ;; more specialized than one found in nd-tm-derived.lisp
  (defun-typed with-mk-entangled
    (
      (tm0 ea-tape-machine)
      continuation
      &rest ⋯
      )
    (declare (ignore ⋯))
    (let(
          (tm1 (mk (type-of tm0) tm0))
          )
      (unwind-protect
        (funcall continuation tm1)
        (self-disentangle tm1)
        )))

;;--------------------------------------------------------------------------------
;; adding and removing from the list
;;
  (defun self-disentangle (tm)
    "Removes tm from its own entanglement list.  This is typically done before 
    tm is abandoned.
    "
    (let(
          (es (entanglements tm))
          )
      (∧
        es
        (progn
          (cue-leftmost es)
          (if 
            (eq (r es) tm) ; first cell has tm in it
            (s es
              (λ()(d◧ es ∅ #'do-nothing #'cant-happen #'cant-happen))
              (setf (entanglements tm) ∅)
              )
            (∃ es
              (λ(es ct c∅)
                (esr es
                  (λ(instance) ; cont-ok
                    (if 
                      (eq instance tm)
                      (d es ∅ (λ(x)(declare (ignore x)) [ct]) #'cant-happen)
                      [c∅]
                      ))
                  c∅ ; no cell one to the right (cont-rightmost)
                  ))))))))


;;--------------------------------------------------------------------------------
;; detecting a collision
;;
  (defun collide (tm0 tm1 &optional (cont-true (be t)) (cont-false (be ∅)))
    "tm0 and tm1 are distinct machines, and have their heads on the same cell."
    (if
      (eq tm0 tm1)
      [cont-false]
      (heads-on-same-cell tm0 tm1 cont-true cont-false)
      ))

  (defun ∃-collision (tm &optional (cont-true (be t)) (cont-false (be ∅)))
    "tm collides with an entangled machine."
    (let(
          (es (entanglements tm))
          )
      (if es
        (progn
          (cue-leftmost es)
          (∃ es 
            (λ(es ct c∅)
              (if
                (eq (r es) tm)
                [c∅]
                (heads-on-same-cell (r es) tm ct c∅)
                ))
            cont-true
            cont-false
            ))
        [cont-false]
        )))

  (defun ∃-collision-right-neighbor (tm &optional (cont-true (be t)) (cont-false (be ∅)))
    "There exists in the entanglement list, a machine that has its head on
     tm's right neighbor.
    "
      (with-mk-entangled tm
        (λ(tms1)
          (s tms1
            (λ()(∃-collision tms1 cont-true cont-false))
            cont-false
            ))))
              
  (defun ∃-collision◧ (tm &optional (cont-true (be t)) (cont-false (be ∅)))
    "There exists in the entanglement list, a machine that has its head on leftmost."
    (let(
          (es (entanglements tm))
          )
      (if es
        (progn
          (cue-leftmost es)
          (∃ es 
            (λ(es ct c∅)(on-leftmost (r es) ct c∅))
            cont-true
            cont-false
            ))
        [cont-false]
        )))

;;--------------------------------------------------------------------------------
;; updating the tape
;;
  (defun ∀-entanglements-update-tape (tm)
    (let(
          (es (entanglements tm))
          )
      (cue-leftmost es)
      (∀ es 
        (λ(es ct c∅)
          (declare (ignore c∅))
          (setf (tape (r es)) (tape tm))
          [ct]
          ))))
