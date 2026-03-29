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
# ⚡ LOADING BAR
# ==============================
loading_bar() {
    echo -ne "${YELLOW}Loading: [${NC}"
    for i in {1..20}; do
        echo -ne "${GREEN}█${NC}"
        sleep 0.02
    done
    echo -e "${YELLOW}] Done!${NC}"
}

# ==============================
# 🔄 SPINNER
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

for i in {1..2}; do
clear
cat << "EOF"
██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗
██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║
█████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║
██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║
██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗
╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝
EOF
sleep 0.1
done

echo -e "${CYAN}"
typewriter "⚡ Initializing Krysol Control Panel..."
sleep 0.2
typewriter "🔐 Loading modules..."
sleep 0.2
typewriter "🚀 System Ready!"
echo -e "${NC}"
}

# ==============================
# 📥 REPO
# ==============================
ensure_repo() {
if [ ! -d "$DIR" ]; then
    (git clone $REPO $DIR > /dev/null 2>&1) & spinner
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

if ! command -v node &> /dev/null; then
(curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1 && sudo apt install -y nodejs > /dev/null 2>&1) & spinner
fi

(npm install > /dev/null 2>&1) & spinner
(sudo npm install -g pm2 > /dev/null 2>&1) & spinner

curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash

echo -e "${GREEN}✅ Install Done${NC}"
read -p "Press Enter..."
}

# ==============================
# ⚙️ CONFIG
# ==============================
configure_bot() {
banner
ensure_repo

read -p "BOT TOKEN: " TOKEN
read -p "CLIENT ID: " CLIENT_ID
read -p "GUILD ID: " GUILD_ID

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

(rm -rf node_modules package-lock.json > /dev/null 2>&1) & spinner
(npm install > /dev/null 2>&1) & spinner
(git reset --hard > /dev/null 2>&1 && git pull > /dev/null 2>&1) & spinner

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
# 🗑️ DELETE
# ==============================
delete_bot() {
banner

echo -e "${RED}⚠ This will DELETE the bot permanently!${NC}"
read -p "Type DELETE to confirm: " confirm

if [ "$confirm" = "DELETE" ]; then
    rm -rf "$DIR"
    pm2 delete $APP_NAME > /dev/null 2>&1
    echo -e "${GREEN}🗑️ Bot Deleted${NC}"
else
    echo -e "${CYAN}Cancelled${NC}"
fi

read -p "Press Enter..."
}

# ==============================
# 🎮 MENU
# ==============================
menu_ui() {
echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     ${MAGENTA}⚡ CONTROL PANEL ⚡${CYAN}       ║${NC}"
echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
echo -e "${CYAN}║ ${GREEN}[1]${NC} Install Bot             ${CYAN}║${NC}"
echo -e "${CYAN}║ ${GREEN}[2]${NC} Configure Bot           ${CYAN}║${NC}"
echo -e "${CYAN}║ ${GREEN}[3]${NC} Fix Bot                 ${CYAN}║${NC}"
echo -e "${CYAN}║ ${GREEN}[4]${NC} Start Bot               ${CYAN}║${NC}"
echo -e "${CYAN}║ ${GREEN}[5]${NC} Stop Bot                ${CYAN}║${NC}"
echo -e "${CYAN}║ ${GREEN}[6]${NC} Status                  ${CYAN}║${NC}"
echo -e "${CYAN}║ ${RED}[7]${NC} Delete Bot             ${CYAN}║${NC}"
echo -e "${CYAN}║ ${RED}[0]${NC} Exit                   ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
}

# ==============================
# 🔁 LOOP
# ==============================
while true; do
banner
menu_ui

echo -ne "${YELLOW}➤ Select option: ${NC}"
read -r choice
choice=$(echo "$choice" | tr -d '[:space:]')

loading_bar

case "$choice" in
1) install_bot ;;
2) configure_bot ;;
3) fix_bot ;;
4) start_bot ;;
5) stop_bot ;;
6) status_bot ;;
7) delete_bot ;;
0) echo "Bye 😎"; exit ;;
*) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
esac

done
