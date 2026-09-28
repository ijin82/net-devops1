#!/usr/bin/env bash
# -e - exit on error
# -u - error on non-initialized var usage
set -eu

## vars
REPO_URL="https://github.com/ijin82/shvirtd-example-python.git"
PROJECT_DIR="/opt/shvirtd-example-python"
REPO_NAME="shvirtd-example-python"


# /opt - check/setup
if [[ ! -d "$PROJECT_DIR" ]]; then
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R ijin:ijin $PROJECT_DIR
fi

cd "$PROJECT_DIR"

if [[ ! -d ".git" ]]; then
    git clone $REPO_URL .
else
    git pull origin main
fi

# no error here on clean setup returns 0
docker compose down -t 0

# start compose
docker compose up -d --build

# show ps
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"

echo "Done. Ready to go. " `date`
