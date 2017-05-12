#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  All tests have names of the form test-fun-n  where fun is the function
  or logical concept being tested.

|#
(in-package #:tm)

(defun test-status-0 ()
  (let*(
         (tm0 (mk 'list-tm {:tape {1 2 3}}))
         (tm1 (mk 'status-tm {:base tm0}))
         )
    (∧
      (typep tm1 'active)
      (= (r tm1) 1)
      (= (s tm1 {:➜ok (be 7) :➜rightmost (be 8)}) 7)
      (= (r tm1) 2)
      (= (s tm1 {:➜ok (be 7) :➜rightmost (be 8)}) 7)
      (= (r tm1) 3)
      (= (s tm1 {:➜ok (be 7) :➜rightmost (be 8)}) 8)
      (= (r tm1 {:➜parked (be 21) :➜ok (be 22)}) 22)
      (= (hp tm1 {:➜ok (be 11)}) 11)
      (typep tm1 'parked)
      (= (r tm1 {:➜parked (be 21) :➜ok (be 22)}) 21)
      (= (h◧ tm1 {:➜ok (be 41)}) 41)
      (typep tm1 'active)
      (= (r tm1 {:➜ok (λ(x)(+ x 99))}) 100)
    )))
(test-hook test-status-0)

(defun test-status-1 ()
  (let*(
         (t0 (mk 'list-solo-tm {:tape {1 2 3}}))
         (t1 (mk 'status-tm {:base t0}))
         )
    (∧
      (hp t1)
      (= (d◧ t1) 1)
      (= (d  t1) 2)
      (s t1)
      (= (r t1) 3)
      (hp t1)
      (= (d t1) 3)
      (typep t1 'empty)
      )))
(test-hook test-status-1)

       
(defun test-status-4 ()
  (let*(
         (tm0 (mk 'list-solo-tm {:tape {∅}}))
         (tm1 (mk 'status-tm {:base tm0 :status 'empty}))
         )
    (∧
      (a◧ tm1 10)
      (a◧ tm1 20)
      (a◧ tm1 30)
      (typep tm1 'parked)
      (s tm1)
      (= (r tm1) 30)
      (s tm1)
      (= (r tm1) 20)
      (s tm1)
      (= (r tm1) 10)
      (¬ (s tm1))
      )
    ))
(test-hook test-status-4)

(defun test-status-5 ()
  (let*(
         (tm0 (mk 'list-solo-tm {:tape {∅}}))
         (tm1 (mk 'status-tm {:base tm0 :status 'empty}))
         )
    (∧
      (as tm1 10)
      (as tm1 20)
      (as tm1 30)
      (typep tm1 'active)
      (= (r tm1) 30)
      (h◧ tm1)
      (= (r tm1) 10)
      (s tm1)
      (= (r tm1) 20)
      (s tm1)
      (= (r tm1) 30)
      (¬ (s tm1))
      )
    ))
(test-hook test-status-5)

(defun test-status-6 ()
  (let*(
         (tm10 (mk 'list-solo-tm {:tape {∅}}))
         (tm11 (mk 'status-tm {:base tm10 :status 'empty}))
         (tm20 (mk 'list-solo-tm {:tape {∅}}))
         (tm21 (mk 'status-tm {:base tm20 :status 'empty}))
         )
    (∧
      (a tm11 101)
      (a tm11 102)
      (a tm11 103)
      (typep tm11 'parked)
      (d◧ tm11 tm21)
      (d◧ tm11 tm21)
      (d◧ tm11 tm21)
      (= (r tm21) 101)
      (h◧ tm21)
      (= (r tm21) 103)
      (s tm21)
      (= (r tm21) 102)
      (s tm21)
      (= (r tm21) 101)
      (¬ (s tm21))
      )
    ))
(test-hook test-status-6)

(defun test-status-7 ()
  (let*(
         (tm11 (mk 'status-tm {:base-type 'list-solo-tm :tape {21 23 25} :status 'parked}))
         (tm21 (mk 'status-tm {:base-type 'list-solo-tm :status 'empty}))
         )
    (∧
      (typep tm11 'parked)
      (= (r tm11 {:➜ok #'cant-happen :➜parked (be 777)}) 777)
      (=
        (h◧∀ tm11 (λ(tm ct c∅) (if (oddp (r tm)) [ct] [c∅])) {:➜t (be 717) :➜∅ (be 719)})
        717
        )
      (=
        (∀ tm21 (λ(tm ct c∅) (if (oddp (r tm)) [ct] [c∅])) {:➜t (be 717) :➜∅ (be 719)})
        717
        )
      (=
        (∃ tm21 (λ(tm ct c∅) (if (oddp (r tm)) [ct] [c∅])) {:➜t (be 717) :➜∅ (be 719)})
        719
        )
      )))
(test-hook test-status-7)


(defun test-status-8 ()
  (let*(
         (tm11 (mk 'status-tm {:base-type 'list-solo-tm :tape {21 23 25} :status 'parked}))
         )
    (∧
      (typep tm11 'parked)
      (= (r tm11 {:➜ok #'cant-happen :➜parked (be 777)}) 777)
      (=
        (∀ tm11 ; quantifier starts at the parked head position
          (λ(tm ct c∅)
            (if
              (∨
                (on-rightmost tm)
                (oddp (esr tm))
                )
              [ct]
              [c∅]
              ))
          {
            :➜t (be 717)
            :➜∅ (be 719)
            }
          )
        717
        )
      )))
(test-hook test-status-8)

