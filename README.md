# 🔍 DragonEye - Advanced System Enumeration Tool

DragonEye is a comprehensive system enumeration and security assessment tool designed for security professionals, penetration testers, and system administrators. It provides detailed system analysis with cross-platform support and generates interactive HTML reports.

## 🌟 Features

### Core Capabilities
- **Cross-Platform Support**: 
  - Linux (`dragoneye.sh`)
  - macOS (`dragoneye_macos.sh`)
  - Windows (`dragoneye.ps1`)

### Operation Modes
- **Interactive Mode**: Guided enumeration with user prompts
- **CTF Mode**: Quick checks focused on CTF challenges
- **Pentest Mode**: Comprehensive security assessment

### System Analysis
- **System Information**:
  - OS version and build details
  - Hardware specifications
  - CPU and memory information
  - Storage configuration
  - Network adapters

- **Security Checks**:
  - SUID/SGID files
  - World-writable directories
  - Misconfigured permissions
  - Security features status
  - System integrity checks

- **User Analysis**:
  - User permissions
  - Group memberships
  - Login configurations
  - Sudo access
  - Authentication logs

- **Network Security**:
  - Open ports
  - Active connections
  - Network configurations
  - Firewall rules
  - DNS settings

### Platform-Specific Features

#### 🍎 macOS Specific
- FileVault status
- Gatekeeper configuration
- SIP status
- Keychain analysis
- Launch agents/daemons
- Homebrew packages
- System preferences
- Safari settings
- Spotlight configuration

#### 🐧 Linux Specific
- SELinux status
- AppArmor profiles
- systemd services
- Cron jobs
- Package management
- Mount points
- Process capabilities

#### 🪟 Windows Specific
- Registry analysis
- Service configurations
- Scheduled tasks
- Group policies
- PowerShell history
- Event logs
- Share permissions

### 📊 Advanced Reporting
- **Interactive HTML Reports**:
  - Modern, responsive design
  - Search functionality
  - Section navigation
  - Command copying
  - Automatic vulnerability highlighting
  - Executive summary
  - Color-coded findings

## 🚀 Installation

1. Clone the repository:
\`\`\`bash
git clone https://github.com/yourusername/DragonEye.git
cd DragonEye
\`\`\`

2. Make scripts executable:
\`\`\`bash
chmod +x dragoneye.sh dragoneye_macos.sh report_generator.sh
\`\`\`

## 📖 Usage

### Basic Usage

#### Linux:
\`\`\`bash
./dragoneye.sh                  # Interactive mode
./dragoneye.sh ctf             # CTF mode
./dragoneye.sh pentest         # Pentest mode
\`\`\`

#### macOS:
\`\`\`bash
./dragoneye_macos.sh           # Full system enumeration
\`\`\`

#### Windows:
\`\`\`powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
./dragoneye.ps1               # Full system enumeration
\`\`\`

### Report Generation
\`\`\`bash
# Generate HTML report from enumeration output
./report_generator.sh dragoneye_report.txt
\`\`\`

### Advanced Usage Examples

1. **CTF Mode with Custom Output**:
\`\`\`bash
./dragoneye.sh ctf output.txt
\`\`\`

2. **Pentest Mode with Verbose Output**:
\`\`\`bash
./dragoneye.sh pentest --verbose
\`\`\`

3. **macOS Security Audit**:
\`\`\`bash
./dragoneye_macos.sh
./report_generator.sh dragoneye_macos_*.txt
\`\`\`

## 📋 Report Features

The HTML report includes:
- Executive Summary
- System Information
- Security Findings
- Interactive Navigation
- Search Functionality
- Color-Coded Results:
  - 🔴 Critical Issues
  - 🟡 Warnings
  - 🟢 Passed Checks

## 🛡️ Security Considerations

- **Sensitive Information**: Reports may contain sensitive system data
- **Elevated Privileges**: Some checks require root/administrator access
- **System Impact**: Certain checks might trigger security controls
- **Data Handling**: Handle generated reports with appropriate security measures

## 🔄 Output Formats

1. **Raw Text**:
   - Detailed command output
   - Timestamped entries
   - Exit codes
   - Error messages

2. **HTML Report**:
   - Interactive interface
   - Responsive design
   - Searchable content
   - Categorized findings
   - Visual indicators
   - Command copying
   - Section navigation

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests, report bugs, or suggest new features.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This tool is intended for authorized security testing and system administration only. Users are responsible for obtaining appropriate permissions before running security assessments. 