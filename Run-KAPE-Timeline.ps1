<# 
    Script: Run-KAPE-Timeline.ps1
    Mục tiêu: 
      - Tự động thu thập artifact forensic
      - Tự động phân tích bằng module !EZParser
      - Tự động mở Timeline Explorer để dựng lại lịch sử hoạt động Windows
#>

# ============================
# 0. Biến môi trường
# ============================
$EZToolsPath    = "C:\EZTools"
$KAPEPath       = "$EZToolsPath\KAPE\kape.exe"
$TimelineViewer = "$EZToolsPath\Timeline Explorer\TimelineExplorer.exe"

$TargetDest = "C:\KAPE\Targets"
$ModuleDest = "C:\KAPE\Modules"

# Tạo thư mục nếu chưa có
foreach ($dir in @($TargetDest, $ModuleDest)) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# ============================
# 1. Thu thập artifact (Targets)
# ============================
Write-Host "[*] Đang thu thập artifact (Target: !SANS_Triage) ..."
& $KAPEPath --tsource C:\ --tdest $TargetDest --target !SANS_Triage

# ============================
# 2. Phân tích artifact (Modules)
# ============================
Write-Host "[*] Đang phân tích artifact (Module: !EZParser) ..."
& $KAPEPath --msource $TargetDest --mdest $ModuleDest --module !EZParser

# ============================
# 3. Mở Timeline Explorer
# ============================
if (Test-Path $TimelineViewer) {
    Write-Host "[+] Mở Timeline Explorer..."
    Start-Process $TimelineViewer $ModuleDest
} else {
    Write-Host "[!] Không tìm thấy TimelineExplorer.exe trong $EZToolsPath"
}
