#!/bin/bash

set -eu

mkdir -p $GITHUB_WORKSPACE/bin

#Install yq
curl -sL https://github.com/mikefarah/yq/releases/download/latest/yq_linux_amd64 -o /bin
chmod +x $GITHUB_WORKSPACE/bin
yq -V

#Install Kustomize
curl -sL "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
cp kustomize $GITHUB_WORKSPACE/bin
kustomize version

#Install Kubeval
wget -qO- https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz | tar xvz
cp kubeval $GITHUB_WORKSPACE/bin
kubeval --version

echo "$GITHUB_WORKSPACE/bin" >> $GITHUB_PATH
echo "$RUNNER_WORKSPACE/$(basename $GITHUB_REPOSITORY)/bin" >> $GITHUB_PATH
