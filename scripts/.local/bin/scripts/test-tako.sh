#!/usr/bin/env bash

# Credits to Chris <3

# Helpful wrapper script for testing tako storage work. Run in tako repo root.
# Example: ./tako-test ./internals/overlord/storagestate [Reshape]
#
# Essentially a wrapper for the following command
# go test ./internals/daemon/ -v -check.v -check.f Reshape

TEST_DIR="$1"
TEST_REGEX=""
GOFLAGS="-tags=exclude_graphdriver_btrfs,containers_image_openpgp"

# Tako setup doesn't support plain "go test" at the time of writing.
if [[ -z "$TEST_DIR" ]]; then
    echo "pass dir to test please"
    exit 1
fi

if [[ -n "$2" ]]; then
    TEST_REGEX="-check.f $2"
fi

set -eux

go clean -testcache
GOFLAGS=$GOFLAGS TZ=UTC go test $TEST_DIR -v -check.v $TEST_REGEX -skip=^Fuzz -coverprofile coverage.out; go tool cover -html=coverage.out -o coverage.html
