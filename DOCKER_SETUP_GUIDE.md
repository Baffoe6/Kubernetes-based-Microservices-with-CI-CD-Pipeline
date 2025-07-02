# Docker Registry Setup Guide

## Option 1: Docker Hub Setup (Recommended)

### Step 1: Create Docker Hub Account
1. Go to https://hub.docker.com
2. Sign up for a free account
3. Verify your email address

### Step 2: Create Access Token
1. Log in to Docker Hub
2. Go to Account Settings → Security → Access Tokens
3. Click "New Access Token"
4. Name: `GitHub Actions`
5. Copy the generated token (save it securely!)

### Step 3: Add GitHub Secrets
1. Go to your GitHub repository: https://github.com/Baffoe6/Kubernetes-based-Microservices-with-CI-CD-Pipeline
2. Click `Settings` → `Secrets and variables` → `Actions`
3. Click `New repository secret` and add:
   - Name: `DOCKER_USERNAME`
   - Value: Your Docker Hub username
4. Click `New repository secret` and add:
   - Name: `DOCKER_PASSWORD` 
   - Value: The access token from Step 2

### Step 4: Test the Pipeline
After adding the secrets, push a commit to trigger the CI/CD pipeline.

## Option 2: GitHub Container Registry (Alternative)

If you prefer using GitHub's container registry instead of Docker Hub:

### Benefits:
- Integrated with GitHub
- No separate account needed
- Better integration with GitHub Actions

### Required Changes:
- Update workflow to use `ghcr.io` registry
- Use `GITHUB_TOKEN` instead of Docker Hub credentials
- Images will be stored at `ghcr.io/yourusername/imagename`

## Current Workflow Status
- ✅ Tests are working for both services
- ❌ Docker build/push failing due to missing credentials
- ✅ Security scanning configured
- ✅ Staging/production deployment configured

## Next Steps
1. Choose Option 1 (Docker Hub) or Option 2 (GitHub Container Registry)
2. Follow the setup steps above
3. Test the pipeline by pushing a commit
