#!/usr/bin/env bash
set -e
buildkitd --addr unix:///run/buildkit/buildkitd.sock &
export BUILDKIT_HOST=unix:///run/buildkit/buildkitd.sock

exec /usr/local/bin/jenkins-agent "$@"
