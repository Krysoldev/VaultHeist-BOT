#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
DIR="$HOME/VaultHeist-BOT"

# ==============================
# 🎬 BANNER
# ==============================
show_banner() {
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
# 📥 ENSURE REPO
# ==============================
ensure_repo() {
if [ ! -d "$DIR" ]; then
    echo -e "${YELLOW}Cloning repo...${NC}"
    git clone $REPO $DIR
fi
cd $DIR || exit
chmod +x *.sh 2>/dev/null
}

# ==============================
# 🚀 INSTALL
# ==============================
install_bot() {
show_banner
ensure_repo

echo -e "${GREEN}🚀 Running Install...${NC}"
bash install.sh

echo -e "${GREEN}✅ Install Done${NC}"
read -p "Press Enter..."
}

# ==============================
# ⚙️ CONFIGURE
# ==============================
configure_bot() {
show_banner
ensure_repo

echo -e "${CYAN}⚙️ Opening Config Wizard...${NC}"
bash configure.sh

echo -e "${GREEN}✅ Config Saved${NC}"
read -p "Press Enter..."
}

# ==============================
# 🔧 REPAIR
# ==============================
repair_bot() {
show_banner

echo -e "${RED}⚠ Resetting bot files...${NC}"

# delete old repo
rm -rf "$DIR"

# fresh clone
git clone $REPO $DIR > /dev/null 2>&1

cd $DIR || exit
chmod +x *.sh

echo -e "${YELLOW}Running fix script...${NC}"
bash fix.sh

echo -e "${GREEN}✅ Repair Complete${NC}"
read -p "Press Enter..."
}

# ==============================
# 🔄 UPDATE
# ==============================
update_repo() {
show_banner
ensure_repo

echo -e "${CYAN}Updating repo...${NC}"
git pull

echo -e "${GREEN}✅ Updated${NC}"
read -p "Press Enter..."
}

# ==============================
# 🎮 MENU
# ==============================
while true; do
show_banner

echo -e "${CYAN}[1] Install Bot${NC}"
echo -e "${CYAN}[2] Configure Bot${NC}"
echo -e "${CYAN}[3] Repair Bot${NC}"
echo -e "${CYAN}[4] Update Repo${NC}"
echo -e "${CYAN}[0] Exit${NC}"

echo -ne "${YELLOW}Select option: ${NC}"

stty sane
read -r choice
choice=$(echo "$choice" | tr -d '[:space:]')

case "$choice" in
1) install_bot ;;
2) configure_bot ;;
3) repair_bot ;;
4) update_repo ;;
0) echo -e "${GREEN}Bye bhai 😎${NC}"; exit ;;
*) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
esac

done
