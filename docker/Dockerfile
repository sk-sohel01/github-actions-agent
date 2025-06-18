FROM ubuntu:22.04

# Install essential packages
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    lsb-release \
    unzip \
    git \
    python3 \
    python3-pip \
    docker.io && \
    apt-get clean

# Install kubectl
RUN curl -sSL https://dl.k8s.io/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Flux CLI (fixed path)
RUN curl -L https://github.com/fluxcd/flux2/releases/download/v2.2.3/flux_2.2.3_linux_amd64.tar.gz \
    -o flux.tar.gz && \
    tar -xzf flux.tar.gz && \
    mv flux /usr/local/bin/flux && \
    chmod +x /usr/local/bin/flux && \
    rm -rf flux.tar.gz

# Set working directory
WORKDIR /workspace

