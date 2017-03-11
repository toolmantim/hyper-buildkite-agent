FROM buildkite/agent:3

# We use a top-level mount dirs so it works with nfs properly
VOLUME /buildkite-builds
VOLUME /buildkite-secrets

ENV DOCKER=true

RUN apk add --no-cache \
	e2fsprogs \
	iptables

COPY entrypoint.sh /entrypoint.sh

ENV BUILDKITE_AGENT_NAME="hyper-agent-%n"
ENV BUILDKITE_BUILD_PATH="/buildkite-builds"

ENTRYPOINT ["/sbin/tini", "-s", "-g", "--", "/entrypoint.sh", "buildkite-agent-entrypoint"]
