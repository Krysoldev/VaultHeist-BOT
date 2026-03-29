#!/bin/bash

echo "🚀 Setting up VaultHeist Discord Bot..."
echo ""

echo "📦 Installing dependencies..."
npm install

echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the bot:"
echo "  npm start"
echo ""
echo "To run with PM2 (recommended):"
echo "  npm install -g pm2"
echo "  pm2 start index.js --name VaultHeist"
echo "  pm2 save"
echo "  pm2 startup"
echo ""
echo "Make sure to edit the .env file with your bot token and IDs!"
