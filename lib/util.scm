(define list->alist
  (lambda (lst)
    (letrec ((process (lambda (items memo)
                        (if (> 2 (length items))
                          memo
                          (process (cddr items) (alist-update (car items) (cadr items) memo))))))
             (process lst (list)))))



