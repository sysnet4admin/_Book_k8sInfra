#!/usr/bin/env bash

VERSION=v5.8.1

if [[ "$OSTYPE" == linux* ]]; then
  OS=linux
elif [[ "$OSTYPE" == darwin* ]]; then
  OS=darwin
fi

case $(uname -m) in
x86_64)
    ARCH=amd64
    ;;
arm64|aarch64)
    ARCH=arm64
    ;;
ppc64le)
    ARCH=ppc64le
    ;;
s390x)
    ARCH=s390x
    ;;
*)
    ARCH=amd64
    ;;
esac

DOWNLOAD_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/kustomize_${VERSION}_${OS}_${ARCH}.tar.gz"

curl -L $DOWNLOAD_URL -o /tmp/kustomize.tar.gz
tar -xzf /tmp/kustomize.tar.gz -C  /usr/local/bin
echo "kustomize installed successfully"
