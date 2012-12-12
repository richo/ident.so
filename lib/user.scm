(define user-from-path
  (lambda (path)
    (substring path 1 (string-length path))))

(define get-user-page
  (lambda (u response)
    (let ((user-data (get-user-by-name u)))
      (cond (user-data
          (set-response-body
            user-data
          (set-response-header
            "Content-Type" "text/json"
          response)))
      (else
        (set-response-body
            "No such user"
            response))))))


; TODO Obviously this isn't done.
(define get-user-by-name
  (lambda (name)
    (let ((u (assoc name user-mapping)))
      (if u
        (cadr u)
        #f))))

(define user-mapping
  (map
    (lambda (file)
      (let ((username (if (string-suffix? "json" file)
                          (substring file 0 (- (string-length file) 5))
                          file)))
        (list username . ((read-all (string-append "people/" file))))))
    (directory "people")))
