# StartTech Application Delivery

This repository contains the full-stack application and the CI/CD workflows that deliver it. The current source layout is preserved as `Client/` for the React frontend and `Server/MuchToDo/` for the Go API, while the new `frontend/` and `backend/` directories hold deployment assets required by the assessment.

## CI/CD Pipelines

- `frontend-ci-cd.yml`: installs dependencies, runs validation tests, builds the React app, audits packages, syncs to S3, and invalidates CloudFront.
- `backend-ci-cd.yml`: runs Go tests, security scans, builds a Docker image, scans it with Trivy, pushes it to ECR, triggers an Auto Scaling rolling deployment, and runs smoke tests.

## Required GitHub Secrets And Variables

- `AWS_GITHUB_ROLE_ARN`
- `vars.AWS_REGION`
- `vars.VITE_API_BASE_URL`
- `vars.FRONTEND_BUCKET_NAME`
- `vars.CLOUDFRONT_DISTRIBUTION_ID`
- `vars.ECR_REPOSITORY`
- `vars.BACKEND_IMAGE_PARAMETER_NAME`
- `vars.BACKEND_ASG_NAME`
- `vars.BACKEND_HEALTH_URL`

## Application Configuration

- Frontend production URL override: `Client/.env.production.example`
- Backend environment template: `Server/MuchToDo/.env.example`
- MongoDB should point to your Atlas cluster.
- Redis should point to the ElastiCache primary endpoint from the infrastructure outputs.

## Local Workflow

1. Configure `Server/MuchToDo/.env` from the example file.
2. Set `Client/.env.production` or local Vite env values as needed.
3. Run the frontend from `Client/` with `npm install` and `npm run dev`.
4. Run the backend from `Server/MuchToDo/` with `go run ./cmd/api/main.go`.
