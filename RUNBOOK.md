# Application Runbook

## Frontend Deployment

- Confirm the `frontend-ci-cd.yml` workflow completed successfully.
- Check that the build uploaded to the expected S3 bucket.
- Verify the uploaded build contains `index.html` and the latest hashed assets before testing the UI.

## Backend Deployment

- Confirm the image was pushed to the expected ECR repository.
- Check the Auto Scaling instance refresh state in AWS.
- Validate `BACKEND_HEALTH_URL` returns `200`.
- Validate `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com/health` reports dependency status after rollout.
- Review the `/aws/ec2/starttech-prod/backend` log group for startup or dependency errors.

## Rollback

Run `scripts/rollback.sh` with the previous good image URI, the backend image SSM parameter name, and the ASG name. That updates the deployment pointer and triggers a fresh rolling refresh.

## Common Failure Modes

- Frontend deploy fails: the bucket identifier or `VITE_API_BASE_URL` is missing from GitHub repository variables.
- Backend image push fails: the OIDC role does not have ECR permissions.
- Backend never becomes healthy: verify the MongoDB Atlas URI is present in SSM and that Redis and the ALB security groups are correct.
