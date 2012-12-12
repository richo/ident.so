(define user-from-path
  (lambda (path)
    (substring path 1 (string-length path))))

(define get-user-page
  (lambda (user response)
    (set-response-body
      (string-append "Hello " user)
      response)))
