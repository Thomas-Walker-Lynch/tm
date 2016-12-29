#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; initialize a tape machine of the specified class to hold the specified instances
;;
;;  init-list is a keyword list.  
;;
  (defgeneric init (instance init-value &optional cont-ok cont-fail &rest ⋯))

  (defmethod init 
    (
      (tm tape-machine)
      init-value
      &optional
      (cont-ok #'echo)
      (cont-fail (λ()(error 'bad-init-value)))
      &rest ⋯
      )
    (declare (ignore ⋯ cont-ok))
    (funcall cont-fail)
    )

  (defun mk
    (
      tm-class
      init-value
      &optional
      (cont-ok #'echo)
      (cont-fail (λ()(error 'bad-init-value)))
      (cont-no-alloc #'alloc-fail))
    (declare (ignore cont-no-alloc)) ; need to fix this
    (let(
          (instance (make-instance tm-class))
          )
      (init instance init-value cont-ok cont-fail)
      ))


