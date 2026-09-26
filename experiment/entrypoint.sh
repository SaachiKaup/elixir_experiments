#!/usr/bin/env bash
set -euo pipefail

NAME="${NAME:-node@localhost}"
COOKIE="${COOKIE:-cookie}"
PORT="${PORT:-9100}"
PEER="${PEER:-peer@localhost}"

echo "hostname: $(hostname)"
echo "name: $NAME"
echo "peer: $PEER"
echo "port: $PORT"
echo "hosts:"
cat /etc/hosts

epmd -daemon

exec erl -name "$NAME" \
  -setcookie "$COOKIE" \
  -kernel inet_dist_listen_min "$PORT" inet_dist_listen_max "$PORT"
