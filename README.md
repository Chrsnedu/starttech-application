# StartTech Application Delivery

This repository contains the full-stack application and the CI/CD workflows that deliver it. The source layout is `Client/` for the React frontend and `Server/MuchToDo/` for the Go API.

## CI/CD Pipelines

- `frontend-ci-cd.yml`: installs dependencies, runs validation tests, builds the React app, audits packages, and syncs the static build to the production S3 website bucket.
- `backend-ci-cd.yml`: runs Go tests, security scans, builds a Docker image, scans it with Trivy, pushes it to ECR, triggers an Auto Scaling rolling deployment, and runs smoke tests.

## Required GitHub Secrets And Variables

- `AWS_GITHUB_ROLE_ARN`
- `vars.AWS_REGION`
- `vars.VITE_API_BASE_URL`
- `vars.FRONTEND_BUCKET_NAME`
- `vars.ECR_REPOSITORY`
- `vars.BACKEND_IMAGE_PARAMETER_NAME`
- `vars.BACKEND_ASG_NAME`
- `vars.BACKEND_HEALTH_URL`

## Application Configuration

- Frontend production URL override: `Client/.env.production.example`
- Backend environment template: `Server/MuchToDo/.env.example`
- MongoDB should point to your Atlas cluster.
- Redis should point to the ElastiCache primary endpoint from the infrastructure outputs.
- Production frontend origin: `http://prod-starttech-frontend-d1581ec0.s3-website-us-east-1.amazonaws.com`
- Production backend base URL: `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com`

## Local Workflow

1. Configure `Server/MuchToDo/.env` from the example file.
2. Set `Client/.env.production` or local Vite env values as needed.
3. Run the frontend from `Client/` with `npm install` and `npm run dev`.
4. Run the backend from `Server/MuchToDo/` with `go run ./cmd/api/main.go`.
