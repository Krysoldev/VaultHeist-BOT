#!/bin/bash

echo "🔧 Fixing Bot..."

rm -rf node_modules package-lock.json

npm install

echo "🔄 Updating files..."
git reset --hard
git pull

echo "✅ Fix Completed!"
