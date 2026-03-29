#!/bin/bash

DIR="$HOME/VaultHeist-BOT"
REPO="https://github.com/Krysoldev/VaultHeist-BOT.git"

show_banner() {
clear
echo -e "\e[35m"
cat << "EOF"
╔════════════════════════════════════════════════════════════════════╗
║                         K R Y S O L PANEL                         ║
║                   ⚡ CONTROL PANEL SYSTEM ⚡                      ║
╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "\e[0m"
}

ensure_repo() {
if [ ! -d "$DIR" ]; then
git clone $REPO $DIR
fi
cd $DIR || exit
chmod +x *.sh
}

install_bot() {
ensure_repo
bash install.sh
read -p "Press Enter..."
}

configure_bot() {
ensure_repo
bash configure.sh
read -p "Press Enter..."
}

fix_bot() {
rm -rf "$DIR"
git clone $REPO $DIR
cd $DIR || exit
chmod +x *.sh
bash fix.sh
read -p "Press Enter..."
}

while true; do
show_banner
echo "[1] Install Bot"
echo "[2] Configure Bot"
echo "[3] Fix Bot"
echo "[0] Exit"

read -p "Select: " ch

case $ch in
1) install_bot ;;
2) configure_bot ;;
3) fix_bot ;;
0) exit ;;
*) echo "Invalid"; sleep 1 ;;
esac
done
