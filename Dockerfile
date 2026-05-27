FROM golang:1.23-alpine AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o dbinsights-exporter ./cmd

FROM alpine:3.21
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /app
COPY --from=builder /build/dbinsights-exporter .
EXPOSE 8081
ENTRYPOINT ["./dbinsights-exporter"]
CMD ["-config", "/etc/dbinsights/config.yml"]
