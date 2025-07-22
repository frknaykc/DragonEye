#!/bin/bash
# DragonEye - macOS Enumeration Script v1.0

# ANSI Renk Kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Banner
echo -e "${BLUE}"
cat << "EOF"
██████╗ ██████╗  █████╗  ██████╗  ██████╗ ███╗   ██╗███████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝██╔════╝
██║  ██║██████╔╝███████║██║  ███╗██║   ██║██╔██╗ ██║█████╗   ╚████╔╝ █████╗  
██║  ██║██╔══██╗██╔══██║██║   ██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝  ██╔══╝  
██████╔╝██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║███████╗   ██║   ███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝
EOF
echo -e "${NC}"
echo -e "${GREEN}macOS Enumeration Tool v1.0${NC}\n"

# Çıktı dosyası
OUTPUT_FILE="dragoneye_macos_$(date +%Y%m%d_%H%M%S).txt"
echo "[+] DragonEye macOS Report - $(date)" > "$OUTPUT_FILE"
echo "=========================================" >> "$OUTPUT_FILE"

# Fonksiyon: Komut çalıştır ve sonucu kaydet
run_command() {
    echo -e "\n${BLUE}[*] Running: $1${NC}"
    echo -e "\n=== [ $1 ] ===" >> "$OUTPUT_FILE"
    eval "$1" >> "$OUTPUT_FILE" 2>&1
    echo "=== [ Exit Code: $? ] ===" >> "$OUTPUT_FILE"
}

echo -e "${YELLOW}[*] Starting macOS System Enumeration...${NC}\n"

# Sistem Bilgileri
echo -e "${GREEN}[+] Gathering System Information...${NC}"
run_command "sw_vers"                                    # macOS versiyonu
run_command "system_profiler SPSoftwareDataType"        # Detaylı sistem bilgisi
run_command "system_profiler SPHardwareDataType"        # Donanım bilgisi
run_command "sysctl -a | grep machdep.cpu"              # CPU bilgisi
run_command "system_profiler SPStorageDataType"         # Disk bilgisi
run_command "system_profiler SPNetworkDataType"         # Ağ adaptörleri
run_command "nvram -p"                                  # NVRAM ayarları
run_command "csrutil status"                            # SIP durumu
run_command "spctl --status"                            # Gatekeeper durumu

# Güvenlik Bilgileri
echo -e "${GREEN}[+] Gathering Security Information...${NC}"
run_command "defaults read /Library/Preferences/com.apple.security"  # Güvenlik ayarları
run_command "defaults read /Library/Preferences/com.apple.alf"      # Firewall ayarları
run_command "launchctl list"                                        # Çalışan servisler
run_command "sudo fdesetup status"                                  # FileVault durumu
run_command "security list-keychains"                              # Keychain listesi
run_command "security dump-keychain -d"                            # Keychain içeriği
run_command "defaults read /Library/Preferences/com.apple.Bluetooth" # Bluetooth ayarları

# Kullanıcı Bilgileri
echo -e "${GREEN}[+] Gathering User Information...${NC}"
run_command "dscl . list /Users | grep -v '^_'"         # Normal kullanıcılar
run_command "dscacheutil -q group"                      # Grup bilgileri
run_command "dscacheutil -q user"                       # Kullanıcı detayları
run_command "defaults read /Library/Preferences/com.apple.loginwindow" # Login ayarları
run_command "security authorizationdb read system.login.console"      # Login yetkileri
run_command "defaults read com.apple.screensaver"                     # Ekran koruyucu
run_command "sudo log show --predicate 'eventMessage contains "sudo"' --last 24h"  # Sudo logları

# Ağ Bilgileri
echo -e "${GREEN}[+] Gathering Network Information...${NC}"
run_command "networksetup -listallhardwareports"        # Ağ portları
run_command "ifconfig"                                  # Ağ arayüzleri
run_command "netstat -an"                              # Açık portlar
run_command "route -n get default"                     # Routing
run_command "scutil --dns"                             # DNS ayarları
run_command "defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences" # WiFi
run_command "security find-generic-password -ga 'Airport'"  # WiFi şifreleri
run_command "defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server" # SMB

# Uygulama ve Servis Bilgileri
echo -e "${GREEN}[+] Gathering Application Information...${NC}"
run_command "ls -la /Applications/"                     # Yüklü uygulamalar
run_command "brew list"                                # Homebrew paketleri
run_command "system_profiler SPApplicationsDataType"    # Uygulama detayları
run_command "launchctl list"                           # LaunchDaemons
run_command "ls -la /Library/LaunchDaemons/"           # System daemons
run_command "ls -la /Library/LaunchAgents/"            # System agents
run_command "ls -la ~/Library/LaunchAgents/"           # User agents
run_command "defaults read com.apple.dock persistent-apps" # Dock uygulamaları

# Dosya Sistemi Kontrolleri
echo -e "${GREEN}[+] Checking File System...${NC}"
run_command "ls -la /etc/periodic/"                    # Periyodik görevler
run_command "find / -perm +6000 -type f -exec ls -la {} \; 2>/dev/null"  # SUID/SGID
run_command "find / -name '.ssh' -type d 2>/dev/null"  # SSH dizinleri
run_command "find / -name 'id_rsa*' 2>/dev/null"       # SSH keyleri
run_command "find / -name '.bash_history' 2>/dev/null" # Bash geçmişi
run_command "defaults read com.apple.finder"           # Finder ayarları

# Özel macOS Kontrolleri
echo -e "${GREEN}[+] Checking macOS Specific Settings...${NC}"
run_command "defaults read NSGlobalDomain"             # Global ayarlar
run_command "defaults read com.apple.TimeMachine"      # Time Machine
run_command "defaults read com.apple.Safari"           # Safari ayarları
run_command "defaults read com.apple.terminal"         # Terminal ayarları
run_command "defaults read com.apple.dock"             # Dock ayarları
run_command "defaults read com.apple.Spotlight"        # Spotlight ayarları
run_command "mdutil -s /"                             # Spotlight indeksi

# Güvenlik Açığı Kontrolleri
echo -e "${GREEN}[+] Checking for Common Vulnerabilities...${NC}"
run_command "find /Applications -perm -2 -type d"      # World-writable uygulama dizinleri
run_command "find /Library -perm -2 -type f"           # World-writable sistem dosyaları
run_command "find /private -name '.*' ! -user $(whoami)" # Gizli sistem dosyaları
run_command "find /Users -name '.DS_Store'"            # DS_Store dosyaları
run_command "find / -name '.bash_profile' -o -name '.bashrc' -o -name '.bash_login'" # Bash config
run_command "find / -name '.zshrc' -o -name '.zprofile' -o -name '.zshenv'" # Zsh config

# Önemli Dosya ve Dizinler
echo -e "${GREEN}[+] Checking Important Files and Directories...${NC}"
run_command "ls -la /private/etc/ssh/"                 # SSH config
run_command "ls -la /private/etc/ssl/"                 # SSL sertifikaları
run_command "ls -la /private/var/db/auth.db"          # Auth veritabanı
run_command "ls -la /Library/Preferences/"             # Sistem tercihleri
run_command "ls -la ~/Library/Preferences/"            # Kullanıcı tercihleri
run_command "ls -la /Library/Keychains/"              # Sistem keychainleri
run_command "ls -la ~/Library/Keychains/"             # Kullanıcı keychainleri

# Tamamlandı
echo -e "\n${GREEN}[+] Enumeration completed! Report saved to: $OUTPUT_FILE${NC}"
echo -e "${YELLOW}[!] WARNING: This report may contain sensitive information!"
echo -e "[!] Handle the output file with appropriate security measures.${NC}" 