# StartTech Application

This repository contains the application code and delivery workflows for the StartTech stack.

The active source layout is:

- `frontend/`: React + Vite single-page app
- `backend/`: Go + Gin API
- `scripts/`: deployment, health-check, and rollback helpers
- `.github/workflows/`: CI/CD pipelines

This repository is intended to deploy into the production AWS account `327082974817`.

## Production Endpoints

- Frontend website: `http://prod-starttech-frontend-d1581ec0.s3-website-us-east-1.amazonaws.com`
- Backend ALB: `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com`

## Deployment Model

- The frontend pipeline builds the app from `frontend/` and uploads the static bundle to the S3 website bucket.
- The backend pipeline builds a Docker image from `backend/`, pushes it to ECR, and rolls the EC2 Auto Scaling Group.
- Runtime secrets and connection settings are read from AWS Systems Manager Parameter Store.
- Infrastructure is managed from the companion `starttech-infra` repository.

## Required AWS Resources

These values are supplied by the infrastructure stack:

- ECR repository: `327082974817.dkr.ecr.us-east-1.amazonaws.com/prod-starttech-backend`
- Frontend bucket: `prod-starttech-frontend-d1581ec0`
- Backend log group: `/starttech/backend`
- Redis endpoint: `prod-redis.kmcqk2.0001.use1.cache.amazonaws.com`

## Required GitHub Configuration

Secrets:

- `AWS_GITHUB_ROLE_ARN`

Variables:

- `AWS_REGION`
- `VITE_API_BASE_URL`
- `FRONTEND_BUCKET_NAME`
- `ECR_REPOSITORY`
- `BACKEND_HEALTH_URL`

## Required SSM Parameters

The backend expects these production parameters:

- `/starttech/prod/mongo_uri`
- `/starttech/prod/jwt_secret`
- `/starttech/prod/db_name`
- `/starttech/prod/redis_host`

## Local Development

Frontend:

```bash
cd frontend
npm install
npm run dev
```

Backend:

```bash
cd backend
go run ./cmd/api/main.go
```

If you are running AWS commands locally for this project, use the production profile:

```bash
export AWS_PROFILE="krist"
aws sts get-caller-identity
```

The returned account should be `327082974817`.
