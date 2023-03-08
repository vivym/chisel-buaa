# build stage
FROM golang:alpine AS build

RUN apk update && apk add git

ADD . /src

WORKDIR /src

ENV CGO_ENABLED 0

RUN go build \
    -ldflags "-X github.com/vivym/chisel-buaa/share.BuildVersion=$(git describe --abbrev=0 --tags)" \
    -o /tmp/bin


# run stage
FROM scratch

LABEL maintainer="vivym@live.com"

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

WORKDIR /app

COPY --from=build /tmp/bin /app/bin

ENTRYPOINT ["/app/bin"]
