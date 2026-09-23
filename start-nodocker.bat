@echo off
setlocal

set "ROOT=%~dp0"

echo 正在启动 群像（无 Docker 模式）...
echo.

rem 清理上次异常退出的残留锁文件（仅在 PostgreSQL 没在运行时才清理，安全）
tasklist /FI "IMAGENAME eq postgres.exe" 2>nul | find /I "postgres.exe" >nul
if errorlevel 1 (
    if exist "%ROOT%storage\pgdata\postmaster.pid" (
        echo 检测到上次异常退出的残留锁文件，已自动清理。
        del /q "%ROOT%storage\pgdata\postmaster.pid"
    )
)

echo [1/2] 启动嵌入式 PostgreSQL...
start "群像 - 数据库" cmd /k "cd /d ""%ROOT%"" && node scripts\pg-server.mjs start"
timeout /t 8 /nobreak >nul

echo [2/2] 启动 API 与网页...
start "群像 - API" cmd /k "cd /d ""%ROOT%api"" && pnpm dev"
start "群像 - Web" cmd /k "cd /d ""%ROOT%web"" && pnpm dev"

echo   API: http://localhost:3001
echo   Web: http://localhost:5173
echo.
echo 等待 8 秒后打开浏览器...
timeout /t 8 /nobreak >nul
start http://localhost:5173

echo.
echo 已打开三个服务窗口（数据库 / API / Web）。
echo 测试期间请保持窗口开启：可以最小化，但不要点 X 关闭。
echo 要停止全部服务，请双击桌面上的「群像（停止）」。
echo.
echo 按任意键退出本窗口（服务窗口不受影响）...
pause >nul
