#!/bin/bash

echo "🚀 Installing VaultHeist Bot..."

sudo apt update -y
sudo apt install -y git curl nodejs npm

# install node if not present
if ! command -v node &> /dev/null; then
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
fi

# install deps
echo "📦 Installing packages..."
npm install

echo "✅ Install Complete!"
