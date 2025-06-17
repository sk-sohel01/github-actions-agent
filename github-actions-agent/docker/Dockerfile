FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl unzip gnupg2 software-properties-common lsb-release apt-transport-https \
    git docker.io python3 python3-pip \
    awscli azure-cli \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -s https://fluxcd.io/install.sh | bash

CMD ["bash"]
