@echo off
setlocal
echo 正在停止群像全部服务...
echo.

echo [1/3] 停止数据库（PostgreSQL）...
taskkill /F /IM postgres.exe >nul 2>&1

echo [2/3] 停止数据库守护进程（pg-server）...
powershell -NoProfile -Command "Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'node.exe' -and $_.CommandLine -like '*pg-server*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }"

echo [3/3] 停止 API 与网页...
powershell -NoProfile -Command "Get-NetTCPConnection -LocalPort 3001,5173 -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }"

echo.
echo 已全部停止，可以放心关机或重新启动。
pause
