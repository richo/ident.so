(define http-ok
  (lambda (r body)
    (http:write-response-header
      r
      200
      "OK"
      `(("Content-type" . "text/plain")
        ("Content-length" . ,(string-length body))))
    (display body)))
