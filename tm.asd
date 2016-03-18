#|

Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

|#


(in-package :asdf-user)

(defsystem #:tm
  :name "tm"
  :version "0.2"
  :author "Thomas W. Lynch <thomas.lynch@reasoningtechnology.com>"
  :description "Formalized Iteration Library for Common LISP"
  :depends-on ("local-time")
  :serial t
  :components((:module "src"
                :components (
                              (:file "package")
                              (:file "conditions")

                              (:file "fundamental")
                              (:file "list-L")
                              (:file "functions")

                              (:file "mk-tm")
                              (:file "tm-primitives")
                              (:file "tm-derived")
                              (:file "tm-subspace")
                              (:file "tm-quantifiers")

                              (:file "location")
                              (:file "length")
                              (:file "worker")
                              (:file "buffers")

                              (:file "tm-void")
                              (:file "tm-singular-affine")
                              (:file "tm-singular-projective")
                              (:file "tm-linear")

                              (:file "tm-interval")
                              (:file "tm-transform")

                              (:file "tm-list-primitives")
                              (:file "tm-list-derived")
                              (:file "tm-list-buffers")

                              (:file "tm-tree")

                              (:file "worker-utilities")


                              #|
                              (:file "tm-array")


                              (:file "list-0")
                              
                              (:file "tree-0")
                              (:file "list-lang") ; accessor lang here delta-s etc.
                              |#
                              ))

               (:module "test-framework"
                :components (
                              (:file "framework")
                              ))

               (:module "test"
                :components (
                              (:file "list-L")
                              (:file "length")
                              (:file "location")
                              (:file "tm-derived")
                              (:file "tm-quantifiers")
                              (:file "tm-subspace")
                              (:file "worker")
                              (:file "tm-void")
                              (:file "buffers")
                              (:file "tm-list-primitives")
                              (:file "tm-tree")
                              (:file "worker-utilities")
                              ))

               ))
  
  



