# Application Architecture

## Frontend

- Built with React and Vite.
- Compiled into static assets and deployed to S3.
- Served from the S3 static website endpoint.
- Reads the backend base URL from `VITE_API_BASE_URL`.

## Backend

- Built with Go and Gin.
- Packaged as a container image and stored in Amazon ECR.
- Deployed to EC2 instances managed by an Auto Scaling Group behind an ALB.
- Uses MongoDB Atlas for persistence and Redis for cache acceleration when available.
- Emits structured logs to stdout so the EC2 Docker runtime can ship them to CloudWatch.

## Deployment Topology

- GitHub Actions is the control plane for CI/CD.
- Terraform provisions the durable AWS infrastructure in the companion `starttech-infra` repository.
- Application deployments are decoupled from infrastructure changes by using SSM Parameter Store as the image pointer for the backend rollout.
