# syntax=docker/dockerfile:1.4

ARG REGISTRY=""
FROM ${REGISTRY}debian:bookworm-slim

# Define build-time arguments
ARG TERRAFORM_VERSION
ARG VAULT_VERSION
ARG AWS_CLI_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites and add HashiCorp repo
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    lsb-release \
    unzip \
    git \
    jq \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Add HashiCorp GPG key and repository
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN set -eux; \
    apt-get update; \
    terraform_pkg="$(apt-cache madison terraform | awk -v ver="${TERRAFORM_VERSION}" '$3 ~ "^" ver"-" {print $3}' | sort -Vr | head -n1)"; \
    vault_pkg="$(apt-cache madison vault | awk -v ver="${VAULT_VERSION}" '$3 ~ "^" ver"-" {print $3}' | sort -Vr | head -n1)"; \
    echo "Resolved Terraform version: $terraform_pkg"; \
    echo "Resolved Vault version: $vault_pkg"; \
    apt-get install -y terraform="$terraform_pkg" vault="$vault_pkg"; \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --install-dir /opt/aws-cli --bin-dir /usr/local/bin && \
    rm -rf aws awscliv2.zip

# Create non-root user
RUN useradd -m -s /bin/bash iacuser
USER iacuser
WORKDIR /home/iacuser

CMD ["bash"]
