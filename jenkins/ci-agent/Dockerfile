FROM moby/buildkit:rootless AS buildkit

FROM jenkins/inbound-agent:latest-jdk17

USER root
ENV DEBIAN_FRONTEND=noninteractive \
    BUILDKIT_VERSION=v0.23.1 \
    HELM_VERSION=v3.18.4 \
    KUBECTL_VERSION=v1.31.11

RUN set -e; \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        git curl ca-certificates jq unzip tar gzip \
        python3 python3-pip python3-venv \
        runc uidmap slirp4netns fuse-overlayfs && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
     -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
     | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64

RUN curl -L "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip" \
     -o /tmp/sonar.zip && \
    unzip /tmp/sonar.zip -d /opt && \
    ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /tmp/sonar.zip

COPY --from=buildkit /usr/bin/buildctl               /usr/local/bin/
COPY --from=buildkit /usr/bin/buildkitd              /usr/local/bin/
COPY --from=buildkit /usr/bin/buildctl-daemonless.sh /usr/local/bin/buildctl-daemonless
COPY --from=buildkit /usr/bin/rootlesskit            /usr/local/bin/

ENV XDG_RUNTIME_DIR=/tmp/xdg-runtime
RUN mkdir -p $XDG_RUNTIME_DIR && chown jenkins:jenkins $XDG_RUNTIME_DIR && \
    chmod 700 $XDG_RUNTIME_DIR && \
    chmod +x /usr/local/bin/buildctl-daemonless

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
