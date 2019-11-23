#!/usr/bin/env bash

set -euxo pipefail
IFS=$'\t\n'

exec docker run --rm \
  --mount type=tmpfs,destination=/var/lib/postgresql/data \
  -p 5433:5432 postgres:latest -c fsync=off
