# DragonEye Enumeration Tool v1.5
# PowerShell version for Windows systems

# Banner ve renkler
$colors = @{
    Header = "Magenta"
    OK = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
}

function Show-Banner {
    Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
██████╗ ██████╗  █████╗  ██████╗  ██████╗ ███╗   ██╗███████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝██╔════╝
██║  ██║██████╔╝███████║██║  ███╗██║   ██║██╔██╗ ██║█████╗   ╚████╔╝ █████╗  
██║  ██║██╔══██╗██╔══██║██║   ██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝  ██╔══╝  
██████╔╝██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║███████╗   ██║   ███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor $colors.Header

    Write-Host "DragonEye - Windows Enumeration Tool v1.5`n" -ForegroundColor $colors.Info
}

function Show-Help {
    Write-Host "Usage:"
    Write-Host "  .\dragoneye.ps1                  # Interactive mode"
    Write-Host "  .\dragoneye.ps1 -Profile CTF     # Run CTF profile"
    Write-Host "  .\dragoneye.ps1 -Profile Pentest # Run Pentest profile"
    Write-Host "  .\dragoneye.ps1 -OutputFile file.txt # Custom output file"
    Write-Host "`nProfiles:"
    Write-Host "  CTF     - Fast checks for CTF challenges"
    Write-Host "  Pentest - Comprehensive security checks"
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Type = "Info",
        [string]$OutputFile
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    
    switch ($Type) {
        "Info"    { Write-Host $logMessage -ForegroundColor $colors.Info }
        "Success" { Write-Host $logMessage -ForegroundColor $colors.OK }
        "Warning" { Write-Host $logMessage -ForegroundColor $colors.Warning }
        "Error"   { Write-Host $logMessage -ForegroundColor $colors.Error }
    }
    
    if ($OutputFile) {
        $logMessage | Out-File -Append -FilePath $OutputFile
    }
}

function Invoke-WindowsEnum {
    param(
        [string]$Profile = "Pentest",
        [string]$OutputFile = "dragoneye_report.txt",
        [switch]$Verbose
    )
    
    # Başlangıç bilgileri
    Write-Log "Starting Windows Enumeration (Profile: $Profile)" -Type "Info" -OutputFile $OutputFile
    Write-Log "Output will be saved to: $OutputFile" -Type "Info" -OutputFile $OutputFile
    
    # Sistem Bilgileri
    Write-Log "`n[*] Gathering System Information..." -Type "Info" -OutputFile $OutputFile
    $commands = @{
        "System Info" = "systeminfo"
        "OS Version" = "ver"
        "Environment" = "Get-ChildItem Env: | Format-Table -AutoSize"
        "Hostname" = "hostname"
        "CPU Info" = "Get-WmiObject Win32_Processor | Select-Object Name,NumberOfCores"
        "Memory Info" = "Get-WmiObject Win32_PhysicalMemory | Select-Object Capacity,Speed"
        "Disk Info" = "Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID,Size,FreeSpace"
    }
    
    foreach ($cmd in $commands.GetEnumerator()) {
        Write-Log "`n=== [ $($cmd.Key) ] ===" -OutputFile $OutputFile
        try {
            $result = Invoke-Expression $cmd.Value 2>&1
            $result | Out-File -Append -FilePath $OutputFile
            if ($Verbose) {
                Write-Log "Executed: $($cmd.Value)" -Type "Success"
            }
        }
        catch {
            Write-Log "Error executing $($cmd.Key): $_" -Type "Error" -OutputFile $OutputFile
        }
    }
    
    # Kullanıcı ve Yetki Bilgileri
    Write-Log "`n[*] Gathering User Information..." -Type "Info" -OutputFile $OutputFile
    $userCommands = @{
        "Current User" = "whoami"
        "User Privileges" = "whoami /priv"
        "Local Users" = "net user"
        "Local Groups" = "net localgroup"
        "Admin Group" = "net localgroup administrators"
    }
    
    foreach ($cmd in $userCommands.GetEnumerator()) {
        Write-Log "`n=== [ $($cmd.Key) ] ===" -OutputFile $OutputFile
        try {
            $result = Invoke-Expression $cmd.Value 2>&1
            $result | Out-File -Append -FilePath $OutputFile
            if ($Verbose) {
                Write-Log "Executed: $($cmd.Value)" -Type "Success"
            }
        }
        catch {
            Write-Log "Error executing $($cmd.Key): $_" -Type "Error" -OutputFile $OutputFile
        }
    }
    
    # Ağ Bilgileri
    Write-Log "`n[*] Gathering Network Information..." -Type "Info" -OutputFile $OutputFile
    $networkCommands = @{
        "Network Interfaces" = "ipconfig /all"
        "Network Routes" = "route print"
        "Network Connections" = "netstat -ano"
        "Firewall Rules" = "netsh advfirewall show currentprofile"
        "DNS Cache" = "ipconfig /displaydns"
    }
    
    foreach ($cmd in $networkCommands.GetEnumerator()) {
        Write-Log "`n=== [ $($cmd.Key) ] ===" -OutputFile $OutputFile
        try {
            $result = Invoke-Expression $cmd.Value 2>&1
            $result | Out-File -Append -FilePath $OutputFile
            if ($Verbose) {
                Write-Log "Executed: $($cmd.Value)" -Type "Success"
            }
        }
        catch {
            Write-Log "Error executing $($cmd.Key): $_" -Type "Error" -OutputFile $OutputFile
        }
    }
    
    # Pentest Profili için Ek Kontroller
    if ($Profile -eq "Pentest") {
        Write-Log "`n[*] Running Additional Pentest Checks..." -Type "Info" -OutputFile $OutputFile
        $pentestCommands = @{
            "Scheduled Tasks" = "schtasks /query /fo LIST"
            "Running Services" = "Get-Service | Where-Object {`$_.Status -eq 'Running'}"
            "Installed Software" = "Get-WmiObject -Class Win32_Product | Select-Object Name,Version"
            "Startup Programs" = "Get-CimInstance Win32_StartupCommand | Select-Object Name,Command"
            "Registry AutoRuns" = @(
                "reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
                "reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
            )
        }
        
        foreach ($cmd in $pentestCommands.GetEnumerator()) {
            Write-Log "`n=== [ $($cmd.Key) ] ===" -OutputFile $OutputFile
            try {
                if ($cmd.Value -is [array]) {
                    foreach ($subCmd in $cmd.Value) {
                        $result = Invoke-Expression $subCmd 2>&1
                        $result | Out-File -Append -FilePath $OutputFile
                        if ($Verbose) {
                            Write-Log "Executed: $subCmd" -Type "Success"
                        }
                    }
                }
                else {
                    $result = Invoke-Expression $cmd.Value 2>&1
                    $result | Out-File -Append -FilePath $OutputFile
                    if ($Verbose) {
                        Write-Log "Executed: $($cmd.Value)" -Type "Success"
                    }
                }
            }
            catch {
                Write-Log "Error executing $($cmd.Key): $_" -Type "Error" -OutputFile $OutputFile
            }
        }
    }
    
    # CTF Profili için Ek Kontroller
    if ($Profile -eq "CTF") {
        Write-Log "`n[*] Running CTF-specific Checks..." -Type "Info" -OutputFile $OutputFile
        $ctfCommands = @{
            "Flag Files" = "Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {`$_.Name -like '*flag*'}"
            "Hidden Files" = "Get-ChildItem -Path C:\ -Recurse -Hidden -ErrorAction SilentlyContinue"
            "Interesting Files" = "Get-ChildItem -Path C:\ -Include *.txt,*.doc,*.pdf -Recurse -ErrorAction SilentlyContinue | Where-Object {`$_.Name -match 'password|secret|flag'}"
        }
        
        foreach ($cmd in $ctfCommands.GetEnumerator()) {
            Write-Log "`n=== [ $($cmd.Key) ] ===" -OutputFile $OutputFile
            try {
                $result = Invoke-Expression $cmd.Value 2>&1
                $result | Out-File -Append -FilePath $OutputFile
                if ($Verbose) {
                    Write-Log "Executed: $($cmd.Value)" -Type "Success"
                }
            }
            catch {
                Write-Log "Error executing $($cmd.Key): $_" -Type "Error" -OutputFile $OutputFile
            }
        }
    }

    # Yeni güvenlik kontrolleri ekle
    if ($Profile -eq "Pentest") {
        Write-Log "`n[*] Checking for Privilege Escalation Vectors..." -Type "Info" -OutputFile $OutputFile
        
        # AlwaysInstalledElevated kontrolü
        $elevatedPaths = @(
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer",
            "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
        )
        foreach ($path in $elevatedPaths) {
            if (Test-Path $path) {
                $elevated = (Get-ItemProperty -Path $path -Name AlwaysInstallElevated -ErrorAction SilentlyContinue).AlwaysInstallElevated
                if ($elevated -eq 1) {
                    Write-Log "AlwaysInstallElevated enabled at $path" -Type "Warning" -OutputFile $OutputFile
                }
            }
        }

        # AutoAdminLogon kontrolü
        $winlogon = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
        if (Test-Path $winlogon) {
            $autoAdminLogon = (Get-ItemProperty -Path $winlogon -Name AutoAdminLogon -ErrorAction SilentlyContinue).AutoAdminLogon
            if ($autoAdminLogon -eq 1) {
                $defaultUsername = (Get-ItemProperty -Path $winlogon -Name DefaultUserName -ErrorAction SilentlyContinue).DefaultUserName
                $defaultPassword = (Get-ItemProperty -Path $winlogon -Name DefaultPassword -ErrorAction SilentlyContinue).DefaultPassword
                Write-Log "AutoAdminLogon enabled with username: $defaultUsername" -Type "Warning" -OutputFile $OutputFile
            }
        }

        # Unquoted Service Paths
        Write-Log "`n[*] Checking for Unquoted Service Paths..." -Type "Info" -OutputFile $OutputFile
        $unquotedServices = Get-WmiObject -Class Win32_Service | 
            Where-Object {$_.PathName -notmatch '^".*"$' -and $_.PathName -match '\s+'} |
            Select-Object Name, PathName, StartMode
        if ($unquotedServices) {
            Write-Log "Found unquoted service paths:" -Type "Warning" -OutputFile $OutputFile
            $unquotedServices | Format-Table | Out-File -Append -FilePath $OutputFile
        }

        # Stored Credentials
        Write-Log "`n[*] Checking for Stored Credentials..." -Type "Info" -OutputFile $OutputFile
        $storedCreds = cmdkey /list
        if ($storedCreds) {
            Write-Log "Found stored credentials:" -Type "Warning" -OutputFile $OutputFile
            $storedCreds | Out-File -Append -FilePath $OutputFile
        }

        # Sensitive Files Search
        Write-Log "`n[*] Searching for Sensitive Files..." -Type "Info" -OutputFile $OutputFile
        $sensitiveFiles = Get-ChildItem -Path C:\ -Recurse -Include @(
            "*.zip", "*.rar", "*.7z", "*.gz", "*.conf", "*.rdp", "*.kdbx",
            "*.crt", "*.pem", "*.ppk", "*.txt", "*.xml", "*.vnc", "*.ini",
            "unattended.xml", "sysprep.xml", "autounattended.xml",
            "unattended.inf", "sysprep.inf", "autounattended.inf"
        ) -ErrorAction SilentlyContinue

        if ($sensitiveFiles) {
            Write-Log "Found potentially sensitive files:" -Type "Warning" -OutputFile $OutputFile
            $sensitiveFiles | Select-Object FullName, LastWriteTime | 
                Format-Table -AutoSize | Out-File -Append -FilePath $OutputFile
        }

        # Recent Files
        Write-Log "`n[*] Checking Recent Files..." -Type "Info" -OutputFile $OutputFile
        $recentFiles = Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent" -ErrorAction SilentlyContinue
        if ($recentFiles) {
            Write-Log "Recent files:" -Type "Info" -OutputFile $OutputFile
            $recentFiles | Select-Object Name, LastWriteTime | 
                Format-Table -AutoSize | Out-File -Append -FilePath $OutputFile
        }

        # MUICache Check
        Write-Log "`n[*] Checking MUICache for Executed Programs..." -Type "Info" -OutputFile $OutputFile
        $muiCache = Get-ItemProperty "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -ErrorAction SilentlyContinue
        if ($muiCache) {
            Write-Log "Found MUICache entries:" -Type "Info" -OutputFile $OutputFile
            $muiCache.PSObject.Properties | Where-Object { $_.Value -like "*.exe" } |
                Format-Table -AutoSize | Out-File -Append -FilePath $OutputFile
        }

        # File Permissions
        Write-Log "`n[*] Checking for Writable System Files..." -Type "Info" -OutputFile $OutputFile
        $writablePaths = @(
            "$env:SystemRoot\System32",
            "$env:SystemRoot\System32\drivers",
            "C:\Program Files",
            "C:\Program Files (x86)"
        )
        foreach ($path in $writablePaths) {
            if (Test-Path $path) {
                $writableFiles = Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue |
                    Get-Acl -ErrorAction SilentlyContinue |
                    Where-Object { $_.AccessToString -match "Everyone.*Modify|Everyone.*FullControl|BUILTIN\\Users.*Modify|BUILTIN\\Users.*FullControl" }
                if ($writableFiles) {
                    Write-Log "Found writable files in $path:" -Type "Warning" -OutputFile $OutputFile
                    $writableFiles | Select-Object Path | Format-Table -AutoSize | Out-File -Append -FilePath $OutputFile
                }
            }
        }
    }
    
    # Tamamlandı
    Write-Log "`nEnumeration completed! Report saved to: $OutputFile" -Type "Success"
    Write-Log "WARNING: This report may contain sensitive information!" -Type "Warning"
    Write-Log "Please handle with appropriate security measures." -Type "Warning"
}

# Ana fonksiyon
function Main {
    param(
        [string]$Profile = "",
        [string]$OutputFile = "dragoneye_report.txt",
        [switch]$Help,
        [switch]$Verbose
    )
    
    Show-Banner
    
    if ($Help) {
        Show-Help
        return
    }
    
    # Etkileşimli mod
    if (-not $Profile) {
        Write-Host "`nSelect profile:"
        Write-Host "1) CTF"
        Write-Host "2) Pentest"
        Write-Host "3) Custom"
        
        $choice = Read-Host "`nEnter choice (1-3)"
        switch ($choice) {
            "1" { $Profile = "CTF" }
            "2" { $Profile = "Pentest" }
            "3" { $Profile = "Custom" }
            default {
                Write-Log "Invalid choice!" -Type "Error"
                return
            }
        }
        
        $customOutput = Read-Host "Output file [dragoneye_report.txt]"
        if ($customOutput) {
            $OutputFile = $customOutput
        }
        
        $verboseChoice = Read-Host "Enable verbose mode? (y/n) [n]"
        if ($verboseChoice -eq "y") {
            $Verbose = $true
        }
    }
    
    # Enumeration başlat
    Invoke-WindowsEnum -Profile $Profile -OutputFile $OutputFile -Verbose:$Verbose
}

# Scripti çalıştır
try {
    Main @args
}
catch {
    Write-Log "An error occurred: $_" -Type "Error"
    exit 1
} 