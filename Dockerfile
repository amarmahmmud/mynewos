FROM golang:bullseye AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends tigervnc-standalone-server supervisor && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ca-certificates midori && \
    rm -rf /var/lib/apt/lists

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY supervisord.conf /etc/

EXPOSE 8080
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
