FROM alpine:latest

RUN apk add --no-cache socat

WORKDIR /app
COPY service.sh .
RUN chmod +x service.sh

EXPOSE 1337

CMD ["socat", "TCP-LISTEN:1337,reuseaddr,fork", "EXEC:./service.sh"]
