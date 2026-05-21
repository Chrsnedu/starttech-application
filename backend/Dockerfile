# syntax=docker/dockerfile:1.7

# Build the Go binary in an isolated stage so the runtime image stays small.
FROM golang:1.25-alpine AS builder

WORKDIR /src
COPY Server/MuchToDo/go.mod Server/MuchToDo/go.sum ./Server/MuchToDo/
WORKDIR /src/Server/MuchToDo
RUN go mod download

COPY Server/MuchToDo/ ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/api ./cmd/api

# Run as a dedicated non-root user to satisfy container hardening requirements.
FROM alpine:3.22

RUN addgroup -S app && adduser -S app -G app

WORKDIR /app
COPY --from=builder /out/api /app/api
EXPOSE 8080

USER app
ENTRYPOINT ["/app/api"]
