#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

CONFIG_FILE="$HOME/.kazkit_ip"

function banner() {
    echo -e "${BLUE}"
    echo " _  __         _  ___ _   "
    echo "| |/ /__ _ ___| |/ (_) |_ "
    echo "| ' // _\` |_  / ' /| | __|"
    echo "| . \ (_| |/ /| . \| | |_ "
    echo "|_|\_\__,_/___|_|\_\_|\__|"
    echo "     KazKit - Offensive Toolkit"
    echo -e "${NC}"
}

function help_menu() {
    echo "Usage: kazkit <command>"
    echo ""
    echo "Commands:"
    echo "  set <IP>       Set target IP"
    echo "  quick          Quick Nmap scan (Top 1000 ports)"
    echo "  full           Full TCP port scan"
    echo "  detail         Detailed scan on open ports"
    echo "  ftp            Download files via anonymous FTP"
    echo "  listen [PORT]  Start reverse shell listener (default port 4444)"
    echo "  flag           Print flag retrieval cheat sheet"
    echo ""
    echo "Examples:"
    echo "  kazkit set 10.10.10.10"
    echo "  kazkit quick"
    echo "  kazkit listen 9001"
}

function get_ip() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}[!] No IP set. Use: kazkit set <IP>${NC}"
        exit 1
    fi
    IP=$(cat "$CONFIG_FILE")
}

function set_ip() {
    echo "$1" > "$CONFIG_FILE"
    echo -e "${GREEN}[+] Target IP set to: $1${NC}"
}

function quick_scan() {
    get_ip
    OUTPUT_DIR="recon_$IP"
    mkdir -p $OUTPUT_DIR
    echo -e "${BLUE}[*] Running quick Nmap scan on $IP...${NC}"
    sudo nmap -Pn -n -T4 $IP -oN $OUTPUT_DIR/quick_scan.txt
}

function full_scan() {
    get_ip
    OUTPUT_DIR="recon_$IP"
    mkdir -p $OUTPUT_DIR
    echo -e "${BLUE}[*] Running full TCP port scan on $IP...${NC}"
    sudo nmap -Pn -n -T4 -p- --open $IP -oN $OUTPUT_DIR/full_scan.txt
}

function detail_scan() {
    get_ip
    OUTPUT_DIR="recon_$IP"
    if [ ! -f "$OUTPUT_DIR/full_scan.txt" ]; then
        echo -e "${RED}[!] Run 'full' first to get port list.${NC}"
        exit 1
    fi
    PORTS=$(grep "^[0-9]" $OUTPUT_DIR/full_scan.txt | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
    if [ -z "$PORTS" ]; then
        echo -e "${RED}[!] No open ports found.${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] Open ports: $PORTS${NC}"
    echo -e "${BLUE}[*] Running detailed scan on open ports...${NC}"
    sudo nmap -Pn -n -sC -sV -p $PORTS $IP -oN $OUTPUT_DIR/detailed_scan.txt
}

function ftp_check() {
    get_ip
    OUTPUT_DIR="recon_$IP"
    mkdir -p $OUTPUT_DIR
    echo -e "${BLUE}[*] Downloading all files from FTP via anonymous login on $IP...${NC}"
    wget -r ftp://Anonymous:pass@$IP --timeout=10 --tries=1 -P $OUTPUT_DIR/ftp_download 2>/dev/null
}

function start_listener() {
    LPORT=${1:-4444}
    echo -e "${BLUE}[*] Starting reverse shell listener on port $LPORT...${NC}"
    sudo rlwrap nc -lvnp $LPORT
}

function flag_cheatsheet() {
    echo -e "${BLUE}[*] Flag Retrieval Cheat Sheet:${NC}\n"

    echo -e "${GREEN}Linux:${NC}"
    echo "cat /root/proof.txt; cat /home/*/local.txt"
    echo ""

    echo -e "${GREEN}Windows (CMD):${NC}"
    echo "type C:\\Users\\Administrator\\Desktop\\proof.txt && type C:\\Users\\*\\Desktop\\local.txt"
    echo ""

    echo -e "${GREEN}Windows (PowerShell):${NC}"
    echo "type C:\\Users\\*\\Desktop\\local.txt; type C:\\Users\\Administrator\\Desktop\\proof.txt"
    echo "# OR more generic search:"
    echo "Get-ChildItem -Path C:\\Users -Recurse -Include local.txt,proof.txt 2>\$null | ForEach-Object { Get-Content \$_.FullName }"
}

banner

case $1 in
    set)
        [ -z "$2" ] && help_menu || set_ip "$2"
        ;;
    quick)
        quick_scan
        ;;
    full)
        full_scan
        ;;
    detail)
        detail_scan
        ;;
    ftp)
        ftp_check
        ;;
    listen)
        start_listener "$2"
        ;;
    flag)
        flag_cheatsheet
        ;;
    *)
        help_menu
        ;;
esac
