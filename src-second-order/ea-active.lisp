#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#

(in-package #:tm)


;;--------------------------------------------------------------------------------
;; entanglements support
;;
  (defun-typed entangled-on-same-cell ((tm ea-active) &optional ➜)
    (destructuring-bind
      (&key
        (➜t (be t))
        (➜∅ (be ∅))
        &allow-other-keys
        )
      ➜
    (c◧∃ (entanglements tm)
      (λ(es ct c∅)
        (let(
              (etm (tg:weak-pointer-value (r es)))
              )
          (if 
            (∧
              etm
              (¬ (eq etm tm))
              (typep etm 'status-active)
              (= (address etm) (address tm))
              )
            [ct]
            [c∅]
            )))
      ➜t
      ➜∅
      )))

(defun-typed entangled-on-right-neighbor-cell ((tm ea-active) &optional ➜)
    (destructuring-bind
      (&key
        (➜t (be t))
        (➜∅ (be ∅))
        &allow-other-keys
        )
      ➜
    (c◧∃ (entanglements tm)
      (λ(es ct c∅)
        (let(
              (etm (tg:weak-pointer-value (r es)))
              )
          (if 
            (∧
              etm
              (typep etm 'status-active)
              (≠ (address tm) 0)
              (= (address etm) (- (address tm) 1))
              )
            [ct]
            [c∅]
            )))
      ➜t
      ➜∅
      )))


;;--------------------------------------------------------------------------------
;; tm-decl-only
;;
  (defun-typed a ((tm ea-active) instance &optional ➜)
    (destructuring-bind
      (&key
        (➜ok (be t))
        &allow-other-keys
        )
      ➜
      (labels(
               (inc-rightside-addresses (tm)
                 (c◧∀* (entanglements tm)
                   (λ(es)
                     (let(
                           (etm (tg:weak-pointer-value (r es)))
                           )
                       (when etm
                           (incf (address-rightmost etm))
                           (when
                             (> (address etm) (address tm))
                             (incf (address etm))
                             ))))))
               )
        (a (base tm) instance
          {
            :➜ok (λ()
                   (inc-rightside-addresses tm)
                   [➜ok]
                   )
            (o (remove-key-pair ➜ :➜ok))
            }))))

;;--------------------------------------------------------------------------------
;; solo-tm-decl-only
;;
  ;; see ea-parked-active for a◧ and d◧
  (defun-typed d ((tm ea-active) &optional spill ➜)
    (destructuring-bind
      (&key
        (➜ok #'echo)
        (➜collision (λ()(error 'dealloc-collision)))
        &allow-other-keys
        )
      ➜
      (labels(
               (dec-rightside-addresses (tm)
                 (c◧∀* (entanglements tm)
                   (λ(es)
                     (let(
                           (etm (tg:weak-pointer-value (r es)))
                           )
                       (when etm
                         (decf (address-rightmost etm))
                         (when (> (address etm) (address tm))
                           (decf (address etm))
                           ))))))
               )
        (entangled-on-right-neighbor-cell tm
          {
            :➜t ➜collision
            :➜∅ (λ()
                  (d (base tm) spill
                    {
                      :➜ok (λ(instance)
                             (dec-rightside-addresses tm)
                             [➜ok instance]
                             )
                      :➜collision #'cant-happen
                      (o (remove-key-pairs ➜ {:➜ok :➜collision}))
                      }))
            }))))
                               
;;--------------------------------------------------------------------------------
;; nd-tm-decl-only
;;
