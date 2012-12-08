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
    (let* ((line (read-line in))
           (request-path (get-request-path line))
           (request-method (get-request-method line)))
      (cond ((string=? request-path "/")
               (display "HTTP/1.0 200 OK\r\n" out)
               (display "Server: k\r\nContent-Type: text/html\r\n\r\n" out)
               (display "<html><body>Hello, world!</body></html>" out))
            ((string=? request-path "/rawr")
               (display "HTTP/1.0 200 OK\r\n" out)
               (display "Server: k\r\nContent-Type: text/html\r\n\r\n" out)
               (display "<html><body>rawr</body></html>" out))
            )
      (close-input-port in)
      (close-output-port out)
      )
  ))



(define main
  (lambda (argv)
    (let ((sock (tcp-listen (string->number (get-environment-variable "PORT")))))
      (define mainloop
        (lambda ()
          (let-values (((s-in s-out) (tcp-accept sock)))
            (if threaded?
              (thread-start! (make-thread (lambda () (handle s-in s-out))))
              (handle s-in s-out)
              )
            (mainloop)
            )))
      (mainloop))))
