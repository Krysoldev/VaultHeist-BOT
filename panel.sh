#!/bin/bash

# COLORS (FIXED)
CYAN="\e[1;36m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
BLUE="\e[38;5;33m"
NC="\e[0m"

APP_NAME="vaultheist"
DIR="$HOME/VaultHeist-BOT"

# CENTER FUNCTION
center() {
  cols=$(tput cols)
  text="$1"
  printf "%*s\n" $(((${#text}+cols)/2)) "$text"
}

# TYPEWRITER
typewriter() {
  for ((i=0; i<${#1}; i++)); do
    echo -ne "${1:$i:1}"
    sleep 0.003
  done
  echo ""
}

# HEADER
header() {
clear
echo ""
center "${CYAN}⚡ KRYsol Dashboard ⚡${NC}"
center "────────────────────────────"
echo ""

# CLEAN LOGO
echo -e "${BLUE}"
center "██╗  ██╗██████╗ ██╗   ██╗"
center "██║ ██╔╝██╔══██╗╚██╗ ██╔╝"
center "█████╔╝ ██████╔╝ ╚████╔╝ "
center "██╔═██╗ ██╔══██╗  ╚██╔╝  "
center "██║  ██╗██║  ██║   ██║   "
center "╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${NC}"

echo ""
typewriter "🔐 Initializing..."
typewriter "⚡ Loading modules..."
typewriter "🚀 Ready"
echo ""
}

# DASHBOARD
dashboard() {

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
UPTIME=$(uptime -p | cut -d " " -f2-)

center "────────────────────────────"
center "HOST: Krysol | $UPTIME"
center "STATUS: ONLINE"
center "────────────────────────────"

echo ""
center "CPU: $CPU% | RAM: $RAM% | NET: OK"
echo ""

# MENU (PROPER ALIGN)
center "[1] Install     [5] Start"
center "[2] Configure   [6] Stop"
center "[3] Fix         [7] Status"
center "[4] Repair      [8] Delete"

echo ""
center "[0] Exit"

echo ""
printf "${YELLOW}"
center "➤ Select Option:"
printf "${NC}"
}

# ================= FUNCTIONS =================

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
rm -rf "$DIR"
pm2 delete $APP_NAME 2>/dev/null
fi
}

# LOOP
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
