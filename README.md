# 🔍 DragonEye - Advanced System Enumeration Tool

DragonEye is a comprehensive system enumeration and security assessment tool designed for security professionals, penetration testers, and system administrators. It provides detailed system analysis with cross-platform support and generates interactive HTML reports.

## 🚀 Quick Start

1. Clone the repository:
```bash
git clone https://github.com/frknaykc/DragonEye.git
cd DragonEye
```

2. Make scripts executable:
```bash
chmod +x dragoneye.sh dragoneye_macos.sh report_generator.sh
```

## 📖 Basic Usage

### Linux:
```bash
./dragoneye.sh                  # Interactive mode
./dragoneye.sh ctf             # CTF mode
./dragoneye.sh pentest         # Pentest mode
```

### macOS:
```bash
./dragoneye_macos.sh           # Full system enumeration
```

### Windows:
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
./dragoneye.ps1               # Full system enumeration
```

### Report Generation:
```bash
# Generate HTML report from enumeration output
./report_generator.sh dragoneye_report.txt
```

## 🌟 Features

### Core Capabilities
- **Zero Dependencies**: Works with native system commands
- **Cross-Platform Support**: 
  - Linux (`dragoneye.sh`)
  - macOS (`dragoneye_macos.sh`)
  - Windows (`dragoneye.ps1`)
- **Multiple Operation Modes**:
  - Interactive Mode: Guided enumeration
  - CTF Mode: Quick checks for CTF challenges
  - Pentest Mode: Comprehensive security assessment

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

## 📊 Advanced Reporting

### HTML Report Features:
- Modern, responsive design
- Interactive navigation
- Search functionality
- Section-based organization
- Color-coded findings:
  - 🔴 Critical Issues
  - 🟡 Warnings
  - 🟢 Passed Checks
- Command copying
- Executive summary

## 🛡️ Security Considerations

- **Sensitive Information**: Reports may contain sensitive system data
- **Elevated Privileges**: Some checks require root/administrator access
- **System Impact**: Certain checks might trigger security controls
- **Data Handling**: Handle generated reports with appropriate security measures

## 🔧 Advanced Usage Examples

### 1. CTF Mode with Custom Output:
```bash
./dragoneye.sh ctf output.txt
```

### 2. Pentest Mode with Verbose Output:
```bash
./dragoneye.sh pentest --verbose
```

### 3. macOS Security Audit:
```bash
./dragoneye_macos.sh
./report_generator.sh dragoneye_macos_*.txt
```

## 📝 Output Formats

### 1. Raw Text:
- Detailed command output
- Timestamped entries
- Exit codes
- Error messages

### 2. HTML Report:
- Interactive interface
- Responsive design
- Searchable content
- Categorized findings
- Visual indicators
- Command copying
- Section navigation

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests, report bugs, and suggest enhancements.

## 🔒 Security

For security-related matters, please review our [Security Policy](SECURITY.md) before reporting any security vulnerabilities.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool is intended for authorized security testing and system administration only. Users are responsible for obtaining appropriate permissions before running security assessments. 