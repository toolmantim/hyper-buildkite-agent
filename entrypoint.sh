#!/bin/bash

# Mount the required cgroups
mkdir -p /cgroup/memory && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,memory cgroup /cgroup/memory
mkdir -p /cgroup/cpuset && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,cpuset cgroup /cgroup/cpuset
mkdir -p /cgroup/cpu,cpuacct && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,cpu,cpuacct cgroup /cgroup/cpu,cpuacct
mkdir -p /cgroup/net_cls,net_prio && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,net_cls,net_prio cgroup /cgroup/net_cls,net_prio
mkdir -p /cgroup/blkio && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,blkio cgroup /cgroup/blkio
mkdir -p /cgroup/freezer && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,freezer cgroup /cgroup/freezer
mkdir -p /cgroup/perf_event && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,perf_event cgroup /cgroup/perf_event
mkdir -p /cgroup/devices && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,devices cgroup /cgroup/devices
mkdir -p /cgroup/pids && mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,pids cgroup /cgroup/pids

# Start Docker
dockerd --host=unix:///var/run/docker.sock > /var/log/docker.log 2>&1 &

# Read agent config (w/ token) from /buildkite-agent-secrets
if [[ -f /buildkite-agent-secrets/buildkite-agent.cfg ]]; then
  export BUILDKITE_AGENT_CONFIG=/buildkite-agent-secrets/buildkite-agent.cfg
fi

# Read git https auth info from /buildkite-agent-secrets
if [[ -f /buildkite-agent-secrets/git-credentials ]]; then
  git config --global credential.helper "store --file=/buildkite-agent-secrets/git-credentials"
fi

exec "$@"
