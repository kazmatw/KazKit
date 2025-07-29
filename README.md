# KazKit

KazKit is a simple offensive toolkit that automates basic reconnaissance tasks for penetration testing. It helps streamline scanning and service checks with a single script.

---

### Features

- Quick Nmap scan (Top 1000 ports)
- Full TCP port scan
- Detailed scan with default NSE scripts and service detection
- Download all accessible files from FTP using anonymous login
- Saves results in organized output folders
- Start reverse shell listener with `rlwrap` and `nc`

---

### Installation

```bash
git clone https://github.com/<your-username>/KazKit.git
cd KazKit
chmod +x install.sh
sudo ./install.sh
```

---

### Usage

First, set the target IP:

```bash
kazkit set <IP>
```

Then run any mode:

```bash
kazkit quick     # Quick scan (Top 1000 ports)
kazkit full      # Full TCP port scan
kazkit detail    # Detailed scan on open ports (requires full scan first)
kazkit ftp       # Download all files via FTP (anonymous login)
kazkit all       # Run all steps sequentially
```

---

### Output

All results are stored in:

```
recon_<IP>/
  ├── quick_scan.txt
  ├── full_scan.txt
  ├── detailed_scan.txt
  └── ftp_download/
```
