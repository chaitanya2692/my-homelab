#!/bin/bash -ex

docker run --rm -it -v $(pwd):/data cytopia/yamllint -c .yamllint.yml .

./scripts/validate.sh

./scripts/update-manifests.sh armhf
./scripts/update-manifests.sh x86
