#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  A new tape machine may be made by calling tm-mk.

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; tape machine states
;;
  (defparam void (make-instance 'void))
  (defparam parked (make-instance 'parked))
  (defparam active (make-instance 'active))

;;--------------------------------------------------------------------------------
;; print machine
;;
   (defun indent (n) 
     (dotimes (i n)(princ "  "))
     )

   (defun print-machine-0 (tm &optional (n 0))
     (indent n) (princ tm) (nl)
     (indent n) (princ "state: " (princ (type-of (state tm))))(nl)
     (indent n) (princ "HA: ") (princ (HA tm)) (nl)
     (indent n) (princ "tape: ") (princ (tape tm)) (nl)
     (indent n) (princ "parameters: ") (princ (parameters tm)) (nl)
     )

   (defun print-machine (tm &optional (n 0))
     (print-machine-0 n)
     (indent n) (princ "entanglements:") (nl)
     (let(
           (es (entanglements tm))
           )
       (when es
         (cue-leftmost es))
         (⟳(λ(cont-loop cont-return)
             (if 
               (eq (r es) tm)
               (progn (indent (1+ n)) (princ "#self")(nl))
               (print-machine-0 (r es) (1+ n))
               )
             (s es cont-loop cont-return)
             ))))

;;--------------------------------------------------------------------------------
;; initialize a tape machine of the specified type to hold the specified objects
;;
;;  init-list is a keyword list.  
;;
;;  :tm-type is used by empty to know the tape of tape to create should cells be
;;    added to the empty.
;;
;;  :mount is used to specify initial objects for a tape machine.  
;;
;;  :seed is used to give seed parameters to generators.
;;
;;  :base provides the base machine for a transforms.
;;
;;  :rightmost marks the rightmost cell for regions
;;
;;  Other keywords should not override these, as they are used in the init
;;  routines to detect valid initialization expressions.
;;
  (defgeneric init (instance init-list &optional cont-ok cont-fail))

  (defmethod init 
    (
      instance 
      init-list
      &optional 
      (cont-ok (be t))
      (cont-fail (λ() (error 'unrecognized-instance-type)))
      )
    (declare (ignore instance init-list cont-ok))
    (funcall cont-fail)
    )

  (defun mk (tm-type &rest init-list)
    (let(
          (instance (make-instance tm-type))
          )
      (init instance init-list)
      instance
      ))

;;--------------------------------------------------------------------------------
;;  given a sequence return a tape machine over that sequence
;;    sequences are things we can step into, and that tree traversal will
;;    consider to be something to traverse.
;;
;;  note that tm-derived provides a generic mount for mounting a 
;;  tape machine to a tape machine, which is similar to dup, except the
;;  head goes to leftmost
;;
  (defgeneric mount (sequence &optional cont-ok cont-fail))

  (defmethod mount
    (
      sequence 
      &optional 
      (cont-ok #'echo)
      (cont-fail (λ()(error 'mount-unrecognized-sequence-type)))
      )
    (declare (ignore sequence cont-ok))
    (funcall cont-fail)
    )

