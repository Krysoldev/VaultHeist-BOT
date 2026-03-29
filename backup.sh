#!/bin/bash

BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

if [ -f "src/data/users.json" ]; then
    cp src/data/users.json "$BACKUP_DIR/users_$TIMESTAMP.json"
    echo "✅ Users data backed up to $BACKUP_DIR/users_$TIMESTAMP.json"
fi

if [ -f "src/data/logs.txt" ]; then
    cp src/data/logs.txt "$BACKUP_DIR/logs_$TIMESTAMP.txt"
    echo "✅ Logs backed up to $BACKUP_DIR/logs_$TIMESTAMP.txt"
fi

echo "📦 Creating full backup archive..."
tar -czf "$BACKUP_DIR/vaultheist_backup_$TIMESTAMP.tar.gz" src/data/ .env

echo "✅ Full backup created: $BACKUP_DIR/vaultheist_backup_$TIMESTAMP.tar.gz"
echo ""
echo "Recent backups:"
ls -lh $BACKUP_DIR/
