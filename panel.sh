#!/bin/bash

# ==============================
# 🎨 COLORS
# ==============================
BLUE='\033[38;5;19m'     # dark blue
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
NC='\033[0m'

DIR="$HOME/VaultHeist-BOT"
REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
APP_NAME="vaultheist"

# ==============================
# 🎬 TYPEWRITER
# ==============================
typewriter() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep 0.01
    done
    echo ""
}

# ==============================
# 🎯 CENTER TEXT
# ==============================
center_text() {
    cols=$(tput cols)
    text="$1"
    printf "%*s\n" $(((${#text}+cols)/2)) "$text"
}

# ==============================
# 🎬 ANIMATED KRYSOL LOGO
# ==============================
banner() {
clear

logo="KRYSOL"

for i in {1..3}; do
clear
echo ""
echo -e "${BLUE}"
center_text "██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗"
center_text "██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║"
center_text "█████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║"
center_text "██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║"
center_text "██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗"
center_text "╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝"
echo -e "${NC}"
sleep 0.08
done

echo ""
echo -e "${CYAN}"
center_text "⚡ K R Y S O L   D A S H B O A R D ⚡"
echo -e "${NC}"

echo ""
typewriter "🔐 Initializing secure environment..."
typewriter "⚡ Loading modules..."
typewriter "🚀 System ready"
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
# 📊 DASHBOARD UI
# ==============================
dashboard() {

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
UPTIME=$(uptime -p | cut -d " " -f2-)

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " HOST: Krysol   ⏱ $UPTIME   ● ONLINE"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${MAGENTA}System Health:${NC}"
echo -e " CPU: ${CYAN}$CPU%${NC}   RAM: ${YELLOW}$RAM%${NC}   NET: ${GREEN}CONNECTED${NC}"

echo -e "\n${CYAN}📦 DEPLOYMENT${NC}"
echo " [1] Install Bot        [5] Start Bot"
echo " [2] Configure Bot      [6] Stop Bot"
echo " [3] Fix Bot            [7] Status"

echo -e "\n${MAGENTA}🛠 MAINTENANCE${NC}"
echo " [4] Repair System      [8] Delete Bot"

echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -ne "${YELLOW}➤ Command (1-8 / 0 exit): ${NC}"
}

# ==============================
# 🚀 FUNCTIONS
# ==============================
install_bot() {
ensure_repo
sudo apt update -y
sudo apt install -y nodejs npm git curl
npm install
sudo npm install -g pm2
curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash
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
curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash
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
echo "Deleted"
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
