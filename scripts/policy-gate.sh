#!/usr/bin/env bash
set -euo pipefail
PLAN_JSON="${1:-terraform/plan.json}"
conftest test "$PLAN_JSON" -p policies
