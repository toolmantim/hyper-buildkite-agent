FROM buildkite/agent:3

VOLUME /var/lib/docker
VOLUME /buildkite/builds
VOLUME /buildkite/secrets

RUN apk add --no-cache \
	e2fsprogs \
	iptables

COPY entrypoint.sh /entrypoint.sh

ENV BUILDKITE_AGENT_NAME="hyper-agent-%n"

ENTRYPOINT ["/sbin/tini", "-s", "-g", "--", "/entrypoint.sh", "buildkite-agent-entrypoint"]
