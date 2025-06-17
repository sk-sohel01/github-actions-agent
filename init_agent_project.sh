#!/bin/bash

set -e

PROJECT_NAME="github-actions-agent"
echo "Creating project structure: $PROJECT_NAME"

# Create directories
mkdir -p $PROJECT_NAME/.github/workflows
mkdir -p $PROJECT_NAME/docker
mkdir -p $PROJECT_NAME/scripts

# Create README
cat <<EOF > $PROJECT_NAME/README.md
# GitHub Actions Custom Agent

This repository contains a custom Docker-based GitHub Actions runner with tools like kubectl, helm, awscli, etc.
EOF

# Create .gitignore
cat <<EOF > $PROJECT_NAME/.gitignore
__pycache__/
*.pyc
*.log
*.env
EOF

# Create Dockerfile
cat <<EOF > $PROJECT_NAME/docker/Dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \\
    curl unzip gnupg2 software-properties-common lsb-release apt-transport-https \\
    git docker.io python3 python3-pip \\
    awscli azure-cli \\
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://dl.k8s.io/release/\$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \\
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -s https://fluxcd.io/install.sh | bash

CMD ["bash"]
EOF

# Create GitHub Actions workflow
cat <<EOF > $PROJECT_NAME/.github/workflows/build-agent.yml
name: Build and Push Custom GitHub Runner

on:
  push:
    branches: [main]

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    permissions:
      packages: write
      contents: read

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Log in to GHCR
        run: echo "\${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u \${{ github.actor }} --password-stdin

      - name: Build Docker Image
        run: docker build -t ghcr.io/\${{ github.repository_owner }}/gha-agent:latest -f docker/Dockerfile .

      - name: Push to GHCR
        run: docker push ghcr.io/\${{ github.repository_owner }}/gha-agent:latest
EOF

# Create dummy install_tools.sh
cat <<EOF > $PROJECT_NAME/scripts/install_tools.sh
#!/bin/bash
echo "Tool installer placeholder (kubectl, helm, awscli, etc)"
EOF
chmod +x $PROJECT_NAME/scripts/install_tools.sh

echo "✅ Project scaffold created at: $PROJECT_NAME"
tree $PROJECT_NAME

