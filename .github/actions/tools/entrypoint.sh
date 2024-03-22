#!/bin/bash

set -eu

KUSTOMIZE_VERSION="5.3.0"

mkdir -p $GITHUB_WORKSPACE/bin

curl -sL https://github.com/mikefarah/yq/releases/download/latest/yq_linux_amd64 -o yq

cp ./yq $GITHUB_WORKSPACE/bin
chmod +x $GITHUB_WORKSPACE/bin/yq

kustomize_url=https://github.com/kubernetes-sigs/kustomize/releases/download && \
curl -sL ${kustomize_url}/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz

cp ./kustomize $GITHUB_WORKSPACE/bin
chmod +x $GITHUB_WORKSPACE/bin/kustomize

curl -sL https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz | tar xz

cp ./kubeval $GITHUB_WORKSPACE/bin
chmod +x $GITHUB_WORKSPACE/bin/kubeval

echo "$GITHUB_WORKSPACE/bin" >> $GITHUB_PATH
echo "$RUNNER_WORKSPACE/$(basename $GITHUB_REPOSITORY)/bin" >> $GITHUB_PATH
