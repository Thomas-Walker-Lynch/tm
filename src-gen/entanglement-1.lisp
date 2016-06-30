#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt


|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;; removing an entanglement
;; 
;;
  (defun disentangle (tm)
    "Removes tm from the associated entanglements set. This is done, for example, 
     in the cue-to function to release the instance for reuse.
     "
    (let(
          (es (entanglements tm)) ; es must be type tm-list
          )
      (unless es (return-from disentangle))
      (let(
            (e (r◧ es))
            )
        (when
          (eq e tm)
          (d◧ es)
          (return-from disentangle)
          ))
      (cue-leftmost es)
      (⟳-loop
        (λ(cont-loop)
          (fsnr es 1
            (λ(e) 
              (when (eq e tm) 
                (d es)
                (return-from disentangle) ; found it, so return
                ))
            (λ() ; typical return, index fails because we are on rightmost
              (return-from disentangle)
              ))
          (s es cont-loop (λ()(return-from disentangle)))
          ))
      ))

