#!/usr/bin/env bash

set -euxo pipefail

terraform output json | jq "."
