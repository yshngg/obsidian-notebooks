
How to compile C program with Alpine container?

```dockerfile
# Stage 1: Build binary using GCC on Alpine for a lightweight footprint
FROM alpine:3.24.1 AS build

# RUN apk add --no-cache gcc musl-dev
RUN apk add --no-cache build-base

WORKDIR /src
COPY memstress.c .

RUN gcc -O2 -Wall -Wextra -static -o memstress memstress.c

# Stage 2: Minimal runtime image
FROM alpine:3.24.1

COPY --from=build /src/memstress /usr/local/bin/memstress

ENTRYPOINT ["/usr/local/bin/memstress"]
CMD ["--help"]
```


## Reference

https://stackoverflow.com/a/42366740
