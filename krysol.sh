#!/bin/bash

# COLORS
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

DIR="$HOME/VaultHeist-BOT"
REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
APP_NAME="vaultheist"

# TYPEWRITER
typewriter() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep 0.008
    done
    echo ""
}

# LOADING BAR
loading_bar() {
    echo -ne "${YELLOW}Loading [${NC}"
    for i in {1..25}; do
        echo -ne "${GREEN}█${NC}"
        sleep 0.01
    done
    echo -e "${YELLOW}]${NC}"
}

# SPINNER
spinner() {
    local pid=$!
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        printf "\r${CYAN}[%s] Processing...${NC}" "${spin:$i:1}"
        i=$(( (i+1) %10 ))
        sleep 0.08
    done
    printf "\r${GREEN}✔ Done!${NC}\n"
}

# BANNER
banner() {
clear

# glitch effect
for i in {1..2}; do
clear
echo -e "${CYAN}"
sleep 0.05
clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        ⚡ VaultHeist Installer ⚡"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sleep 0.05
clear
echo -e "${NC}"
sleep 0.05
done

# main logo
echo -e "${MAGENTA}"
cat << "EOF"
██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗     
██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║     
█████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║     
██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║     
██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗
╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝
EOF

echo -e "${CYAN}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        ⚡ KRYSOL CONTROL SYSTEM ⚡"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"

typewriter "🔐 Secure kernel loaded..."
typewriter "⚡ Injecting modules..."
typewriter "🚀 System ready"
echo ""
}

# REPO
ensure_repo() {
if [ ! -d "$DIR" ]; then
    (git clone $REPO $DIR > /dev/null 2>&1) & spinner
fi
cd $DIR || exit
}

# INSTALL
install_bot() {
banner
ensure_repo

(sudo apt update -y > /dev/null 2>&1) & spinner
(sudo apt install -y git curl nodejs npm > /dev/null 2>&1) & spinner

(npm install > /dev/null 2>&1) & spinner
(sudo npm install -g pm2 > /dev/null 2>&1) & spinner

curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash

echo -e "${GREEN}✔ INSTALL COMPLETE${NC}"
read
}

# CONFIG
configure_bot() {
banner
ensure_repo

read -p "TOKEN: " TOKEN
read -p "CLIENT ID: " CLIENT_ID
read -p "GUILD ID: " GUILD_ID

cat > .env <<EOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID
EOF

echo -e "${GREEN}✔ CONFIG SAVED${NC}"
read
}

# FIX
fix_bot() {
banner
ensure_repo

(rm -rf node_modules package-lock.json) & spinner
(npm install) & spinner
(git reset --hard && git pull) & spinner

curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/fix_error.sh | bash

echo -e "${GREEN}✔ FIX COMPLETE${NC}"
read
}

# START
start_bot() {
banner
ensure_repo

pm2 delete $APP_NAME > /dev/null 2>&1
pm2 start index.js --name $APP_NAME
pm2 save

echo -e "${GREEN}✔ BOT STARTED${NC}"
read
}

# STOP
stop_bot() {
banner
pm2 stop $APP_NAME
echo -e "${RED}✔ BOT STOPPED${NC}"
read
}

# STATUS
status_bot() {
banner
pm2 list
read
}

# DELETE
delete_bot() {
banner

echo -e "${RED}TYPE DELETE TO CONFIRM:${NC}"
read confirm

if [ "$confirm" = "DELETE" ]; then
    rm -rf "$DIR"
    pm2 delete $APP_NAME > /dev/null 2>&1
    echo -e "${GREEN}✔ BOT DELETED${NC}"
else
    echo "Cancelled"
fi

read
}

# MENU
menu() {
echo -e "${CYAN}╭────────────────────────────────────╮${NC}"
echo -e "${CYAN}│ ${MAGENTA}⚡ KRYSOL Control Panel ⚡${CYAN}        │${NC}"
echo -e "${CYAN}├────────────────────────────────────┤${NC}"

echo -e "${CYAN}│ ${GREEN}[1] Install Bot              ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[2] Configure Bot            ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[3] Fix & Repair             ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[4] Start Bot                ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[5] Stop Bot                 ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[6] Status                   ${CYAN}│${NC}"
echo -e "${CYAN}│ ${GREEN}[7] Delete Bot               ${CYAN}│${NC}"

echo -e "${CYAN}├────────────────────────────────────┤${NC}"
echo -e "${CYAN}│ ${YELLOW}[0] Exit                   ${CYAN}│${NC}"
echo -e "${CYAN}╰────────────────────────────────────╯${NC}"
}

# LOOP
while true; do
banner
menu

echo -ne "${MAGENTA}┌─[KRYSOL@panel]─[~]\n└──➤ ${NC}"
read choice

loading_bar

case "$choice" in
1) install_bot ;;
2) configure_bot ;;
3) fix_bot ;;
4) start_bot ;;
5) stop_bot ;;
6) status_bot ;;
7) delete_bot ;;
0) exit ;;
*) echo "Invalid"; sleep 1 ;;
esac

done
