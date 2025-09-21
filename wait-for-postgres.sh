#!/bin/sh
# wait-for-postgres.sh

set -e

host="$1"
shift
cmd="$@"

until pg_isready -h "$host" -p 5432; do
  echo "Waiting for PostgreSQL at $host:5432..."
  sleep 1
done

echo "PostgreSQL is ready!"
exec $cmd
