#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/"

./demo.sh > README.md 2>&1
