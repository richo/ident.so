#!/usr/bin/env csi -ss

(use srfi-13)
(use srfi-18)
(use tcp)
; (require-extension intarweb)
(require "lib/response")
(require "lib/request")


(define ident-so-port
  (get-environment-variable "PORT"))

(define threaded?
  (if (get-environment-variable "IDENT_THREADED")
      #t
      #f
      ))

(define handle
  (lambda (in out)
    ; We're lazy- we can find out everything about the request that we care
    ; about from it's first line
    (let* (
           ; (line (read-line in))
           ; (request-path (get-request-path line))
           ; (request-method (get-request-method line))
           (response (make-response))
           )
      (write-response
        ; (cond ((string=? request-path "/")
             (set-response-header "Content-Type" "text/html"
               (set-response-body "<html><body><b>Got root?</b></body></html>" response)
            ; )
            ; ((string=? request-path "/rawr")
            ;  (set-response-body "got rawr?" response))
            ; (else
            ;  (set-response-body "No such page mang" response))
            ) out)
      (close-input-port in)
      (close-output-port out)
      )
  ))



(define main
  (lambda (argv)
    (letrec ((sock (tcp-listen (string->number (get-environment-variable "PORT"))))
      (mainloop (lambda ()
        (let-values (((s-in s-out) (tcp-accept sock)))
          (if threaded?
            (thread-start! (make-thread (lambda () (handle s-in s-out))))
            (handle s-in s-out)
            )
          (mainloop)
          ))))
      (mainloop))))
