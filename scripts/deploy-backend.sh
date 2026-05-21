#!/usr/bin/env bash
set -euo pipefail

# Update the image pointer first, then let ASG instance refresh replace hosts gradually.
: "${BACKEND_IMAGE_URI:?BACKEND_IMAGE_URI is required}"
: "${BACKEND_IMAGE_PARAMETER_NAME:?BACKEND_IMAGE_PARAMETER_NAME is required}"
: "${BACKEND_ASG_NAME:?BACKEND_ASG_NAME is required}"
: "${AWS_REGION:=us-east-1}"

aws ssm put-parameter \
  --name "${BACKEND_IMAGE_PARAMETER_NAME}" \
  --value "${BACKEND_IMAGE_URI}" \
  --type String \
  --overwrite \
  --region "${AWS_REGION}"

aws autoscaling start-instance-refresh \
  --auto-scaling-group-name "${BACKEND_ASG_NAME}" \
  --preferences '{"MinHealthyPercentage":50,"InstanceWarmup":120}' \
  --region "${AWS_REGION}"
