FROM alpine:3.9

RUN apk add --no-cache \
	curl \
	jq

COPY entrypoint.sh /bin/

ENTRYPOINT /bin/entrypoint.sh
