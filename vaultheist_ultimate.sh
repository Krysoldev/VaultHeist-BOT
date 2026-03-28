cat << 'EOF' > vaultheist_ultimate.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - ULTIMATE INSTALLER
# Created by: Krysol Dev
# Version: 3.0
# ============================================

# Colors for animations
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Clear screen
clear

# ============================================
# ANIMATED BANNER
# ============================================
animate_banner() {
    echo -e "${CYAN}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ██╗   ██╗ █████╗ ██╗   ██╗██╗  ████████╗██╗  ██╗███████╗  ║
    ║   ██║   ██║██╔══██╗██║   ██║██║  ╚══██╔══╝██║  ██║██╔════╝  ║
    ║   ██║   ██║███████║██║   ██║██║     ██║   ███████║█████╗    ║
    ║   ╚██╗ ██╔╝██╔══██║██║   ██║██║     ██║   ██╔══██║██╔══╝    ║
    ║    ╚████╔╝ ██║  ██║╚██████╔╝███████╗██║   ██║  ██║███████╗  ║
    ║     ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═╝╚══════╝  ║
    ║                                                               ║
    ║   ██╗  ██╗███████╗██╗███████╗████████╗                        ║
    ║   ██║  ██║██╔════╝██║██╔════╝╚══██╔══╝                        ║
    ║   ███████║█████╗  ██║█████╗     ██║                           ║
    ║   ██╔══██║██╔══╝  ██║██╔══╝     ██║                           ║
    ║   ██║  ██║███████╗██║██║        ██║                           ║
    ║   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝        ╚═╝                           ║
    ║                                                               ║
    ║                    DISCORD ECONOMY BOT                        ║
    ║                   Version 1.0 | Krysol Dev                    ║
    ╚═══════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    
    # Animated loading dots
    echo -ne "${YELLOW}Initializing VaultHeist System"
    for i in {1..3}; do
        sleep 0.3
        echo -n "."
    done
    echo -e " ${GREEN}✓${NC}\n"
    sleep 0.5
}

# ============================================
# MAIN MENU
# ============================================
show_menu() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              SELECT AN OPTION TO CONTINUE${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} ${WHITE}🚀 FULL INSTALL${NC}     - Complete bot installation"
    echo -e "${CYAN}[2]${NC} ${WHITE}⚙️  CONFIGURE ONLY${NC}   - Edit .env configuration"
    echo -e "${CYAN}[3]${NC} ${WHITE}🔧 AUTO-FIX & REPAIR${NC} - Fix broken bot files"
    echo -e "${CYAN}[4]${NC} ${WHITE}🎮 START BOT${NC}         - Run the bot"
    echo -e "${CYAN}[5]${NC} ${WHITE}📊 STATUS CHECK${NC}      - Check bot status"
    echo -e "${CYAN}[6]${NC} ${WHITE}🗑️  UNINSTALL${NC}        - Remove bot files"
    echo -e "${CYAN}[0]${NC} ${WHITE}❌ EXIT${NC}              - Close this menu"
    echo ""
    echo -ne "${YELLOW}Enter your choice [0-6]: ${NC}"
}

# ============================================
# FULL INSTALL FUNCTION
# ============================================
full_install() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              🚀 STARTING FULL INSTALLATION${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    # Download and run install script
    echo -e "${YELLOW}[1/3] Downloading installer...${NC}"
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/install_all.sh -o install_all.sh
    chmod +x install_all.sh
    echo -e "${GREEN}✓ Installer downloaded${NC}\n"
    
    echo -e "${YELLOW}[2/3] Running installation...${NC}"
    ./install_all.sh
    echo -e "${GREEN}✓ Installation complete${NC}\n"
    
    echo -e "${YELLOW}[3/3] Running configuration wizard...${NC}"
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/wizard.sh -o wizard.sh
    chmod +x wizard.sh
    ./wizard.sh
}

# ============================================
# CONFIGURE ONLY FUNCTION
# ============================================
configure_only() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              ⚙️  CONFIGURATION WIZARD${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/wizard.sh -o wizard.sh
    chmod +x wizard.sh
    ./wizard.sh
}

# ============================================
# AUTO-FIX FUNCTION
# ============================================
auto_fix() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              🔧 AUTO-FIX & REPAIR TOOL${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/auto_fix.sh -o auto_fix.sh
    chmod +x auto_fix.sh
    ./auto_fix.sh
}

# ============================================
# START BOT FUNCTION
# ============================================
start_bot() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              🎮 STARTING VAULT HEIST BOT${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ .env file not found! Please configure first.${NC}"
        echo -e "${YELLOW}Run option [2] to configure.${NC}\n"
        return
    fi
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Installing dependencies...${NC}"
        npm install
    fi
    
    echo -e "${GREEN}🚀 Bot is starting...${NC}\n"
    npm start
}

# ============================================
# STATUS CHECK FUNCTION
# ============================================
status_check() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}              📊 BOT STATUS CHECK${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    # Check .env
    echo -ne "${YELLOW}Checking .env file...${NC}"
    if [ -f ".env" ]; then
        echo -e " ${GREEN}✓${NC}"
        if grep -q "PASTE_YOUR_TOKEN" .env; then
            echo -e "   ${RED}⚠️  Token not configured!${NC}"
        else
            echo -e "   ${GREEN}✓ Token configured${NC}"
        fi
    else
        echo -e " ${RED}✗ Missing${NC}"
    fi
    
    # Check node_modules
    echo -ne "${YELLOW}Checking dependencies...${NC}"
    if [ -d "node_modules" ]; then
        echo -e " ${GREEN}✓${NC}"
    else
        echo -e " ${RED}✗ Not installed${NC}"
    fi
    
    # Check directories
    echo -ne "${YELLOW}Checking directories...${NC}"
    if [ -d "src/commands" ] && [ -d "src/events" ] && [ -d "src/utils" ]; then
        echo -e " ${GREEN}✓${NC}"
    else
        echo -e " ${RED}✗ Missing directories${NC}"
    fi
    
    # Count commands
    if [ -d "src/commands" ]; then
        cmd_count=$(find src/commands -name "*.js" -type f 2>/dev/null | wc -l)
        echo -e "${YELLOW}Commands found:${NC} ${GREEN}$cmd_count${NC}"
    fi
    
    # Check package.json
    if [ -f "package.json" ]; then
        echo -e "${YELLOW}Package.json:${NC} ${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}Package.json:${NC} ${RED}✗ Missing${NC}"
    fi
    
    echo ""
}

# ============================================
# UNINSTALL FUNCTION
# ============================================
uninstall_bot() {
    echo -e "\n${RED}════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}              🗑️  UNINSTALL VAULT HEIST${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${YELLOW}⚠️  WARNING: This will delete all bot files and data!${NC}"
    echo -ne "${RED}Are you sure? (y/N): ${NC}"
    read confirm
    
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo -e "\n${YELLOW}Removing files...${NC}"
        
        # Backup users.json if exists
        if [ -f "src/data/users.json" ]; then
            echo -e "${YELLOW}Creating backup of users.json...${NC}"
            cp src/data/users.json users.json.backup
            echo -e "${GREEN}✓ Backup saved as users.json.backup${NC}"
        fi
        
        # Remove directories
        rm -rf node_modules src .env package.json package-lock.json index.js *.sh
        
        echo -e "${GREEN}✓ Uninstall complete${NC}"
        echo -e "${YELLOW}Backup file: users.json.backup${NC}\n"
    else
        echo -e "${GREEN}Cancelled.${NC}\n"
    fi
}

# ============================================
# MAIN LOOP
# ============================================
animate_banner

while true; do
    show_menu
    read choice
    
    case $choice in
        1) full_install ;;
        2) configure_only ;;
        3) auto_fix ;;
        4) start_bot ;;
        5) status_check ;;
        6) uninstall_bot ;;
        0) 
            echo -e "\n${GREEN}Thank you for using VaultHeist! Goodbye! 👋${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option! Please enter 0-6.${NC}\n"
            sleep 1
            ;;
    esac
    
    if [ $choice != "4" ]; then
        echo -e "\n${BLUE}Press Enter to return to menu...${NC}"
        read
        clear
        animate_banner
    fi
done
EOF

chmod +x vaultheist_ultimate.sh
./vaultheist_ultimate.sh
