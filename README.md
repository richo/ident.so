ident.so
========

A simple ident service implemented in chicken scheme.

While it's not "designed" to be deployed to heroku, it does work. I
implemented a redis client that'll work out of the box with rediscloud,
but setting REDIS_URL ought to do something reasonable.

Without redis it still works (arguably better) with the people stored on
disk. Take a look in `people/`, you'll find my details.

Starting it is simple:

```bash
PORT=1234 ./main.scm
```
