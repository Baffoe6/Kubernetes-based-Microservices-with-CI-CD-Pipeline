#!/bin/bash

# GitHub Repository Secrets Setup Script
# This script provides instructions for setting up Docker Hub secrets

echo "🔧 Setting up GitHub Repository Secrets for Docker Hub"
echo "========================================================="
echo ""

echo "⚠️  IMPORTANT SECURITY NOTICE:"
echo "Your Docker Hub token was shared publicly and should be regenerated immediately!"
echo ""

echo "📋 Follow these steps:"
echo ""

echo "1️⃣  REGENERATE YOUR DOCKER HUB TOKEN:"
echo "   • Go to: https://hub.docker.com"
echo "   • Login with username: baffoe6"
echo "   • Go to: Account Settings → Security → Access Tokens"
echo "   • DELETE the existing token"
echo "   • Create new token with name: 'GitHub Actions'"
echo "   • Copy the new token (starts with dckr_pat_)"
echo ""

echo "2️⃣  ADD SECRETS TO GITHUB REPOSITORY:"
echo "   • Go to: https://github.com/Baffoe6/Kubernetes-based-Microservices-with-CI-CD-Pipeline"
echo "   • Click: Settings → Secrets and variables → Actions"
echo "   • Add these repository secrets:"
echo ""
echo "   Secret Name: DOCKER_USERNAME"
echo "   Secret Value: baffoe6"
echo ""
echo "   Secret Name: DOCKER_PASSWORD"
echo "   Secret Value: [paste your NEW token here]"
echo ""

echo "3️⃣  VERIFY SETUP:"
echo "   • Commit and push changes to trigger CI/CD"
echo "   • Check GitHub Actions tab for successful build"
echo "   • Verify images appear in Docker Hub: https://hub.docker.com/u/baffoe6"
echo ""

echo "✅ Your Docker images will be published as:"
echo "   • baffoe6/users-service:latest"
echo "   • baffoe6/products-service:latest"
echo ""

echo "🔒 Security reminders:"
echo "   • Never share tokens in plain text"
echo "   • Regenerate tokens periodically"
echo "   • Use repository secrets for all sensitive data"
