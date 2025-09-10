### PHẦN 1:
Bước 1. Tải và cài EZ Tools
Mở PowerShell (Admin).
Chạy:

Set-ExecutionPolicy Bypass -Scope Process -Force
iwr -useb https://f001.backblazeb2.com/file/EricZimmermanTools/Get-ZimmermanTools.ps1 | iex

Toàn bộ công cụ sẽ nằm tại:
C:\EZTools\

Bước 2. Tạo thư mục xuất kết quả
mkdir C:\ForensicOutput

Bước 3. Lưu script
Copy đoạn code Run-EZForensic.ps1 ở trên.
Lưu vào thư mục: C:\EZTools\Run-EZForensic.ps1.

Bước 4. Chạy script
Mở PowerShell (Admin) và chạy:

cd C:\EZTools
.\Run-EZForensic.ps1

📊 3. Kết quả nhận được
Trong thư mục C:\ForensicOutput\ bạn sẽ có:
Các file .csv riêng lẻ (Event Logs, Prefetch, LNK, JumpLists, Registry).
Một file tổng hợp: Timeline_All.csv
👉 Timeline này mở được bằng Excel hoặc Timeline Explorer để dựng lại:
Chương trình nào được chạy (từ Event Log, Prefetch, Registry).
File nào được mở (từ LNK, JumpLists).
Thời điểm và tần suất sử dụng.

### PHẦN 2:
📖 Hướng dẫn sử dụng
Bước 1. Chuẩn bị
Đảm bảo bạn đã cài đặt EZ Tools bằng Get-ZimmermanTools.

KAPE nằm tại: C:\EZTools\KAPE\kape.exe
Timeline Explorer nằm tại: C:\EZTools\Timeline Explorer\TimelineExplorer.exe

Bước 2. Lưu script
Copy code trên → lưu thành file:

C:\EZTools\Run-KAPE-Timeline.ps1

Bước 3. Chạy script
Mở PowerShell (Administrator) và chạy:

cd C:\EZTools
.\Run-KAPE-Timeline.ps1

📊 Kết quả
Thu thập artifact → lưu tại C:\KAPE\Targets
Phân tích artifact → kết quả CSV tại C:\KAPE\Modules
Timeline Explorer sẽ tự động mở và load thư mục C:\KAPE\Modules

👉 Bạn sẽ thấy toàn bộ lịch sử người dùng:
Ứng dụng nào được mở (từ Prefetch, Event Log, UserAssist).
File nào được truy cập (từ LNK, JumpLists).
Thời điểm, tần suất chạy.
Logon, USB, browser history…
