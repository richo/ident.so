(test-begin "json")

(test "encodes int" "4"
      (elem->jsonobj 4))

(test "encodes string" "\"rawr test\""
      (elem->jsonobj "rawr test"))

(test "encodes alists" "{\"rawr test\":4}"
      (alist->json '(("rawr test" . 4))))

(test "encodes nested lists" "{\"rawr test\":4}"
      (alist->json '(("rawr test" 4))))

(test-end)
