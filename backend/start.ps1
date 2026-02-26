$env:PATH = "D:\Program Files\PostgreSQL\18\bin;" + $env:PATH
$env:RUST_LOG = "info"
Set-Location "D:\Download\wetty-chat-main\backend"
.\target\release\wetty-chat-backend.exe
