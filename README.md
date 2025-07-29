# KazKit

KazKit is a simple offensive toolkit that automates basic reconnaissance tasks for penetration testing. It helps streamline scanning and service checks with a single script.

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
kazkit listen    # Start reverse shell listener (default port 4444)
kazkit flag      # Show Flag Retrieval Cheat Sheet (Linux & Windows)
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
