#!/bin/bash

echo "🔧 Starting VaultHeist in development mode..."
echo ""

if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    exit 1
fi

if [ ! -d "node_modules" ]; then
    npm install
fi

npm run dev
