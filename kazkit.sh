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
    echo "  set <IP>     Set target IP"
    echo "  quick        Quick Nmap scan (Top 1000 ports)"
    echo "  full         Full TCP port scan"
    echo "  detail       Detailed scan on open ports"
    echo "  ftp          Anonymous FTP check"
    echo "  all          Run all steps sequentially"
    echo ""
    echo "Example:"
    echo "  kazkit set 10.10.10.10"
    echo "  kazkit quick"
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
    PORTS=$(grep "^ [0-9]" $OUTPUT_DIR/full_scan.txt | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
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
    echo -e "${BLUE}[*] Checking FTP anonymous access on $IP...${NC}"
    wget -r ftp://Anonymous:pass@$IP --timeout=10 --tries=1 -P $OUTPUT_DIR/ftp_download 2>/dev/null
}

function all_tasks() {
    quick_scan
    full_scan
    detail_scan
    ftp_check
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
    all)
        all_tasks
        ;;
    *)
        help_menu
        ;;
esac
