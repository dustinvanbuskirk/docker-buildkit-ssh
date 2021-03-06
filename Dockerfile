# syntax=docker/dockerfile:experimental
ARG TERRAFORM_VERSION
FROM hashicorp/terraform:${TERRAFORM_VERSION}
RUN apk --update add jq unzip postgresql-client openssh-client && \
    curl -fsS "https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip" | funzip > /bin/vault
RUN chmod +x /bin/vault
# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
WORKDIR /src
COPY . .
WORKDIR /src/terraform
RUN --mount=type=ssh terraform init
