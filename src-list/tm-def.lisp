#|
Copyright (c) 2016 Thomas W. Lynch and Reasoning Technology Inc.
Released under the MIT License (MIT)
See LICENSE.txt

  Abstract tape machines may provide tape machine behavior in a manner
  other than using a head and a tape.  Examples include transforms and most
  generators.  Derived functions that do not access the head or tape should
  probably should accept abstract tape machines.

  The basic tape machine. 

  There are no entanglement operations, no destructive operations, and the machine viewed
  as a container has no status.

  Because basic tape machines have no non-destructive operations, the programming
  paragidgm when using them will be that of non-destructive programming, at least 
  relative to the use of the machines.

  Because basic tape machines have no status, machines that exist will always have at
  least one member.  A function that is passed a container as an operand can not delete
  the container, hence basic tape machines never disappear through side effects.

  Because there are no entanglement operations, a function that is passed a basic tape
  machine as an operand, must move the head of that machine if it is to read any cell
  other than the one initially under the head.  Furhtermore, in right going only machines,
  it is not possible for a function to move the head, then move it back. Hence 1) progress
  towards the end of a tape will be monotonic. 2) the range of cells used by the funciton
  will be apparent.

|#

(in-package #:tm)

;;--------------------------------------------------------------------------------
;;
  (defclass abstract-tape-machine ())
  

;;--------------------------------------------------------------------------------
;;
  (defclass tape-machine (abstract-tape-machine)
    (
      (head ; locates a cell on the tape
        :initarg :head 
        :accessor head
        )
      (tape ; a sequence of cells, each that may hold an instance
        :initarg :tape
        :accessor tape
        )
      ))

