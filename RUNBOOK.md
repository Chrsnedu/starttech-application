# Application Runbook

## Frontend Deploy

1. Confirm the frontend workflow completed successfully.
2. Verify the new bundle exists in `frontend/dist` before upload.
3. Confirm the S3 website bucket contains the latest `index.html` and hashed asset files.
4. Open the production frontend and confirm it is calling the expected backend base URL.

## Backend Deploy

1. Confirm the image was pushed to:
   `327082974817.dkr.ecr.us-east-1.amazonaws.com/prod-starttech-backend`
2. Confirm the deployment script or CI job is using AWS account `327082974817`.
3. Verify the backend instances are reachable through SSM.
4. Verify the ALB health-check endpoint is `/ping`.
5. Validate:
   - `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com/ping`
   - `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com/health`

## Useful Scripts

- `scripts/deploy-backend.sh <image-uri>`
- `scripts/health-check.sh <base-url>`
- `scripts/rollback.sh <image-uri-or-tag>`

## Common Failure Modes

### ALB returns `502`

Check:

- target group health in AWS
- local container status on the EC2 instances
- backend logs in `/starttech/backend`

Most common causes:

- backend process crashed during startup
- MongoDB connection failure
- wrong AWS account or profile used during deployment

### Backend health check never turns green

Check:

- the target group is using `/ping`, not `/health`
- the backend container is actually listening on `:8080`
- the current deployment credentials point to account `327082974817`

### MongoDB connection failure

Check:

- `/starttech/prod/mongo_uri` in SSM
- MongoDB Atlas network access rules
- TLS/connectivity errors in backend container logs

### Rollback

Use:

```bash
./scripts/rollback.sh <image-uri-or-tag>
```

This sends a command through SSM to restart the backend with the selected image.
