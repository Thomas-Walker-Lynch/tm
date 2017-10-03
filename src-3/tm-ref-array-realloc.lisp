#|
Copyright (c) 2017 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

add clean
have these use tm and quantifiers, the tape array can be passed to mk in a box to bind
it to a machine

|#

;;--------------------------------------------------------------------------------
;; copy
;;
  (def-function-class entangle (tm &optional ➜))

  (defun-typed entangle ((tm tm-ref-array-realloc) &optional ➜)
    (destructuring-bind
      (
        &key
        (➜ok #'echo)
        &allow-other-keys
        )
      ➜
      (let(
            (chasis (chasis tm))
            (new-tm (make-instance 'tm-ref-array-realloc))
            )
        (setf (head new-tm) (head tm))
        (a◨<tape-ref-array-realloc> (tms chasis) (tg:make-weak-pointer new-tm))
        [➜ok tm]
        )))

  (def-function-class fork (tm &optional ➜))
  (defun-typed fork ((tm tm-ref-array-realloc) &optional ➜)
    (destructuring-bind
      (
        &key
        (➜ok #'echo)
        &allow-other-keys
        )
      ➜
      (let(
            (tape (tape (chasis tm)))
            (new-tape ∅)
            )
        (let(
              (i (max<tape-ref-array-realloc> tape))
              )
          (⟳(λ(➜again) ; important to write max address first, so that the new-tape doesn't repeatedly expand
              (w<tape-ref-array-realloc> new-tape (r<tape-ref-array-realloc> tape {:address i}))
              (when (> i 0)
                (decf i)
                [➜again]
                ))))
        (let(
              (new-chasis (make-instance 'chasis))
              (new-tm (make-instance 'tm))
              )
          (setf (tape new-chasis) new-tape)
          (setf (chasis new-tm) new-chasis)
          (setf (head new-tm) (head tm))
          (a◨<tape-ref-array-realloc> (tms new-chasis) (tg:make-weak-pointer new-tm))
          ))
      [➜ok tm]
      ))

