(define get-request-method
  (lambda (req)
    (cdr (assoc 'method req))))

(define request-method-from-line
  (lambda (line)
    (car (string-tokenize line))))

(define get-request-path
  (lambda (req)
    (cadr (assoc 'path req))))
(define request-path-from-line
  ; Maximum ghetto. Expect a line like:
  ; GET /index.html HTTP/1.1
  (lambda (line)
    (let ((tokenized-line (string-tokenize line)))
      ; TODO strip query strings
      (car (cdr tokenized-line)))))

(define make-request
  (lambda (line) ; port?
    '((path (get-request-path line))
      (method (get-request-method line)))))
