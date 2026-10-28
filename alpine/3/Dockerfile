# syntax=docker/dockerfile:1.4
ARG REGISTRY=""
FROM ${REGISTRY}alpine:3.19

ARG TERRAFORM_VERSION
ARG VAULT_VERSION
ARG AWS_CLI_VERSION

ENV PATH="/root/.local/bin:$PATH" \
    TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    VAULT_VERSION=${VAULT_VERSION} \
    AWS_CLI_VERSION=${AWS_CLI_VERSION}

RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    unzip \
    python3 \
    py3-pip \
    gnupg

COPY ./install-hashicorp.sh /usr/local/bin/install-hashicorp
RUN chmod +x /usr/local/bin/install-hashicorp && \
    install-hashicorp terraform ${TERRAFORM_VERSION} && \
    install-hashicorp vault ${VAULT_VERSION}

RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli && \
    rm -rf aws awscliv2.zip

CMD ["/bin/bash"]
