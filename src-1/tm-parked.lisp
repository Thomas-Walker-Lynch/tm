#|
  Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
  Released under the MIT License (MIT)
  See LICENSE.txt

  A parked machine keeps the operations from the base machine that operate only
  on the tape, while hiding those that require use of the head.

  To park a machine we change its type to tm-parked and overwrite the head state with the
  machine type.  We then make use of the machine type when access methods that operate on
  the tape.  The parameters and entanglements list are unchanged.

  Calling step, #'s, unparks the head. To unpark the head, we change type to the said
  type, and we call cue-leftmost.

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; a specialization
;;
  (defclass tm-parked (tape-machine)())

  (defgeneric park (tm)
    (:documentation "parks the tm")
    )

  ;; no need to do anything
  ;; don't know if any compilers will freak with an empty body, so I put t
  (defmethod park ((tm tm-void)) t)

  ;;Parks an existing machine. Any non-void machine may be parked.
  (defmethod park ((tm tape-machine))
    (setf (HA tm) (type-of tm))
    (change-class tm 'tm-parked)
    ;; tape remains unchanged
    ;; parameters remain unchanged
    ;; entanglements remains unchanged
    )

  ;; unparks the head to leftmost (not to where it was before, but to leftmost)
  ;; tm-type is a list where car is the type and rest are options
  (defun unpark (tm)
    (change-class tm (HA tm))
    (cue-leftmost tm)
    )

  ;; inits a new machine and parks it.  #'mk gives us a 'tm-parked type so we can get
  ;; here, but it is not a parked machine yet nor even a machine of any type, yet.
  ;; 'tm-type' is the type of the machine to first create and then to park.  'tm-type'
  ;; may occur more than once in the init list, we strip out and use the first occurance.
  ;; the remaining options are passed in to init the non-parked object.
  (defmethod init 
    (
      (tm tm-parked)
      init-list
      &optional 
      (cont-ok (be t))
      (cont-fail (λ()(error 'missing-tm-type)))
      )
    (destructuring-bind
      (&key tm-type &allow-other-keys) init-list
      (unless tm-type (return-from init (funcall cont-fail)))
      (change-class tm tm-type)
      (init tm (remove-key-pair init-list :tm-type)
        (λ()
          (park tm)
          (funcall cont-ok)
          )
        (λ()
          (change-class tm 'tm-parked) ; transactional behavior
          (funcall cont-fail)
          ))
      ))

  (defmethod unmount ((tm tm-parked))
    (let(
          (tm1 (dup tm))
          )
      (unpark tm1)
      (unmount tm1)
      ))


;;--------------------------------------------------------------------------------
;; primitive methods
;;
  (defmethod r ((tm tm-parked))
    (declare (ignore tm))
    (error 'parked-access)
    )

  (defmethod w ((tm tm-parked) object)
    (declare (ignore tm object))
    (error 'parked-access)
    )

  (defmethod cue-leftmost ((tm tm-parked))
    (unpark tm)
    )

  (defmethod heads-on-same-cell
    (
      (tm0 tm-parked) 
      (tm1 tm-parked) 
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      ) 
    (declare (ignore cont-false))
    (funcall cont-true)
    )

  (defmethod heads-on-same-cell
    (
      (tm0 tm-parked) 
      (tm1 tape-machine) 
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      ) 
    (declare (ignore cont-true))
    (funcall cont-false)
    )

  (defmethod heads-on-same-cell
    (
      (tm0 tape-machine) 
      (tm1 tm-parked) 
      &optional
      (cont-true (be t))
      (cont-false (be ∅))
      ) 
    (declare (ignore cont-true))
    (funcall cont-false)
    )

  ;; steps head from void space into tape space
  (defmethod s
    (
      (tm tm-parked)
      &optional
      (cont-ok (be t))
      (cont-rightmost (be ∅))
      )
    (declare (ignore cont-rightmost))
    (unpark tm)
    (funcall cont-ok)
    )

  (defmethod a◧
    (
      (tm tm-parked)
      object
      &optional
      (cont-ok (be t))
      (cont-no-alloc (λ()(error 'alloc-fail)))
      )
    (unpark tm)
    (a◧ tm object
      (λ()
        (park tm)
        (funcall cont-ok)
        )
      (λ()
        (park tm)
        (funcall cont-no-alloc)
        )))

  ;; a parked machine steps to leftmost, so the bahavior is as if
  ;; the head were the left neighbor of leftmost.
  (defmethod a
    (
      (tm tm-parked)
      object
      &optional
      (cont-ok (be t))
      (cont-no-alloc (λ()(error 'alloc-fail)))
      )
    (a◧ tm object cont-ok cont-no-alloc)
    )

  (defun d-parked
    (
      tm
      &optional 
      spill
      (cont-ok #'echo)
      (cont-rightmost (λ()(error 'dealloc-on-rightmost)))
      (cont-not-supported (λ()(error 'not-supported)))
      (cont-collision (λ()(error 'dealloc-entangled)))
      (cont-no-alloc (λ()(error 'alloc-fail)))
      )
    ;; parked machines are not void, so there will be a leftmost (never cont-rightmost)
    ;; parked machines that are singleton can always transition (to void i.e. never cont-not-supported)
    ;; parked machines don't have a head on the tape, so never cont-collision
    (declare (ignore cont-rightmost))
    (r◧ tm
      (λ(dealloc-object)
        (singleton tm
          (λ() ; singular-tape, all entangled machines share the same tape, but not same head
            (∀-void tm
              (λ()
                (when spill
                  (as spill dealloc-object 
                    #'do-nothing 
                    (λ()(return-from d-parked (funcall cont-no-alloc)))
                    ))
                (funcall cont-ok)
                )
              cont-collision ; one of the cells couldn't be deallocated, must have head on it
              ))
          (λ() ; not singular
            (let(
                  (tm1 (dup tm))
                  )
              (change-class tm1 (HA tm1))
              (d◧ tm1 cont-ok cont-not-supported cont-collision cont-no-alloc)
              ))))
      ;; read fails
      #'cant-happen ; can not fail because parked machines are not void
      ))

  (defmethod d
    (
      (tm tm-parked)
      &optional 
      spill
      (cont-ok #'echo)
      (cont-rightmost (λ()(error 'dealloc-on-rightmost)))
      (cont-not-supported (λ()(error 'not-supported)))
      (cont-collision (λ()(error 'dealloc-entangled)))
      (cont-no-alloc (λ()(error 'alloc-fail)))
      )
    (d-parked tm spill cont-ok cont-rightmost cont-not-supported cont-collision cont-no-alloc)
    )

  (defmethod d◧
    (
      (tm tm-parked)
      &optional 
      spill
      (cont-ok #'echo)
      (cont-rightmost (λ()(error 'dealloc-on-rightmost)))
      (cont-not-supported (λ()(error 'not-supported)))
      (cont-collision (λ()(error 'dealloc-entangled)))
      (cont-no-alloc (λ()(error 'alloc-fail)))
      )
    (d-parked tm spill cont-ok cont-rightmost cont-not-supported cont-collision cont-no-alloc)
    )
