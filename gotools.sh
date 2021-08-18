#! /bin/bash

# Install Go tools that are isImportant && !replacedByGopls based on
# https://github.com/golang/vscode-go/blob/0c6dce4a96978f61b022892c1376fe3a00c27677/src/goTools.ts#L188
# exception: golangci-lint is installed using their install script below.
set -e

INSTALL_GO_TOOLS=${1:-"true"}
TARGET_GOROOT=${2:-"/usr/local/go"}
TARGET_GOPATH=${3:-"/go"}
USERNAME=golang

GO_TOOLS="\
    golang.org/x/tools/gopls"
    #  \
    # honnef.co/go/tools/... \
    # golang.org/x/lint/golint \
    # github.com/mgechev/revive \
    # github.com/uudashr/gopkgs/v2/cmd/gopkgs \
    # github.com/ramya-rao-a/go-outline \
    # github.com/go-delve/delve/cmd/dlv \
    # github.com/golangci/golangci-lint/cmd/golangci-lint \
    # golang.org/x/net/html
    # "
if [ "${INSTALL_GO_TOOLS}" = "true" ]; then
    echo "Installing common Go tools..."
    export PATH=${TARGET_GOROOT}/bin:${PATH}
    mkdir -p /tmp/gotools /usr/local/etc/vscode-dev-containers ${TARGET_GOPATH}/bin
    cd /tmp/gotools
    export GOPATH=/tmp/gotools
    export GOCACHE=/tmp/gotools/cache

    # Go tools w/module support
    export GO111MODULE=on
    (echo "${GO_TOOLS}" | xargs -n 1 go get -v )2>&1 | tee -a /usr/local/etc/vscode-dev-containers/go.log

    # Move Go tools into path and clean up
    mv /tmp/gotools/bin/* ${TARGET_GOPATH}/bin/
    rm -rf /tmp/gotools
    chown -R ${USERNAME} "${TARGET_GOPATH}"
fi