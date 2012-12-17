(define user-mapping
  (map
    (lambda (file)
      (let ((username (if (string-suffix? "json" file)
                          (substring file 0 (- (string-length file) 5))
                          file)))
        (list username . ((read-all (string-append "people/" file))))))
    (directory "people")))
