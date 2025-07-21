FROM jenkins/inbound-agent:latest-jdk17

USER root
ENV DEBIAN_FRONTEND=noninteractive \
    BUILDKIT_VERSION=v0.23.1 \
    HELM_VERSION=v3.18.4 \
    KUBECTL_VERSION=v1.31.11

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git curl ca-certificates jq unzip tar gzip && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
     -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
     | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64

RUN curl -L "https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz" \
     | tar xz -C /usr/local && \
    ln -s /usr/local/bin/buildctl /usr/bin/buildctl

RUN curl -L "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip" \
     -o /tmp/sonar.zip && \
    unzip /tmp/sonar.zip -d /opt && \
    ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /tmp/sonar.zip

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
