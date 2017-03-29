#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; entanglements support
;;
  (def-function-class clean-entanglements (tm))

  ;; machines are considered to be entangled with themselves, thus
  ;; we can never have an empty entanglements machine
  (defun-typed clean-entanglements ((tm ea-tm))
    (let(
          (es (entanglements tm))
          )

      (c◧ es)
      (⟳
        (λ(➜again)
          (if
            (on-rightmost es)
            (return-from clean-entanglements t)
            (when (tg:weak-pointer-value (r es))
              (when (on-leftmost es) (s es {:➜rightmost #'cant-happen}))
              (d◧ es)
              [➜again]
              ))))
      (⟳
        (λ(➜again)
          (if
            (on-rightmost es)
            (return-from clean-entanglements t)
            (if
              (tg:weak-pointer-value (esr es))
              (d es)
              (s es {:➜ok ➜again :➜rightmost (λ()(return-from clean-entanglements t))})
              ))))

      [#'cant-happen]
      ))

  ;machine in entanglement group is on ◧ ?
  (defun entangled-on-leftmost (es &optional (➜t (be t)) (➜∅ (be ∅)))
    (c◧∃ es
      (λ(es ct c∅)
        (let(
              (etm (tg:weak-pointer-value (r es)))
              )
          (if 
            (∧
              etm
              (typep etm 'status-active)
              (= (address etm) 0)
              )
            [ct]
            [c∅]
            )))
      ➜t
      ➜∅
      ))

  ;another machine in entanglement group on same cell as tm?
  (def-function-class entangled-on-same-cell (entanglements-tm &optional ➜))
  (def-function-class entangled-on-right-neighbor-cell (entanglements-tm &optional ➜))


;;--------------------------------------------------------------------------------
;; solo-tm-decl-only
;;


