FROM alpine:latest

RUN apk add --no-cache socat

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 1337

CMD ["./entrypoint.sh"]
