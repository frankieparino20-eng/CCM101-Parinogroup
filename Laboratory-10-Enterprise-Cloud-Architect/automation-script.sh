#!/bin/bash
set -e

BACKUP_DIR="/mnt/backup"
CONTAINER="ccm101-final-requirements-db-1"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/wordpress_$DATE.sql"
TEMP_FILE="$BACKUP_DIR/wordpress_tmp.sql"

if docker exec "$CONTAINER" sh -c 
'exec mysqldump --no-defaults -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --no-tablespaces wordpress' \

«"$TEMP_FILE"; then»

if [ -s "$TEMP_FILE" ]; then
    mv "$TEMP_FILE" "$BACKUP_FILE"
    echo "Backup successful: $BACKUP_FILE"
else
    echo "ERROR: Backup file is empty."
    rm -f "$TEMP_FILE"
    exit 1
fi

else
echo "ERROR: Database backup failed."
rm -f "$TEMP_FILE"
exit 1
fi
