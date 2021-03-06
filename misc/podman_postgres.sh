#!/usr/bin/env bash

set -euxo pipefail
IFS=$'\t\n'

exec podman run --rm \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  --mount type=tmpfs,tmpfs-size=512M,destination=/var/lib/postgresql/data \
  --label postgres=true \
  -p 5433:5432 postgres:9.6 -c fsync=off
