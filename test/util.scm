(test-begin "util")

(test '((rawr . "foo") (something . 5))
      (list->alist (list 'rawr "foo" 'something 5)))

(test-end)
