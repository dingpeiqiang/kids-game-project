@echo off
chcp 65001 > nul
echo ========================================
echo 初始化贪吃蛇和植物大战僵尸主题
echo ========================================
echo.

set MYSQL_USER=root
set MYSQL_DB=kids_game

echo 请输入MySQL密码:
set /p MYSQL_PASSWORD=

echo.
echo 正在执行初始化脚本...
echo.

mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DB% < init-missing-game-themes.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✓ 初始化成功！
    echo ========================================
    echo.
    echo 已完成以下操作：
    echo 1. 创建贪吃蛇专属主题（清新绿、经典复古）
    echo 2. 创建植物大战僵尸专属主题（阳光活力、月夜幽深）
    echo 3. 建立主题-游戏关联关系
    echo.
    echo 现在可以在创作者中心看到这些游戏的主题了！
    echo 请重启后端服务以使更改生效
) else (
    echo.
    echo ========================================
    echo ✗ 初始化失败！
    echo ========================================
    echo.
    echo 请检查：
    echo 1. MySQL是否运行
    echo 2. 用户名密码是否正确
    echo 3. 数据库是否存在
    echo 4. 游戏数据是否存在（先执行 fix-theme-game-code.bat）
)

echo.
pause
