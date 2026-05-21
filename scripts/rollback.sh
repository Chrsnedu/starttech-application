#!/usr/bin/env bash
set -euo pipefail

# Roll back by restoring the last known-good container image tag in SSM.
: "${PREVIOUS_BACKEND_IMAGE_URI:?PREVIOUS_BACKEND_IMAGE_URI is required}"
: "${BACKEND_IMAGE_PARAMETER_NAME:?BACKEND_IMAGE_PARAMETER_NAME is required}"
: "${BACKEND_ASG_NAME:?BACKEND_ASG_NAME is required}"
: "${AWS_REGION:=us-east-1}"

aws ssm put-parameter \
  --name "${BACKEND_IMAGE_PARAMETER_NAME}" \
  --value "${PREVIOUS_BACKEND_IMAGE_URI}" \
  --type String \
  --overwrite \
  --region "${AWS_REGION}"

aws autoscaling start-instance-refresh \
  --auto-scaling-group-name "${BACKEND_ASG_NAME}" \
  --preferences '{"MinHealthyPercentage":50,"InstanceWarmup":120}' \
  --region "${AWS_REGION}"
