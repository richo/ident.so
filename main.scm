#!/usr/bin/env csi -ss

(use srfi-13)
(use srfi-18)
(use tcp)
(use posix)
(use utils)
; (require-extension intarweb)

(require "lib/json")

; Fetch our datastore
(cond ((get-environment-variable "IDENTSO_DATASTORE")
        (require (string-append "datastore/" (get-environment-variable "IDENTSO_DATASTORE"))))
      ((or (get-environment-variable "REDISCLOUD_URL") (get-environment-variable "REDIS_URL"))
        (require "datastore/redis"))
      (else (require "datastore/file")))

(require "lib/response")
(require "lib/request")
(require "lib/user")


(define ident-so-port
  (get-environment-variable "PORT"))

(define threaded?
  (if (get-environment-variable "IDENT_THREADED") #t #f))

(define real-handle
  (lambda (in out)
    ; We're lazy- we can find out everything about the request that we care
    ; about from it's first line
    (let ((line (read-line in)))
      (if (not (equal? line #!eof))
        (let ((request-path (get-request-path line))
           (request-method (get-request-method line))
           (response (make-response)))
      (write-response
        (cond ((string=? request-path "/")
             (set-response-header "Content-Type" "text/html"
             (set-response-body "<html><body><b>Got root?</b></body></html>" response)))
            ((string=? request-path "/rawr")
             (set-response-body "got rawr?" response))
            (else
             (get-user-page (user-from-path request-path) response))
            )
        out)))
      (close-input-port in)
      (close-output-port out))))

(define handle
  (if threaded?
    real-handle
    (lambda (in out) (thread-start! (make-thread (lambda () (real-handle in out)))))))

(define main
  (lambda (argv)
    (letrec ((sock (tcp-listen (string->number (get-environment-variable "PORT"))))
      (mainloop (lambda ()
        (let-values (((s-in s-out) (tcp-accept sock)))
          (handle s-in s-out)
          (mainloop)))))
      (mainloop))))
