#!/bin/bash

set -eu

if [[ "${HYPER_SCHEDULER}" == "true" ]]; then
  echo "--- :hyper-sh: Starting hyper.sh job runner container"

  hyper \
    --config /buildkite-secrets/hyper \
    run \
    -s "${HYPER_RUNNER_SIZE}" \
    -d \
    --volumes-from buildkite-data \
    -e "BUILDKITE_AGENT_EXIT_AFTER_JOB=true" \
    toolmantim/hyper-buildkite-agent \
    start \
    --meta-data "queue=hyper-job:${BUILDKITE_JOB_ID}" \
    --name "hyper-runner-%n"

  echo "--- :buildkite: Requeuing job to runner container"

  # XXX This command/endpoint doesn't exist yet
  buildkite-agent requeue "hyper-job:${BUILDKITE_JOB_ID}"
else
  exec buildkite-agent bootstrap "$@"
fi
