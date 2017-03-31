#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  Quantification

  Note the true and false continuations are not optional on pred.

  continuation arguments for the existential and universl quantification are given in the
  argument list

  the cue leftmost versions should call the quantifier in the ok continatuaion?

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; looping, see also s-together⟳  --> need to replace these with quantifiers
;;

#| sbcl doesn't appear to remove the recursion, so redefining this:
  
  (defun ⟳ (work)
    "⟳ (pronounced \"do\") accepts a 'work' function. 'work' may be a nameless lambda. ⟳
     calls work with a single continuation argument.  That continuation is the work
     function.  Hence, when the continuation is called, work is called again.
     "
    (labels(
             (again() (funcall work #'again))
             )
      (again)
      ))
|#

  (defun ⟳ (work)
    "⟳ (pronounced \"do\") accepts a 'work' function. 'work' may be a nameless lambda. ⟳
     calls work with a single continuation argument.  That continuation is the work
     function.  Hence, when the continuation is called, work is called again.
     "
    ;; unlike all other forms in Common Lisp, tagbody does not return the value
    ;; from the last contained body form, instead it always returns nil.  I
    ;; suppose the Lisp designers thought it was prettier with a closure.
    (let(return-value) 
      (tagbody 
        again
        (setf return-value (funcall work (λ()(go again))))
        )
      return-value
      ))


;;--------------------------------------------------------------------------------
;; trivial predicates 
;;
  (defun always-true (tm ➜t ➜∅)
    (declare (ignore tm ➜∅))
      [➜t]
      )

  (defun always-false (tm ➜t ➜∅)
    (declare (ignore tm ➜t))
      [➜∅]
      )


;;--------------------------------------------------------------------------------
;; quantification
;;
;; careful:
;;
;; The quantifiers start where the head is located, they do not c◧ first.  I do
;; this so that prefix values may be processed before calling a quantifier.
;;
;; I pass to the predicate the entire tape machine, rather than just the instance in the
;; cell the head is on.  I do this so that predicates may use the head as a general marker
;; on the tape, for example, as the origin for a sliding window.
;;
;; pred is a function that accepts a machine and two continuations, ➜t, and ➜∅.
;;

  #|
    so far haven't seen a need to make these typed

    (def-function-class ∃ (tm pred &optional ➜t ➜∅))
    (def-function-class ∀ (tm pred &optional ➜t ➜∅))

    (def-function-class c◧∃ (tm pred &optional ➜t ➜∅))
    (def-function-class c◧∀ (tm pred &optional ➜t ➜∅))

    (def-function-class ∃* (tm pred &optional ➜t ➜∅))
    (def-function-class ∀* (tm pred &optional ➜t ➜∅))
  |#

  (defun ∃ (tm pred &optional (➜t (be t)) (➜∅ (be ∅)))
    "Tests each instance in tm in succession starting from the current location of the head.
     Exits via ➜t upon the test passing.  Otherwise steps and repeats. Exits via
     ➜∅ when stepping right from rightmost.  The head is left on the cell that holds the
     instance that passed.
    "
    (⟳(λ(again)[pred tm ➜t (λ()(s tm {:➜ok again :➜rightmost ➜∅}))]))
    )

  (defun c◧∃ (tm pred &optional (➜t (be t)) (➜∅ (be ∅)))
    (c◧ tm)
    (∃ tm pred ➜t ➜∅)
    )

  ;; there does not exist an instance for which pred is false
  ;; pred is true for all instances
  (defun ∀ (tm pred &optional (➜t (be t)) (➜∅ (be ∅)))
    "➜t when all instances on the tape pass the test, otherwise ➜∅, head left on cell with first failed test."
    (∃ tm (λ(tm ct c∅)[pred tm c∅ ct]) ➜∅ ➜t)
    )

  (defun c◧∀ (tm pred &optional (➜t (be t)) (➜∅ (be ∅)))
    (c◧ tm)
    (∀ tm pred ➜t ➜∅)
    )

  ;; similar to ∃, but tests every instance.  Returns a number pair, the total tests done
  ;; (= length of tape tail), and the number of tests that returned true.
  (defun ∃* (tm pred)
    "Calls (pred tm ➜t ➜∅), and steps head, until reaching the end fo the tape, returns
     number pair: (true.count.false-count)."
    (let(
          (true-count 0)
          (false-count 0)
          )
      (⟳(λ(again)
          [pred tm
            (λ()(incf true-count))
            (λ()(incf false-count))
            ]
          (s tm
            {
              :➜ok again
              :➜rightmost #'do-nothing
              }
            )))
      (cons true-count false-count)
      ))

  (defun c◧∃* (tm pred)
    (c◧ tm)
    (∃ tm pred)
    )

  (defun ∀* (tm function)
    "Calls (function tm), and steps head, until reaching the end of the tape. Returns
     nothing."
    (⟳(λ(again)
        [function tm]
        (s tm
          {
            :➜ok again
            :➜rightmost #'do-nothing
            }
          ))))

  (defun c◧∀* (tm function)
    (c◧ tm)
    (∀* tm function)
    )

