FROM buildkite/agent:3

VOLUME /var/lib/docker

RUN apk add --no-cache \
	e2fsprogs \
	iptables

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "-s", "-g", "--", "/entrypoint.sh", "buildkite-agent-entrypoint"]
