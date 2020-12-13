FROM golang:1.12.0-alpine3.9
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN go build -o main .
USER appuser
CMD ["/app/main"]
