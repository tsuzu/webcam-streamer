FROM --platform=$BUILDPLATFORM golang:1.23 AS builder

RUN mkdir /webcam-streamer && \
  cd /webcam-streamer && \
  go mod init webcam-streamer && \
  go get github.com/blackjack/webcam/examples/http_mjpeg_streamer && \
  GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build github.com/blackjack/webcam/examples/http_mjpeg_streamer

FROM debian:bookworm-slim

COPY --from=builder /webcam-streamer/http_mjpeg_streamer /bin/http_mjpeg_streamer

ENTRYPOINT ["/bin/http_mjpeg_streamer"]
