#!/bin/bash -ex

docker run --rm -it -v $(pwd):/data cytopia/yamllint -c .yamllint.yml .

./validate.sh

./update-manifests.sh armhf
./update-manifests.sh x86
