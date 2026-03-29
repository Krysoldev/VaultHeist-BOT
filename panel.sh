#!/bin/bash

# COLORS
BLUE='\033[38;5;33m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
NC='\033[0m'

DIR="$HOME/VaultHeist-BOT"
APP_NAME="vaultheist"

# CENTER
center() {
cols=$(tput cols)
text="$1"
printf "%*s\n" $(((${#text}+cols)/2)) "$text"
}

# ==============================
# 🎬 NEW UI HEADER
# ==============================
header() {
clear

echo ""
center "${CYAN}⚡ KRYsol Dashboard ⚡${NC}"
center "──────────────────────────────"

echo ""

# logo (clean small)
echo -e "${BLUE}"
center "██╗  ██╗██████╗ ██╗   ██╗"
center "██║ ██╔╝██╔══██╗╚██╗ ██╔╝"
center "█████╔╝ ██████╔╝ ╚████╔╝ "
center "██╔═██╗ ██╔══██╗  ╚██╔╝  "
center "██║  ██╗██║  ██║   ██║   "
center "╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${NC}"

echo ""
center "🚀 System Ready"
echo ""
}

# ==============================
# 📊 DASHBOARD
# ==============================
dashboard() {

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
UPTIME=$(uptime -p | cut -d " " -f2-)

center "──────────────────────────────"
center "HOST: Krysol | $UPTIME | ONLINE"
center "──────────────────────────────"

echo ""
center "CPU: $CPU% | RAM: $RAM% | NET: OK"

echo ""

# menu (clean list style)
center "[1] Install Bot"
center "[2] Configure Bot"
center "[3] Fix Bot"
center "[4] Repair System"
center "[5] Start Bot"
center "[6] Stop Bot"
center "[7] Status"
center "[8] Delete Bot"

echo ""
center "[0] Exit"

echo ""
echo -ne "${YELLOW}"
center "➤ Enter option: "
echo -ne "${NC}"
}

# ==============================
# ⚙️ FUNCTIONS
# ==============================
install_bot() {
sudo apt update -y
sudo apt install -y nodejs npm git curl
npm install
sudo npm install -g pm2
}

configure_bot() {
read -p "TOKEN: " TOKEN
read -p "CLIENT ID: " CLIENT_ID

cat > .env <<EOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
EOF
}

fix_bot() {
rm -rf node_modules package-lock.json
npm install
git reset --hard
git pull
}

start_bot() {
pm2 delete $APP_NAME 2>/dev/null
pm2 start index.js --name $APP_NAME
pm2 save
}

stop_bot() {
pm2 stop $APP_NAME
}

status_bot() {
pm2 list
read
}

delete_bot() {
echo "Type DELETE:"
read confirm
if [ "$confirm" = "DELETE" ]; then
rm -rf "$HOME/VaultHeist-BOT"
pm2 delete $APP_NAME 2>/dev/null
fi
}

# ==============================
# 🔁 LOOP
# ==============================
while true; do
header
dashboard

read choice

case "$choice" in
1) install_bot ;;
2) configure_bot ;;
3) fix_bot ;;
4) fix_bot ;;
5) start_bot ;;
6) stop_bot ;;
7) status_bot ;;
8) delete_bot ;;
0) exit ;;
*) echo "Invalid"; sleep 1 ;;
esac

done
