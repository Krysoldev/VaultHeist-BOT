#!/bin/bash

# ==============================
# 🎨 COLORS
# ==============================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

DIR="$HOME/VaultHeist-BOT"
REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
APP_NAME="vaultheist"

# ==============================
# 🎬 SPINNER
# ==============================
spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${CYAN}[%c] Working...${NC}" "${spin:$i:1}"
        sleep .1
    done
    printf "\r${GREEN}✔ Done!${NC}\n"
}

# ==============================
# 🎬 BANNER
# ==============================
banner() {
clear
echo -e "${MAGENTA}"
cat << "EOF"
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║   ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                     ║
║   ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                     ║
║   █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                     ║
║   ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                     ║
║   ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗                ║
║   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝                ║
║                                                                    ║
║                         K R Y S O L                                ║
║                                                                    ║
║                ⚡ CONTROL PANEL SYSTEM ⚡                          ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
}

# ==============================
# 📥 REPO SETUP
# ==============================
ensure_repo() {
if [ ! -d "$DIR" ]; then
    git clone $REPO $DIR > /dev/null 2>&1 &
    spinner
fi
cd $DIR || exit
chmod +x *.sh 2>/dev/null
}

# ==============================
# 🚀 INSTALL
# ==============================
install_bot() {
banner
ensure_repo

echo -e "${YELLOW}Installing bot...${NC}"

(sudo apt update -y > /dev/null 2>&1) & spinner
(sudo apt install -y git curl nodejs npm > /dev/null 2>&1) & spinner

# Node install fix
if ! command -v node &> /dev/null; then
(curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1 && sudo apt install -y nodejs > /dev/null 2>&1) & spinner
fi

(npm install > /dev/null 2>&1) & spinner

# install pm2
(sudo npm install -g pm2 > /dev/null 2>&1) & spinner

echo -e "${GREEN}Running final fix...${NC}"
curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash

echo -e "${GREEN}✅ Install Completed${NC}"
read -p "Press Enter..."
}

# ==============================
# ⚙️ CONFIG
# ==============================
configure_bot() {
banner
ensure_repo

echo -e "${CYAN}Configure Bot${NC}"

read -p "BOT TOKEN: " TOKEN
read -p "CLIENT ID: " CLIENT_ID
read -p "GUILD ID (optional): " GUILD_ID

cat > .env <<EOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID
EOF

echo -e "${GREEN}Saved .env${NC}"
read -p "Press Enter..."
}

# ==============================
# 🔧 FIX
# ==============================
fix_bot() {
banner
ensure_repo

echo -e "${YELLOW}Fixing bot...${NC}"

(rm -rf node_modules package-lock.json > /dev/null 2>&1) & spinner
(npm install > /dev/null 2>&1) & spinner
(git reset --hard > /dev/null 2>&1 && git pull > /dev/null 2>&1) & spinner

echo -e "${GREEN}Running deep fix...${NC}"
curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash

echo -e "${GREEN}✅ Fix Done${NC}"
read -p "Press Enter..."
}

# ==============================
# ▶️ START
# ==============================
start_bot() {
banner
ensure_repo

pm2 delete $APP_NAME > /dev/null 2>&1
pm2 start index.js --name $APP_NAME
pm2 save

echo -e "${GREEN}🚀 Bot Started${NC}"
read -p "Press Enter..."
}

# ==============================
# ⛔ STOP
# ==============================
stop_bot() {
banner
pm2 stop $APP_NAME > /dev/null 2>&1
echo -e "${RED}🛑 Bot Stopped${NC}"
read -p "Press Enter..."
}

# ==============================
# 📊 STATUS
# ==============================
status_bot() {
banner

pm2 list

read -p "Press Enter..."
}

# ==============================
# 🎮 MENU
# ==============================
while true; do
banner

echo -e "${CYAN}[1] Install Bot${NC}"
echo -e "${CYAN}[2] Configure Bot${NC}"
echo -e "${CYAN}[3] Fix Bot${NC}"
echo -e "${CYAN}[4] Start Bot${NC}"
echo -e "${CYAN}[5] Stop Bot${NC}"
echo -e "${CYAN}[6] Status${NC}"
echo -e "${CYAN}[0] Exit${NC}"

echo -ne "${YELLOW}Select option: ${NC}"

stty sane
read -r choice
choice=$(echo "$choice" | tr -d '[:space:]')

case "$choice" in
1) install_bot ;;
2) configure_bot ;;
3) fix_bot ;;
4) start_bot ;;
5) stop_bot ;;
6) status_bot ;;
0) echo -e "${GREEN}Bye bhai 😎${NC}"; exit ;;
*) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
esac

done
