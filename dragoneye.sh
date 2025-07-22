#!/bin/sh
# DragonEye Enumeration Tool v1.5
# Cross-platform system reconnaissance script
# Usage: ./dragoneye [ctf|pentest] [output_file]

# ANSI renk kodları (Windows hariç)
if [ "$OS" != "Windows_NT" ]; then
    HEADER="\033[95m"
    OKBLUE="\033[94m"
    OKGREEN="\033[92m"
    WARNING="\033[93m"
    FAIL="\033[91m"
    ENDC="\033[0m"
    BOLD="\033[1m"
else
    HEADER=""
    OKBLUE=""
    OKGREEN=""
    WARNING=""
    FAIL=""
    ENDC=""
    BOLD=""
fi

# Yardım mesajı
show_help() {
    echo "${BOLD}DragonEye Enumeration Tool${ENDC}"
    echo "Usage:"
    echo "  ./dragoneye                  # Interactive mode"
    echo "  ./dragoneye ctf              # Run CTF profile"
    echo "  ./dragoneye pentest          # Run Pentest profile"
    echo "  ./dragoneye [profile] output # Save to specific file"
    echo ""
    echo "Profiles:"
    echo "  ctf     - Fast checks for CTF challenges"
    echo "  pentest - Comprehensive security checks"
    echo ""
    echo "Supported OS: Linux, macOS, Windows"
}

# Başlık görüntüleme
show_banner() {
    echo "${HEADER}"
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "██████╗ ██████╗  █████╗  ██████╗  ██████╗ ███╗   ██╗███████╗██╗   ██╗███████╗"
    echo "██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝██╔════╝"
    echo "██║  ██║██████╔╝███████║██║  ███╗██║   ██║██╔██╗ ██║█████╗   ╚████╔╝ █████╗  "
    echo "██║  ██║██╔══██╗██╔══██║██║   ██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝  ██╔══╝  "
    echo "██████╔╝██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║███████╗   ██║   ███████╗"
    echo "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo "${ENDC}"
    echo "${BOLD}Multi-OS Enumeration Tool v1.5${ENDC}"
    echo ""
}

# Platform tespiti
detect_platform() {
    if [ "$OS" = "Windows_NT" ]; then
        echo "windows"
    else
        case $(uname | tr '[:upper:]' '[:lower:]') in
            linux*)  echo "linux" ;;
            darwin*) echo "macos" ;;
            *)       echo "unknown" ;;
        esac
    fi
}

# Linux enum fonksiyonları
linux_enum() {
    PROFILE="$1"
    VERBOSE="$2"
    OUTPUT_FILE="$3"
    
    echo "${OKBLUE}[*] Starting Linux Enumeration (Profile: $PROFILE)${ENDC}"
    echo ""
    
    # Sistem bilgileri
    run_command "uname -a" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/*-release" "$VERBOSE" "$OUTPUT_FILE"
    run_command "hostnamectl" "$VERBOSE" "$OUTPUT_FILE"
    run_command "uptime" "$VERBOSE" "$OUTPUT_FILE"
    
    # SELinux Kontrolü
    run_command "sestatus" "$VERBOSE" "$OUTPUT_FILE"
    
    # Kullanıcı ve yetki bilgileri
    run_command "id" "$VERBOSE" "$OUTPUT_FILE"
    run_command "whoami" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/passwd" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/group" "$VERBOSE" "$OUTPUT_FILE"
    run_command "sudo -l" "$VERBOSE" "$OUTPUT_FILE"
    run_command "grep -v '^[^:]*:[x]' /etc/passwd" "$VERBOSE" "$OUTPUT_FILE" # Hash kontrolü
    run_command "cat /etc/shadow" "$VERBOSE" "$OUTPUT_FILE"
    run_command "grep -v -E '^#' /etc/passwd | awk -F: '\$3 == 0 { print \$1}'" "$VERBOSE" "$OUTPUT_FILE" # UID 0 kontrolü
    run_command "find /home -name .sudo_as_admin_successful" "$VERBOSE" "$OUTPUT_FILE"
    
    # Ağ bilgileri
    run_command "ip addr" "$VERBOSE" "$OUTPUT_FILE"
    run_command "ip route" "$VERBOSE" "$OUTPUT_FILE"
    run_command "netstat -tuln" "$VERBOSE" "$OUTPUT_FILE"
    run_command "ss -tuln" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/resolv.conf" "$VERBOSE" "$OUTPUT_FILE"
    run_command "arp -a" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/hosts" "$VERBOSE" "$OUTPUT_FILE"
    
    # NFS Kontrolleri
    run_command "cat /etc/exports" "$VERBOSE" "$OUTPUT_FILE"
    run_command "showmount -e localhost" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/fstab" "$VERBOSE" "$OUTPUT_FILE"
    
    # SUID/SGID Dosyaları
    run_command "find / -perm -4000 -type f 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -perm -2000 -type f 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -perm -4002 -type f 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE" # World-writable SUID
    run_command "getcap -r / 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE" # POSIX capabilities
    
    # Hassas Dosya Araması
    run_command "find / -name '*.key' -o -name '*.pem' -o -name id_rsa 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -name '.aws' -o -name 'credentials' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -name '.git-credentials' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find /home -name '*.plan' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find /home -name '.rhosts' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    run_command "cat /etc/hosts.equiv 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    
    # Servis Kontrolleri
    run_command "mysql --version" "$VERBOSE" "$OUTPUT_FILE"
    run_command "mysqladmin -uroot -proot version" "$VERBOSE" "$OUTPUT_FILE"
    run_command "psql -V" "$VERBOSE" "$OUTPUT_FILE"
    run_command "apache2 -v" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -name '.htpasswd' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    
    # Docker Kontrolleri
    run_command "grep -i docker /proc/self/cgroup" "$VERBOSE" "$OUTPUT_FILE"
    run_command "docker --version" "$VERBOSE" "$OUTPUT_FILE"
    run_command "docker ps -a" "$VERBOSE" "$OUTPUT_FILE"
    run_command "find / -name Dockerfile -o -name docker-compose.yml 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    
    # LXC Kontrolleri
    run_command "grep -qa container=lxc /proc/1/environ" "$VERBOSE" "$OUTPUT_FILE"
    run_command "lxc-ls" "$VERBOSE" "$OUTPUT_FILE"
    
    if [ "$PROFILE" = "pentest" ]; then
        # Pentest için ek kontroller
        run_command "find / -perm -4000 -type f 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -perm -2000 -type f 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -writable 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "cat /etc/crontab" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /etc/cron.*" "$VERBOSE" "$OUTPUT_FILE"
        run_command "crontab -l" "$VERBOSE" "$OUTPUT_FILE"
        run_command "env" "$VERBOSE" "$OUTPUT_FILE"
        run_command "history" "$VERBOSE" "$OUTPUT_FILE"
        
        # World-writable dosyalar
        run_command "find / ! -path '*/proc/*' ! -path '/sys/*' -perm -2 -type f" "$VERBOSE" "$OUTPUT_FILE"
        
        # Mail kontrolü
        run_command "ls -la /var/mail/" "$VERBOSE" "$OUTPUT_FILE"
        run_command "head /var/mail/root" "$VERBOSE" "$OUTPUT_FILE"
        
        # Derleyici kontrolü
        run_command "which gcc g++ make python perl ruby" "$VERBOSE" "$OUTPUT_FILE"
    fi
    
    if [ "$PROFILE" = "ctf" ]; then
        # CTF özel kontroller
        run_command "find / -name 'flag*' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -name '*.txt' -o -name '*.md' 2>/dev/null | grep -i flag" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /root 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /home/*" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -name '*.bak' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
    fi
}

# macOS enum fonksiyonları
macos_enum() {
    PROFILE="$1"
    VERBOSE="$2"
    OUTPUT_FILE="$3"
    
    echo "${OKBLUE}[*] Starting macOS Enumeration (Profile: $PROFILE)${ENDC}"
    echo ""
    
    # Sistem bilgileri
    run_command "uname -a" "$VERBOSE" "$OUTPUT_FILE"
    run_command "sw_vers" "$VERBOSE" "$OUTPUT_FILE"
    run_command "system_profiler SPSoftwareDataType" "$VERBOSE" "$OUTPUT_FILE"
    run_command "uptime" "$VERBOSE" "$OUTPUT_FILE"
    
    # Kullanıcı ve yetki bilgileri
    run_command "id" "$VERBOSE" "$OUTPUT_FILE"
    run_command "whoami" "$VERBOSE" "$OUTPUT_FILE"
    run_command "dscl . list /Users" "$VERBOSE" "$OUTPUT_FILE"
    run_command "dscl . list /Groups" "$VERBOSE" "$OUTPUT_FILE"
    run_command "sudo -l" "$VERBOSE" "$OUTPUT_FILE"
    
    # Ağ bilgileri
    run_command "ifconfig" "$VERBOSE" "$OUTPUT_FILE"
    run_command "netstat -an" "$VERBOSE" "$OUTPUT_FILE"
    run_command "lsof -i" "$VERBOSE" "$OUTPUT_FILE"
    run_command "scutil --dns" "$VERBOSE" "$OUTPUT_FILE"
    
    if [ "$PROFILE" = "pentest" ]; then
        # Pentest için ek kontroller
        run_command "find / -perm +2000 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -writable 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "launchctl list" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /Library/LaunchAgents" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /Library/LaunchDaemons" "$VERBOSE" "$OUTPUT_FILE"
        run_command "env" "$VERBOSE" "$OUTPUT_FILE"
        run_command "history" "$VERBOSE" "$OUTPUT_FILE"
    fi
    
    # CTF özel kontroller
    if [ "$PROFILE" = "ctf" ]; then
        run_command "find / -name 'flag*' 2>/dev/null" "$VERBOSE" "$OUTPUT_FILE"
        run_command "find / -name '*.txt' -o -name '*.md' 2>/dev/null | grep -i flag" "$VERBOSE" "$OUTPUT_FILE"
        run_command "ls -la /Users/*" "$VERBOSE" "$OUTPUT_FILE"
    fi
}

# Windows enum fonksiyonları
windows_enum() {
    PROFILE="$1"
    VERBOSE="$2"
    OUTPUT_FILE="$3"
    
    echo "${OKBLUE}[*] Starting Windows Enumeration (Profile: $PROFILE)${ENDC}"
    echo ""
    
    # Sistem bilgileri
    run_command "systeminfo" "$VERBOSE" "$OUTPUT_FILE"
    run_command "hostname" "$VERBOSE" "$OUTPUT_FILE"
    run_command "ver" "$VERBOSE" "$OUTPUT_FILE"
    run_command "wmic os get caption,version,osarchitecture" "$VERBOSE" "$OUTPUT_FILE"
    run_command "net statistics workstation" "$VERBOSE" "$OUTPUT_FILE"
    
    # Kullanıcı ve yetki bilgileri
    run_command "whoami" "$VERBOSE" "$OUTPUT_FILE"
    run_command "whoami /priv" "$VERBOSE" "$OUTPUT_FILE"
    run_command "net user" "$VERBOSE" "$OUTPUT_FILE"
    run_command "net user %username%" "$VERBOSE" "$OUTPUT_FILE"
    run_command "net localgroup administrators" "$VERBOSE" "$OUTPUT_FILE"
    run_command "net localgroup" "$VERBOSE" "$OUTPUT_FILE"
    
    # Ağ bilgileri
    run_command "ipconfig /all" "$VERBOSE" "$OUTPUT_FILE"
    run_command "route print" "$VERBOSE" "$OUTPUT_FILE"
    run_command "netstat -ano" "$VERBOSE" "$OUTPUT_FILE"
    run_command "netsh firewall show config" "$VERBOSE" "$OUTPUT_FILE"
    run_command "arp -a" "$VERBOSE" "$OUTPUT_FILE"
    
    if [ "$PROFILE" = "pentest" ]; then
        # Pentest için ek kontroller
        run_command "schtasks /query /fo LIST" "$VERBOSE" "$OUTPUT_FILE"
        run_command "dir C:\\ /s /b | findstr /i \"unattended.xml\" 2>nul" "$VERBOSE" "$OUTPUT_FILE"
        run_command "reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\"" "$VERBOSE" "$OUTPUT_FILE"
        run_command "reg query \"HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\"" "$VERBOSE" "$OUTPUT_FILE"
        run_command "set" "$VERBOSE" "$OUTPUT_FILE"
        run_command "doskey /history" "$VERBOSE" "$OUTPUT_FILE"
    fi
    
    # CTF özel kontroller
    if [ "$PROFILE" = "ctf" ]; then
        run_command "dir /s /b flag.txt 2>nul" "$VERBOSE" "$OUTPUT_FILE"
        run_command "dir /s /b flag 2>nul" "$VERBOSE" "$OUTPUT_FILE"
        run_command "dir /s /b *.txt | findstr /i flag 2>nul" "$VERBOSE" "$OUTPUT_FILE"
        run_command "dir C:\\Users\\" "$VERBOSE" "$OUTPUT_FILE"
    fi
}

# Komut çalıştırma ve çıktıyı işleme
run_command() {
    CMD="$1"
    VERBOSE="$2"
    OUTPUT_FILE="$3"
    
    if [ "$VERBOSE" = "verbose" ]; then
        echo "${OKGREEN}[+] Executing: $CMD${ENDC}"
    fi
    
    # Çıktıyı ekrana ve dosyaya yaz
    echo "=== [ $CMD ] ===" >> "$OUTPUT_FILE"
    
    if [ "$PLATFORM" = "windows" ]; then
        eval "$CMD" >> "$OUTPUT_FILE" 2>&1
        RESULT=$?
    else
        sh -c "$CMD" >> "$OUTPUT_FILE" 2>&1
        RESULT=$?
    fi
    
    echo "" >> "$OUTPUT_FILE"
    echo "=== [ Exit Code: $RESULT ] ===" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    if [ "$VERBOSE" = "verbose" ]; then
        if [ $RESULT -eq 0 ]; then
            echo "  ${OKGREEN}SUCCESS${ENDC}"
        else
            echo "  ${WARNING}WARNING: Command returned $RESULT${ENDC}"
        fi
        echo ""
    fi
}

# Ana fonksiyon
main() {
    show_banner
    
    # Varsayılan ayarlar
    PROFILE=""
    OUTPUT_FILE="dragoneye_report.txt"
    VERBOSE=""
    PLATFORM=$(detect_platform)
    
    # Parametreleri işle
    for arg in "$@"; do
        case $arg in
            ctf|CTF)
                PROFILE="ctf"
                ;;
            pentest|Pentest|PENTEST)
                PROFILE="pentest"
                ;;
            verbose|VERBOSE)
                VERBOSE="verbose"
                ;;
            help|--help|-h)
                show_help
                exit 0
                ;;
            *)
                # Çıktı dosyası olarak kabul et
                if [ -z "$PROFILE" ]; then
                    PROFILE="$arg"
                else
                    OUTPUT_FILE="$arg"
                fi
                ;;
        esac
    done
    
    # Platform kontrolü
    if [ "$PLATFORM" = "unknown" ]; then
        echo "${FAIL}[!] Unsupported operating system${ENDC}"
        exit 1
    fi
    
    # Etkileşimli mod
    if [ -z "$PROFILE" ]; then
        echo "${BOLD}Select profile:${ENDC}"
        echo "1) CTF"
        echo "2) Pentest"
        echo "3) Custom"
        echo ""
        read -p "Enter choice (1-3): " choice
        
        case $choice in
            1) PROFILE="ctf" ;;
            2) PROFILE="pentest" ;;
            3) PROFILE="custom" ;;
            *)
                echo "${FAIL}Invalid choice${ENDC}"
                exit 1
                ;;
        esac
        
        read -p "Output file [dragoneye_report.txt]: " custom_output
        if [ -n "$custom_output" ]; then
            OUTPUT_FILE="$custom_output"
        fi
        
        read -p "Enable verbose mode? (y/n) [n]: " verbose_choice
        if [ "$verbose_choice" = "y" ] || [ "$verbose_choice" = "Y" ]; then
            VERBOSE="verbose"
        fi
    fi
    
    # Varsayılan profil
    if [ -z "$PROFILE" ]; then
        PROFILE="pentest"
    fi
    
    # Dosya hazırlığı
    if [ -f "$OUTPUT_FILE" ]; then
        rm -f "$OUTPUT_FILE"
    fi
    touch "$OUTPUT_FILE"
    
    # Enum başlatma
    echo "${BOLD}Starting DragonEye Enumeration${ENDC}"
    echo "Profile: $PROFILE"
    echo "Platform: $PLATFORM"
    echo "Output: $OUTPUT_FILE"
    echo "Verbose: ${VERBOSE:-off}"
    echo ""
    
    # Platforma özgü enum
    case $PLATFORM in
        linux)
            linux_enum "$PROFILE" "$VERBOSE" "$OUTPUT_FILE"
            ;;
        macos)
            macos_enum "$PROFILE" "$VERBOSE" "$OUTPUT_FILE"
            ;;
        windows)
            windows_enum "$PROFILE" "$VERBOSE" "$OUTPUT_FILE"
            ;;
    esac
    
    # Tamamlandı
    echo "${OKGREEN}"
    echo "██████████████████████████████████████████████████████████████████████████"
    echo "█ Enumeration completed! Report saved to: $OUTPUT_FILE"
    echo "██████████████████████████████████████████████████████████████████████████"
    echo "${ENDC}"
    
    # Güvenlik uyarısı
    if [ "$PLATFORM" != "windows" ]; then
        echo "${WARNING}"
    else
        echo ""
    fi
    echo "WARNING: This report may contain sensitive information!"
    echo "         Please handle with appropriate security measures."
    echo "${ENDC}"
}

# Windows için uyumluluk
if [ "$OS" = "Windows_NT" ]; then
    # Windows'ta bu scriptin çalışması için ek ayarlar
    if [ -z "$SHELL" ]; then
        # cmd.exe içinde çalışıyorsa
        echo "Please run this script in PowerShell for best results"
        echo "Or use: powershell -ExecutionPolicy Bypass -File dragoneye.ps1"
        exit 1
    fi
fi

# Ana fonksiyonu çalıştır
main "$@" 