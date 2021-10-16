#!/usr/bin/env bash

set -e

sed -i -E 's/(#)(max_prepared_transactions = )(0)(.*)/\220\4/' /var/lib/postgresql/data/postgresql.conf
