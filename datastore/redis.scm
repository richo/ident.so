(use redis-client)

(define redis-url
  (call/cc (lambda (cc)
    (for-each (lambda (el)
                (if (get-environment-variable el) (cc (get-environment-variable el))))
                '("REDISCLOUD_URL" "REDIS_URL"))
    ; Only reached if we have no connection
    (cc #f))))

(define url->values
  (lambda (url)
    (let ((parts (string-split url ":/@")))
      ; scheme user password hostname port
      (case (length parts)
            ; TODO Obviously catch other urls
            ((5) (apply values parts))))))

(define-values (redis-scheme redis-user redis-password redis-host redis-port) (url->values redis-url))

(redis-connect redis-host (string->number redis-port))
(redis-auth redis-password)


(define get-user-by-name
  (lambda (name)
    (let ((user-data (redis-hgetall (string-append "user:" name))))
      (if (= 0 (length user-data))
        #f
        (alist->json (list->alist user-data))))))

