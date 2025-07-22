#!/bin/bash
# DragonEye Report Generator

# HTML Template
generate_html_header() {
    cat << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DragonEye Enumeration Report</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        h2 {
            color: #2980b9;
            margin-top: 30px;
            padding-bottom: 5px;
            border-bottom: 1px solid #bdc3c7;
        }
        .section {
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .command {
            background: #2c3e50;
            color: #fff;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            font-family: monospace;
        }
        .output {
            background: #f1f1f1;
            padding: 10px;
            margin: 10px 0;
            border-left: 4px solid #3498db;
            overflow-x: auto;
            font-family: monospace;
            white-space: pre-wrap;
        }
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .timestamp {
            color: #666;
            font-size: 0.9em;
            text-align: right;
            margin-top: 20px;
        }
        .nav {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 10px;
            border-radius: 4px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .nav a {
            display: block;
            color: #2980b9;
            text-decoration: none;
            margin: 5px 0;
        }
        .nav a:hover {
            color: #3498db;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 10px 0;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #2c3e50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .summary {
            margin: 20px 0;
            padding: 15px;
            background: #e8f4f8;
            border-radius: 5px;
        }
        .vulnerability {
            margin: 10px 0;
            padding: 10px;
            border-left: 4px solid #e74c3c;
            background: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 DragonEye Enumeration Report</h1>
        <div class="timestamp">Generated on: $(date)</div>
EOF
}

generate_html_footer() {
    cat << EOF
    </div>
    <script>
        // Kod bloklarını kopyalama fonksiyonu
        function copyToClipboard(element) {
            const text = element.innerText;
            navigator.clipboard.writeText(text).then(() => {
                alert('Copied to clipboard!');
            });
        }
        
        // Çıktıları filtreleme fonksiyonu
        function filterContent(searchTerm) {
            const sections = document.querySelectorAll('.section');
            sections.forEach(section => {
                const content = section.textContent.toLowerCase();
                if (content.includes(searchTerm.toLowerCase())) {
                    section.style.display = 'block';
                } else {
                    section.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
EOF
}

# Ana fonksiyon
convert_to_html() {
    local input_file=$1
    local output_file="${input_file%.*}.html"
    
    # HTML başlığını oluştur
    generate_html_header > "$output_file"
    
    # İçerik bölümlerini oluştur
    echo "<div class='nav'>" >> "$output_file"
    echo "<input type='text' placeholder='Search...' onkeyup='filterContent(this.value)'>" >> "$output_file"
    echo "<h3>Sections:</h3>" >> "$output_file"
    
    # İçindekiler tablosu oluştur
    grep -E "^\[.*\]" "$input_file" | while read -r section; do
        section_id=$(echo "$section" | tr -d '[]' | tr ' ' '_')
        echo "<a href='#$section_id'>$section</a>" >> "$output_file"
    done
    echo "</div>" >> "$output_file"
    
    # Özet bölümü
    echo "<div class='summary'>" >> "$output_file"
    echo "<h2>Executive Summary</h2>" >> "$output_file"
    echo "<p>System Information:</p>" >> "$output_file"
    grep -A 2 "System Version:" "$input_file" | sed 's/^/    /' >> "$output_file"
    echo "<p>Key Findings:</p><ul>" >> "$output_file"
    
    # Önemli bulguları listele
    if grep -q "VULNERABILITY" "$input_file"; then
        echo "<li class='error'>Security vulnerabilities detected!</li>" >> "$output_file"
    fi
    if grep -q "System Integrity Protection: Disabled" "$input_file"; then
        echo "<li class='warning'>SIP is disabled</li>" >> "$output_file"
    fi
    if grep -q "Password:" "$input_file"; then
        echo "<li class='warning'>Potential password/credential exposure</li>" >> "$output_file"
    fi
    echo "</ul></div>" >> "$output_file"
    
    # Ana içeriği işle
    local current_section=""
    while IFS= read -r line; do
        # Yeni bölüm başlangıcı
        if [[ $line =~ ^\[.*\]$ ]]; then
            # Önceki bölümü kapat
            if [ ! -z "$current_section" ]; then
                echo "</div>" >> "$output_file"
            fi
            
            current_section=$(echo "$line" | tr -d '[]')
            section_id=$(echo "$current_section" | tr ' ' '_')
            echo "<div class='section' id='$section_id'>" >> "$output_file"
            echo "<h2>$current_section</h2>" >> "$output_file"
            continue
        fi
        
        # Komut çıktısını işle
        if [[ $line =~ ^===.*===$ ]]; then
            if [[ $line =~ "Running:" ]]; then
                command=$(echo "$line" | sed -e 's/=== \[ //' -e 's/ \] ===//')
                echo "<div class='command' onclick='copyToClipboard(this)'>$ $command</div>" >> "$output_file"
            fi
        else
            # Normal çıktı
            if [ ! -z "$line" ]; then
                # Güvenlik uyarılarını vurgula
                if [[ $line =~ WARNING|VULNERABILITY|CRITICAL|ERROR ]]; then
                    echo "<div class='error'>$line</div>" >> "$output_file"
                elif [[ $line =~ SUCCESS|OK|PASSED ]]; then
                    echo "<div class='success'>$line</div>" >> "$output_file"
                else
                    echo "<div class='output'>$line</div>" >> "$output_file"
                fi
            fi
        fi
    done < "$input_file"
    
    # Son bölümü kapat
    if [ ! -z "$current_section" ]; then
        echo "</div>" >> "$output_file"
    fi
    
    # HTML footer ekle
    generate_html_footer >> "$output_file"
    
    echo "Report converted to HTML: $output_file"
}

# Ana script
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: Input file not found!"
    exit 1
fi

convert_to_html "$1" 