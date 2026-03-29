#!/bin/bash

echo "🎮 Starting VaultHeist Discord Bot..."
echo ""

if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please create .env file with your bot credentials"
    exit 1
fi

if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "✅ Bot is starting..."
npm start
