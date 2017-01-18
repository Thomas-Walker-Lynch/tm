#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  Tests may also be scattered through the code.

  All tests have names of the form test-fun-n  where fun is the function
  or logical concept being tested.

  Using the list implementation to test the tm-derived interface.  For
  methods that are specialized for list, see the tests in tm-list-derived.

|#
  (in-package #:tm)

;;--------------------------------------------------------------------------------
;; tm-derived
;;
  (defun test-fsnr-0 ()
    (let(
          (k (mount [6 7 8]))
          )
      (∧
        (= 6 (fsnr k 0))
        (= 7 (fsnr k 1))
        (= 8 (fsnr k 2))
        (fsnr k 3 (be ∅) (be t))
        )))
  (test-hook test-fsnr-0)

  (defun test-d◧-0 ()
    (let*(
           (a (list 1 2 3))
           (tm1 (mount a))
           )
      (s tm1) ; moves head off of leftmost
      (∧
        (= (d◧ tm1) 1)
        (equal (tape tm1) '(2 3))
        )))
  (test-hook test-d◧-0)

  (defun test-d◧-1 ()
    (let(
          (tm1 (mk 'tm-list))
          )
      (d◧ tm1 ∅ (be ∅) (be t))
      ))
  (test-hook test-d◧-1)