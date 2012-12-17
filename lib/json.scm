(define elem->jsonobj
  (lambda (elem)
    (cond ((string? elem)
           (string-append "\"" elem "\""))
          ((number? elem)
           (number->string elem))
          (else ; TODO
            elem))))

(define alist->json
  (lambda (alst)
    (string-append "{"
      (string-intersperse (map (lambda (pair)
                                 (string-intersperse (list (elem->jsonobj (car pair)) (elem->jsonobj (cadr pair))) ":")
                                 ) alst) ",") "}" )))



