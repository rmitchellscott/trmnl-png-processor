# FROM theidledeveloper/aws-cli-alpine:2.15.14-r0-alpine3.19
FROM alpine:3.21

RUN apk add --no-cache \
      aws-cli \
      imagemagick \
      bash \
      jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
