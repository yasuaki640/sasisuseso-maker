FROM golang:1.23-alpine3.21 AS base

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

FROM base AS local

RUN go install github.com/air-verse/air@latest

EXPOSE 8080

CMD ["air", "-c", ".air.toml"]

FROM base AS builder

RUN CGO_ENABLED=0 GOOS=linux go build -o /main

FROM gcr.io/distroless/base-debian11 AS deploy

WORKDIR /

COPY --from=builder /main /main

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/main"]