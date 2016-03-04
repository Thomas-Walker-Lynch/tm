#|
  Copyright (C) 2014 Reasoning Technology  All Rights Reserved.
  COMPANY CONFIDENTIAL Reaosning Technology
  author: thomas w. lynch

  This machine takes as initial values a tape machine and two functions, a forward
  transform and a reverse transform.

  When #'r is called, the init tape is read, the returned object is given to the forward
  transform, and the result is returned as the object read.

  When #'w is called, the object provided is given to the reverse-transform, and the result
  is written to the init tape.

  Provided that implementations are well behaved and use read and write to read from fill,
  and to write to spill, the transforms work when spilling and filling also.

  The forward or reverse transforms may be replaced with #'echo, to turn off the
  transform, or with (λ()(error 'tm-read-only)) (λ()(error 'tm-write-only)) to make the
  machine read or write only.  A write only machine may be useful, because the init tm can
  still be read.

|#


(in-package #:le)

;;--------------------------------------------------------------------------------
;; a specialization
;;
  (defclass tm-transform (tape-machine)())

  (defstruct transform
    forward
    reverse
    tm
    )

  (defun mk-tm-transform (&optional init (cont-ok #'echo) cont-fail)
    (declare (ignore cont-fail))
    (let(
          (tm (make-instance 'tm-transform))
          )
      (if
        init
        (progn
          (Unless 
            (typep init 'transform) 
            (error 'tm-mk-bad-init-type :text "expected a transform struct")
            )
          (setf (tape tm) init)
          )
        (error 'tm-mk-bad-init-type :text "tm-transform must be initialized")
        )
      (funcall cont-ok tm)
      ))

  (mk-tm-hook 'tm-transform #'mk-tm-transform)

;;--------------------------------------------------------------------------------
;; essential methods
;;
  (defmethod r ((tm tm-transform)) 
    (funcall (transform-forward (tape tm)) tm)
    )

  (defmethod w ((tm tm-transform) object)
    (funcall (transform-reverse (tape tm)) tm object)
    )
 
  ;; already on leftmost
  (defmethod cue-leftmost  ((tm tm-transform)) 
    (cue-leftmost (transform-tm (tape tm)))
    )

  (defun tms-on-same-cell-transform-0 (tm0 tm1 cont-true cont-false)
    (tms-on-same-cell-transform-0 
      (transform-tm (tape tm0))
      (transform-tm (tape tm1))
      cont-true
      cont-false
      ))

  (defmethod tms-on-same-cell 
    (
      (tm0 tm-transform) 
      (tm1 tape-machine) 
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      ) 
    (tms-on-same-cell-transform-0 tm0 tm1 cont-true cont-false)
    )

  (defmethod tms-on-same-cell 
    (
      (tm0 tape-machine) 
      (tm1 tm-transform) 
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      ) 
    (tms-on-same-cell-transform-0 tm0 tm1 cont-true cont-false)
    )

  (defmethod s
    (
      (tm tm-transform)
      &optional
      (cont-ok (be t))
      (cont-rightmost (be ∅))
      )
    (s (transform-tm (tape tm)) cont-ok cont-rightmost)
    )

  ;; allocate a cell .. but can't
  (defmethod a
    (
      (tm tm-transform)
      object
      &optional
      (cont-ok (be t))
      (cont-no-alloc (λ()(error 'tm-alloc-fail)))
      )
    (a (transform-tm (tape tm)) object cont-ok cont-rightmost)
    )

  (defmethod -a◧-s
    (
      (tm tm-transform)
      object
      &optional
      (cont-ok (be t))
      (cont-no-alloc (λ()(error 'tm-alloc-fail)))
      )
    (-a◧-s (transform-tm (tape tm)) object cont-ok cont-rightmost)
    )

  
  ;; there is no where to get a free cell of the correct type to 
  ;; call this routine with.
  ;; 
  (defmethod g
    (
      (tm tm-transform) 
      cell-reference
      &optional
      (cont-ok (be t))
      (cont-no-alloc
        (λ()(error 'tm-alloc-fail :text "could not move, could not allocate new")))
      )
    (g (transform-tm (tape tm)) cell-reference cont-ok cont-rightmost)
    )

  (defmethod d 
    (
      (tm tm-transform)
      &optional 
      spill
      (cont-ok (be t))
      (cont-rightmost (λ()(error 'tm-deallocation-request-at-rightmost)))
      (cont-no-alloc 
        (λ()(error 'tm-alloc-fail :text "could not spill")))
      )
    (d (transform-tm (tape tm)) spill cont-ok cont-rightmost cont-no-alloc)
    )

  (defmethod ◧d 
    (
      (tm tm-transform)
      &optional 
      spill
      (cont-ok (be t))
      (cont-rightmost (λ()(error 'tm-deallocation-request-at-rightmost)))
      (cont-no-alloc
        (λ()(error 'tm-alloc-fail :text "could not spill")))
      )
    (◧d (transform-tm (tape tm)) spill cont-ok cont-rightmost)
    )

  ;; current value moved off rightmost, new value fills in.
  ;; fill is one before cell to be read from
  (defmethod m 
    (
      (tm tm-transform)
      fill
      &optional
      (cont-ok (be t))
      (cont-rightmost (be ∅)) ; rightmost of fill
      )
    (m (transform-tm (tape tm)) fill cont-ok cont-rightmost)
    )
