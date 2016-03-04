(in-package :asdf-user)

(defsystem #:tm
  :name "tm"
  :version "0.1"
  :author "Thomas W. Lynch <thomas.lynch@reasoningtechnology.com>"
  :description "Formalized Iteration Library for Common LISP"
  :depends-on ("local-time")
  :serial t
  :components((:module "src"
               :components (
                             (:file "package")
                             (:file "conditions")

                             (:file "fundamental")
                             (:file "test")
                             (:file "functions")


                             (:file "mk-tm")
                             (:file "tm-primary")
                             (:file "tm-secondary")
                             (:file "tm-si")
                             (:file "tm-quantifiers")
                             (:file "location")
                             (:file "length")

                             (:file "tm-void")
                             (:file "tm-singular-affine")
                             (:file "tm-singular-projective")
                             (:file "tm-line")

                             (:file "tm-transform")
#|


                             (:file "tm-read-filter")
                             (:file "tm-write-filter")

                             (:file "tm-subspace")


                             (:file "data-structures")
                             
                             (:file "tm-list")
                             (:file "data-structures-list")

                             (:file "tm-array")

                             (:file "tm-tree")

                             (:file "list-0")
                             (:file "list-L")
                             
                             (:file "tree-0")
                             (:file "list-lang") ; accessor lang here delta-s etc.
                             (:file "test-le")
|#
                             ))))


