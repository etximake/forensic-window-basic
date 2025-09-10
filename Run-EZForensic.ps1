<# 
    Script: Run-EZForensic.ps1
    Tác giả: bo-mmo
    Mục tiêu: Tự động chạy các công cụ (EvtxECmd, PECmd, LECmd, JLECmd, RECmd) 
              để phân tích lịch sử hoạt động Windows 
              và gom kết quả thành một Timeline CSV.
#>

# ============================
# 0. Thiết lập biến môi trường
# ============================
$EZToolsPath = "C:\EZTools"              # Thư mục chứa Tools
$OutputPath  = "C:\ForensicOutput"       # Thư mục xuất kết quả
$TimelineCSV = "$OutputPath\Timeline_All.csv"

# Tạo thư mục output nếu chưa có
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

# ============================
# 1. Phân tích Event Logs
# ============================
Write-Host "[*] Phân tích Event Logs (Security.evtx)..."
& "$EZToolsPath\EvtxECmd\EvtxECmd.exe" -f "C:\Windows\System32\winevt\Logs\Security.evtx" --csv $OutputPath

# ============================
# 2. Phân tích Prefetch
# ============================
Write-Host "[*] Phân tích Prefetch..."
& "$EZToolsPath\PECmd\PECmd.exe" -d "C:\Windows\Prefetch" --csv $OutputPath

# ============================
# 3. Phân tích LNK Files
# ============================
Write-Host "[*] Phân tích Shortcut (LNK)..."
$UserDirs = Get-ChildItem "C:\Users\" -Directory
foreach ($User in $UserDirs) {
    $RecentPath = "C:\Users\$($User.Name)\AppData\Roaming\Microsoft\Windows\Recent"
    if (Test-Path $RecentPath) {
        & "$EZToolsPath\LECmd\LECmd.exe" -d $RecentPath --csv $OutputPath
    }
}

# ============================
# 4. Phân tích JumpLists
# ============================
Write-Host "[*] Phân tích JumpLists..."
foreach ($User in $UserDirs) {
    $JLPath = "C:\Users\$($User.Name)\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"
    if (Test-Path $JLPath) {
        & "$EZToolsPath\JLECmd\JLECmd.exe" -d $JLPath --csv $OutputPath
    }
}

# ============================
# 5. Phân tích Registry (UserAssist)
# ============================
Write-Host "[*] Phân tích Registry (UserAssist)..."
foreach ($User in $UserDirs) {
    $NTUserDat = "C:\Users\$($User.Name)\NTUSER.DAT"
    if (Test-Path $NTUserDat) {
        & "$EZToolsPath\RECmd\RECmd.exe" -f $NTUserDat --csv $OutputPath
    }
}

# ============================
# 6. Gom kết quả thành Timeline
# ============================
Write-Host "[*] Gom tất cả CSV thành timeline..."
$AllCSVs = Get-ChildItem $OutputPath -Filter *.csv
$Combined = @()

foreach ($csv in $AllCSVs) {
    $Data = Import-Csv $csv.FullName
    $Combined += $Data
}

$Combined | Export-Csv -Path $TimelineCSV -NoTypeInformation -Encoding UTF8

Write-Host "[+] Hoàn tất! Timeline lưu tại: $TimelineCSV"
