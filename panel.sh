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

REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"
DIR="VaultHeist-BOT"

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
# 📥 SETUP (DOWNLOAD SCRIPTS)
# ==============================
setup_repo() {
if [ -d "$DIR" ]; then
    cd $DIR && git pull > /dev/null 2>&1
else
    git clone $REPO $DIR > /dev/null 2>&1
    cd $DIR
fi

# make scripts executable
chmod +x install.sh configure.sh fix.sh 2>/dev/null
}

# ==============================
# 🎮 MENU
# ==============================
while true; do
show_banner

echo -e "${CYAN}[1] Install Bot${NC}"
echo -e "${CYAN}[2] Configure Bot${NC}"
echo -e "${CYAN}[3] Fix Bot${NC}"
echo -e "${CYAN}[4] Update Repo${NC}"
echo -e "${CYAN}[0] Exit${NC}"

echo -ne "${YELLOW}Select option: ${NC}"

stty sane
read -r choice
choice=$(echo "$choice" | tr -d '[:space:]')

case "$choice" in

1)
    echo -e "${GREEN}Running install.sh...${NC}"
    setup_repo
    bash install.sh
    read -p "Press Enter..."
;;

2)
    echo -e "${GREEN}Running configure.sh...${NC}"
    setup_repo
    bash configure.sh
    read -p "Press Enter..."
;;

3)
    echo -e "${GREEN}Running fix.sh...${NC}"
    setup_repo
    bash fix.sh
    read -p "Press Enter..."
;;

4)
    echo -e "${CYAN}Updating repo...${NC}"
    setup_repo
    echo -e "${GREEN}Updated!${NC}"
    read -p "Press Enter..."
;;

0)
    echo -e "${GREEN}Bye bhai 😎${NC}"
    exit
;;

*)
    echo -e "${RED}Invalid option!${NC}"
    sleep 1
;;

esac

done
