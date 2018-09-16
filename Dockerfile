
FROM alpine

RUN apk --no-cache add bc curl

COPY entrypoint.sh /

ENTRYPOINT /entrypoint.sh



