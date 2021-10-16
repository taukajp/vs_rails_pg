#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOF
  SELECT 'CREATE USER docker CREATEDB' WHERE NOT EXISTS (SELECT usename FROM pg_user WHERE usename = 'docker')\gexec
  SELECT 'CREATE DATABASE myappdb WITH OWNER docker' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'myappdb')\gexec
  GRANT ALL PRIVILEGES ON DATABASE myappdb TO docker;
EOF
