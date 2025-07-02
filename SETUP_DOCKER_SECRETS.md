# Setting up Docker Hub Secrets for GitHub Actions

## ⚠️ SECURITY NOTICE
Your Docker Hub token was exposed publicly. Please follow these steps immediately:

## Step 1: Regenerate Your Docker Hub Token
1. Go to https://hub.docker.com
2. Sign in with username: `baffoe6`
3. Navigate to: Account Settings → Security → Access Tokens
4. Find your existing token and **DELETE** it
5. Create a new token:
   - Click "New Access Token"
   - Name: "GitHub Actions"
   - Permissions: Read, Write, Delete
   - Copy the new token (it will look like: `dckr_pat_xxxxxxxxxxxxx`)

## Step 2: Add Secrets to GitHub Repository
1. Go to your GitHub repository: https://github.com/Baffoe6/Kubernetes-based-Microservices-with-CI-CD-Pipeline
2. Click **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add these two secrets:

### Secret 1:
- **Name**: `DOCKER_USERNAME`
- **Secret**: `baffoe6`

### Secret 2:
- **Name**: `DOCKER_PASSWORD`
- **Secret**: `[paste your NEW token here]`

## Step 3: Verify Setup
Once you've added the secrets, your GitHub Actions workflow will automatically use them to log in to Docker Hub.

## What Your Workflow Will Do
- Build Docker images for both services
- Push to Docker Hub as:
  - `baffoe6/users-service:latest`
  - `baffoe6/products-service:latest`

## Security Best Practices
- ✅ Never share tokens in plain text
- ✅ Use repository secrets for sensitive data
- ✅ Regenerate tokens periodically
- ✅ Use minimal required permissions
