FROM buildkite/agent:3

VOLUME /var/lib/docker

RUN apk add --no-cache \
	e2fsprogs \
	iptables

COPY entrypoint.sh /entrypoint.sh

# Bypass the tini entrypoint, because it doesn't seem to work on Hyper...
#
# [WARN  tini (9)] Tini is not running as PID 1 and isn't registered as a child subreaper.
#        Zombie processes will not be re-parented to Tini, so zombie reaping won't work.
#        To fix the problem, use -s or set the environment variable TINI_SUBREAPER to register Tini as a child subreaper, or run Tini as PID 1.

ENTRYPOINT ["/entrypoint.sh", "buildkite-agent-entrypoint"]
