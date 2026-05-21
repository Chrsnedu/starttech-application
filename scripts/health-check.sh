#!/usr/bin/env bash
set -euo pipefail

# Poll the health endpoint a few times because the ALB may need a short warm-up window.
: "${BACKEND_HEALTH_URL:?BACKEND_HEALTH_URL is required}"

for attempt in {1..10}; do
  if curl --fail --silent --show-error "${BACKEND_HEALTH_URL}" >/dev/null; then
    echo "Health check passed on attempt ${attempt}."
    exit 0
  fi

  echo "Health check failed on attempt ${attempt}; retrying in 15 seconds."
  sleep 15
done

echo "Health check never succeeded."
exit 1
