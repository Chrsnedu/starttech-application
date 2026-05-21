# Backend Delivery Assets

The production API source remains in `Server/MuchToDo/` so the existing Go module and imports stay intact.

This directory contains deployment-facing assets for the assessment:

- `Dockerfile`: builds the Go API into a hardened non-root container image.
- `.dockerignore`: keeps the Docker build context small and avoids leaking local environment files.
