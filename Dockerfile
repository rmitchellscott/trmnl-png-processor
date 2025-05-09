FROM theidledeveloper/aws-cli-alpine:2.27.11-alpine3.17

RUN apk add --no-cache \
      imagemagick \
      bash \
      jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
