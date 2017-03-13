#!/bin/bash

set -eu

if [[ "${BUILDKITE_AGENT_EXIT_AFTER_JOB}" == "true" ]]; then
  # Gracefully terminate the buildkite-agent, which will cause the agent to shut
  # down once it's finished this job.
  #
  # Other processes running in this container:
  #
  # * tini buildkite-agent start
  # * buildkite-agent start
  # * buildkite-agent bootstrap
  #
  # Notes:
  #
  # * We specify we only want the 'newest' matching process, so we don't match
  #   tini and signal the entire group,.
  # * We specify -f and 'start' so we don't match the bootstrap process,
  #   otherwise it'll cause the hook to have an exit status of -1 and cause the
  #   whole job to be marked as failed.
  pkill -TERM -n -f 'buildkite-agent start'
fi