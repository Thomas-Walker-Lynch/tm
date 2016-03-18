#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#

;;--------------------------------------------------------------------------------
;;
  (defpackage #:tm
    (:use common-lisp)
    (:use local-time)
    (:export 

    ;; fundamental
    ;;
      #:defsynonym
      #:∅
      #:¬

      #:≠
      #:≥
      #:≤
      #:∧
      #:∨

      #:string≠
      #:string≤
      #:string≥

      #:λ
      #:nl
      #:defparam

    ;;list-L
    ;;  also defines reader macros for {} and []
    ;;
      #:o
      #:q
      #:unwrap
      #:L

    ;;functions
    ;;
      #:boolify
      #:do-nothing
      #:echo
      #:be
      #:notλ
      #:box
      #:unbox

    ;;mk-tm
    ;;
      #:mk-tm

    ;;tm-primitives
    ;;
      #:tape-machine ; class
      #:r
      #:w
      #:heads-on-same-cell
      #:so
      #:s
      #:a
      #:d

    ;;tm-derived - more than just a primitive interface
    ;;
      #:cue-to
      #:dup

      #:ws
      #:r-index
      #:w-index

      #:cue-rightmost
      #:cue-leftmost

      #:on-leftmost
      #:on-rightmost

      #:s≠ 

      #:a◧
      #:as
      #:ah◨
      #:ah◨s
      #:-a
      #:-a-s

      #:d◧

      #:m  

    ;;tm-subspace
    ;;
      #:si
      #:ai
      #:ais
      #:di

    ;; quantifiers
    ;;
      #:⟳

      #:∃
      #:¬∀
      #:¬∃
      #:∀

      #:∃*
      #:¬∀*
      #:¬∃*
      #:∀*

      #:s-together
      
      #:w*
      #:s*
      #:a*
      #:as*
      #:d*

      #:sn
      #:an
      #:asn
      #:dn

    ;; location
    ;;
      #:on+1
      #:on+n
      #:on-rightmost-1
      #:on-rightmost+n ; n will typically be negative
      #:address
      #:distance+1
      #:distance+n
      #:distance

      #:location-cmp
      #:location≥
      #:location>
      #:location<
      #:location≤
      #:location=
      #:location≠

    ;; number of allocated cells, i.e. length
    ;;
      #:singleton
      #:doubleton
      #:tripleton

      #:length≥
      #:length>
      #:length<
      #:length≤
      #:length=
      #:length≠

    ;; data-structures
    ;;
      #:stack-enqueue
      #:stack-dequeue

      #:queue-enqueue
      #:queue-dequeue

      #:buffer
      #:enqueue
      #:dequeue
      #:empty

      #:stack
      #:queue

    ;; worker
    ;;  
      #:def-worker

    ;; useful machines
    ;;
      #:tm-void
      #:tm-singular-affine
      #:tm-singular-projective
      #:tm-interval

      #:mk-tm-void
      #:mk-tm-singular-affine
      #:mk-singular-projective
      #:mk-tm-interval

    ;; tm-linear
    ;;
      #:line

    ;; tm-list-primitives
    ;;
      #:mk-tm-list
      #:tm-list

    ;; tm-list-buffer
    ;;
      #:stack-list
      #:mk-stack-list
      #:queue-list
      #:mk-queue-list

    ;; tm-tree
    ;;  
      #:tm-tree

      #:tm-depth ;class
      #:tm-depth-list ;class
      #:s-depth-ru
      #:s-depth ; not yet written

      #:tm-breadth ;class
      #:tm-breadth-list ;class
      #:s-breadth

    ;; worker-utilities
    ;;
      #:binner  

    ;;string
    ;;
      #:newline
      #:add-quotes
      #:add-escaped-quotes
      #:add-squotes
      #:add-escaped-squotes
      #:drop-ends
      #:string-∅
      #:is-prefix
      #:drop

    ;; test framework
    ;;
      #:test-hook
      #:test-remove
      #:test-all
      #:*log-default-file-name*
      #:print-to-log

      ))

