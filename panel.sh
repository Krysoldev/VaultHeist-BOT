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
REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
APP_NAME="vaultheist"

# CENTER
center() {
    cols=$(tput cols)
    text="$1"
    printf "%*s\n" $(((${#text}+cols)/2)) "$text"
}

# ==============================
# 🎬 CLEAN BANNER
# ==============================
banner() {
clear

# TITLE
echo ""
center "⚡ K R Y S O L   D A S H B O A R D ⚡"
echo ""

# BORDER TOP
center "╭──────────────────────────────────────╮"

# LOGO
echo -e "${BLUE}"
center " ██╗  ██╗██████╗ ██╗   ██╗███████╗"
center " ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝"
center " █████╔╝ ██████╔╝ ╚████╔╝ ███████╗"
center " ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║"
center " ██║  ██╗██║  ██║   ██║   ███████║"
center " ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝"
echo -e "${NC}"

# BORDER BOTTOM
center "╰──────────────────────────────────────╯"

echo ""

# STATUS TEXT
echo -e "${CYAN}"
center "🔐 Initializing secure environment..."
center "⚡ Loading modules..."
center "🚀 System ready"
echo -e "${NC}"

echo ""
}

# ==============================
# 📥 REPO
# ==============================
ensure_repo() {
if [ ! -d "$DIR" ]; then
git clone $REPO $DIR > /dev/null 2>&1
fi
cd $DIR || exit
}

# ==============================
# 📊 DASHBOARD
# ==============================
dashboard() {

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
UPTIME=$(uptime -p | cut -d " " -f2-)

center "────────────────────────────────────────────"
center "HOST: Krysol   ⏱ $UPTIME   ● ONLINE"
center "────────────────────────────────────────────"

echo ""
center "System Health"
center "CPU: $CPU%   RAM: $RAM%   NET: CONNECTED"

echo ""

# MENU (CENTERED CLEAN)
center "[1] Install Bot        [5] Start Bot"
center "[2] Configure Bot      [6] Stop Bot"
center "[3] Fix Bot            [7] Status"
echo ""
center "[4] Repair System      [8] Delete Bot"

echo ""
center "────────────────────────────────────────────"

echo -ne "${YELLOW}"
center "➤ Command (1-8 / 0 exit): "
echo -ne "${NC}"
}

# ==============================
# ⚙️ FUNCTIONS
# ==============================
install_bot() {
ensure_repo
sudo apt update -y
sudo apt install -y nodejs npm git curl
npm install
sudo npm install -g pm2
}

configure_bot() {
ensure_repo
read -p "TOKEN: " TOKEN
read -p "CLIENT ID: " CLIENT_ID
read -p "GUILD ID: " GUILD_ID

cat > .env <<EOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID
EOF
}

fix_bot() {
ensure_repo
rm -rf node_modules package-lock.json
npm install
git reset --hard
git pull
}

start_bot() {
ensure_repo
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
echo -e "${RED}Type DELETE to confirm:${NC}"
read confirm
if [ "$confirm" = "DELETE" ]; then
rm -rf "$DIR"
pm2 delete $APP_NAME 2>/dev/null
fi
read
}

# ==============================
# 🔁 LOOP
# ==============================
while true; do
banner
dashboard

read choice
choice=$(echo "$choice" | tr -d '[:space:]')

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
