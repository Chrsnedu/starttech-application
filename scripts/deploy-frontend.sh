#!/usr/bin/env bash
set -euo pipefail

# Fail fast when required deployment metadata has not been configured yet.
: "${FRONTEND_BUCKET_NAME:?FRONTEND_BUCKET_NAME is required}"
: "${CLOUDFRONT_DISTRIBUTION_ID:?CLOUDFRONT_DISTRIBUTION_ID is required}"

aws s3 sync Client/dist "s3://${FRONTEND_BUCKET_NAME}" --delete
aws cloudfront create-invalidation --distribution-id "${CLOUDFRONT_DISTRIBUTION_ID}" --paths "/*"
