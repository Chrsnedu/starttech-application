#!/bin/bash

IMAGE=$1
REGION="us-east-1"
ACCOUNT_ID="327082974817"
REDIS_ENDPOINT="prod-redis.kmcqk2.0001.use1.cache.amazonaws.com"
ALLOWED_ORIGINS="http://localhost:5173,http://prod-starttech-frontend-d1581ec0.s3-website-us-east-1.amazonaws.com"

INSTANCE_IDS=$(aws ssm describe-instance-information \
  --region $REGION \
  --query "InstanceInformationList[*].InstanceId" \
  --output text)

aws ssm send-command \
  --instance-ids $INSTANCE_IDS \
  --document-name "AWS-RunShellScript" \
  --region $REGION \
  --parameters 'commands=[
    "MONGO_URI=$(aws ssm get-parameter --name /starttech/prod/mongo_uri --with-decryption --query Parameter.Value --output text --region '"$REGION"')",
    "JWT_SECRET=$(aws ssm get-parameter --name /starttech/prod/jwt_secret --with-decryption --query Parameter.Value --output text --region '"$REGION"')",
    "DB_NAME=$(aws ssm get-parameter --name /starttech/prod/db_name --query Parameter.Value --output text --region '"$REGION"')",

    "aws ecr get-login-password --region '"$REGION"' | docker login --username AWS --password-stdin '"$ACCOUNT_ID"'.dkr.ecr.'"$REGION"'.amazonaws.com",

    "docker system prune -af || true",
    "docker pull '"$IMAGE"'",

    "docker stop backend || true",
    "docker rm backend || true",

    "docker run -d --name backend -p 8080:8080 \
      -e PORT=8080 \
      -e MONGO_URI=$MONGO_URI \
      -e DB_NAME=$DB_NAME \
      -e JWT_SECRET_KEY=$JWT_SECRET \
      -e ENABLE_CACHE=true \
      -e REDIS_ADDR='"$REDIS_ENDPOINT"' \
      -e ALLOWED_ORIGINS='"$ALLOWED_ORIGINS"' \
      '"$IMAGE"'"
  ]'
