## Example

https://github.com/mvdan/sh/blob/a04df9f0d4b8947a42d176b5d22a814b61dd6ac4/cmd/shfmt/Dockerfile

```dockerfile
FROM golang:1.26.1-alpine AS build

WORKDIR /src
RUN apk add --no-cache git
COPY . .
RUN CGO_ENABLED=0 go build -ldflags "-w -s -extldflags '-static'" ./cmd/shfmt

FROM alpine:3.23.3 AS alpine
COPY --from=build /src/shfmt /bin/shfmt
COPY "./cmd/shfmt/docker-entrypoint.sh" "/init"
ENTRYPOINT ["/init"]

FROM scratch
COPY --from=build /src/shfmt /bin/shfmt
ENTRYPOINT ["/bin/shfmt"]
CMD ["-h"]
```

## Podman / Docker Command Line

The flag `--target` set the target build stage to build

```bash
$ podman build --help
Build an image using instructions from Containerfiles

Description:
  Builds an OCI or Docker image using instructions from one or more Containerfiles and a specified build context directory.

Usage:
  podman build [options] [CONTEXT]
# ...
      --target string                                set the target build stage to build
```

## GitHub Action build-push-action

https://github.com/docker/build-push-action#inputs

| Name     | Type   | Description                    |
| -------- | ------ | ------------------------------ |
| `target` | String | Sets the target stage to build |
| ...      | ...    | ...                            |
