#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <experiment-name> <command...>"
  exit 1
fi

NAME="$1"
shift
STAMP=$(date +%Y%m%d-%H%M%S)
DIR=".agent/experiments/$STAMP-$NAME"
mkdir -p "$DIR"

echo "Running experiment: $NAME"
echo "Command: $*" | tee "$DIR/command.txt"

set +e
START=$(date +%s)
("$@") > "$DIR/output.log" 2>&1
STATUS=$?
END=$(date +%s)
set -e

DURATION=$((END-START))
{
  echo "name=$NAME"
  echo "status=$STATUS"
  echo "duration_seconds=$DURATION"
  echo "timestamp=$STAMP"
} | tee "$DIR/result.txt"

cat "$DIR/result.txt"
echo "Logs: $DIR/output.log"
exit "$STATUS"
