#!/usr/bin/env bash
set -eu

# my .env file path
ENV_FILE="/opt/shvirtd-example-python/.env"

# just read .env to context
source "$ENV_FILE"

BACKUP_DIR="/opt/backup"
NETWORK="shvirtd-example-python_backend"
DATE_TIME=$(date +"%Y%m%d_%H%M%S")
FILENAME="${MYSQL_DATABASE}_${DATE_TIME}.sql"

sudo mkdir -p $BACKUP_DIR
sudo chown -R ijin:ijin $BACKUP_DIR

# --entrypoint "" — claer entrypoint to run mysqldump
# --result-file — dump file
# newtork from docker network ls
# Screenshot: 05-virt-04-docker-in-practice/Screenshots/Yandex VM stats network 2026-09-28 21-27-39.png
docker run --rm \
  --network "$NETWORK" \
  -v "$BACKUP_DIR:/backup" \
  --entrypoint "" \
  schnitzler/mysqldump \
  mysqldump --default-auth=mysql_native_password --opt -u "$MYSQL_USER" -h "${MYSQL_HOST:-db}" \
    -p"$MYSQL_PASSWORD" --result-file="/backup/$FILENAME" $MYSQL_DATABASE --no-tablespaces

echo "Done. Backup: $BACKUP_DIR/$FILENAME"
