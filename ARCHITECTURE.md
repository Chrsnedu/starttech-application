# Application Architecture

## Overview

The application is split into a static frontend and a containerized backend:

- `frontend/` serves the user interface
- `backend/` serves the API

The frontend is published to an S3 website bucket. The backend runs on EC2 instances behind an Application Load Balancer.

## Frontend

- Built with React and Vite
- Bundled into static files during CI
- Hosted from the S3 website endpoint
- Uses `VITE_API_BASE_URL` to target the backend

The production frontend is expected to call:

- `http://prod-backend-alb-823465914.us-east-1.elb.amazonaws.com`

## Backend

- Built with Go and Gin
- Packaged as a Docker image
- Stored in ECR as `prod-starttech-backend`
- Started on EC2 by launch-template user-data and deployment scripts

At startup the backend reads:

- MongoDB URI from `/starttech/prod/mongo_uri`
- JWT secret from `/starttech/prod/jwt_secret`
- database name from `/starttech/prod/db_name`
- Redis host from `/starttech/prod/redis_host`

## Runtime Dependencies

- MongoDB Atlas for persistent application data
- ElastiCache Redis for optional cache support
- CloudWatch Logs for backend log collection

If MongoDB is unavailable, the backend process exits and the ALB returns `502` because targets cannot stay healthy.

## Health Model

- ALB target group health check: `/ping`
- dependency status endpoint: `/health`

`/ping` is used only to confirm the process is serving HTTP. `/health` is used to confirm backend dependencies such as MongoDB and Redis.

## Delivery Flow

1. Frontend CI builds `frontend/` and uploads `dist/` to S3.
2. Backend CI builds the image from `backend/` and pushes it to ECR.
3. Deployment scripts restart backend containers on the EC2 fleet.
4. The ALB only sends traffic to instances that pass `/ping`.
