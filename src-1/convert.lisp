#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  Make machines from other objects.
  Make other objects from machines.

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; converts a tape machine to another form
;;
  ;; return's whatever sequence type represents the space in Lisp
  (defun unmount(tm)(unmount-0 tm (state tm)))
  (defgeneric unmount-0(tm state))

  (defgeneric to-list (tm))
  (defgeneric to-array-adj (tm))

  ;; We purposely leave to-array without a generic implementation due to element
  ;; type conversion issues.  Typically a program will use a worker to copy to an
  ;; array machine, and then the prorgram will call to-array on the array machine.
  (defgeneric to-array (tm))

  ;; generic list maker, some specializations, particularly the tm-list specialization,
  ;; will be more efficient.
  (defmethod to-list ((tm0 tape-machine))
    (let(
          (tm1 (mk 'tm-list))
          )
      (⟳ (λ(cont-loop cont-return) (as tm1 (r tm0) cont-loop cont-return)))
      (tape tm1)
      ))

