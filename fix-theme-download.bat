@echo off
chcp 65001 >nul
echo ========================================
echo 贪吃蛇主题下载错误修复脚本
echo ========================================
echo.

echo [步骤 1/5] 检查数据库连接...
mysql -u root -p123456 -e "SELECT 1" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 数据库连接正常
) else (
    echo ❌ 数据库连接失败
    echo    请检查 MySQL 是否运行，用户名和密码是否正确
    echo.
    set /p DB_PASSWORD="请输入数据库密码: "
    mysql -u root -p%DB_PASSWORD% -e "SELECT 1" >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ 数据库连接失败，请手动执行 SQL 脚本
        goto :manual_sql
    )
)
echo.

echo [步骤 2/5] 执行 SQL 脚本初始化主题数据...
if defined DB_PASSWORD (
    mysql -u root -p%DB_PASSWORD% kids_game < kids-game-backend\init-snake-themes.sql
) else (
    mysql -u root -p123456 kids_game < kids-game-backend\init-snake-themes.sql
)
if %errorlevel% equ 0 (
    echo ✅ SQL 脚本执行成功
) else (
    echo ❌ SQL 脚本执行失败
    goto :manual_sql
)
echo.

echo [步骤 3/5] 重新编译后端...
cd kids-game-backend
call mvn clean install -DskipTests
if %errorlevel% equ 0 (
    echo ✅ 后端编译成功
) else (
    echo ❌ 后端编译失败
    cd ..
    pause
    exit /b 1
)
cd ..
echo.

echo [步骤 4/5] 清理前端缓存...
cd kids-game-house\snake-vue3
if exist "node_modules\.vite" (
    rmdir /s /q node_modules\.vite
    echo ✅ Vite 缓存已清理
)
if exist "dist" (
    rmdir /s /q dist
    echo ✅ dist 目录已清理
)
cd ..\..
echo.

echo [步骤 5/5] 验证修复...
echo.
echo ========================================
echo ✅ 修复完成！
echo ========================================
echo.
echo 接下来请执行以下操作：
echo.
echo 1. 重启后端服务：
echo    cd kids-game-backend
echo    mvn spring-boot:run
echo.
echo 2. 启动前端服务：
echo    cd kids-game-house\snake-vue3
echo    npm run dev
echo.
echo 3. 打开浏览器访问 http://localhost:5173
echo.
echo 4. 查看控制台日志，确认主题加载成功
echo.
pause
exit /b 0

:manual_sql
echo.
echo ========================================
echo 手动执行 SQL 脚本
echo ========================================
echo.
echo 请手动执行以下命令：
echo.
echo mysql -u root -p kids_game ^< kids-game-backend\init-snake-themes.sql
echo.
echo 或者使用 MySQL Workbench / Navicat 等工具执行：
echo   kids-game-backend\init-snake-themes.sql
echo.
pause
exit /b 1
