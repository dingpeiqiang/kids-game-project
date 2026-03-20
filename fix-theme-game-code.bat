@echo off
chcp 65001 > nul
echo ========================================
echo 修复主题游戏代码不一致问题
echo ========================================
echo.

set MYSQL_USER=root
set MYSQL_DB=kids_game

echo 请输入MySQL密码:
set /p MYSQL_PASSWORD=

echo.
echo 正在执行修复脚本...
echo.

mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DB% < fix-theme-game-code.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✓ 修复成功！
    echo ========================================
    echo.
    echo 已完成以下操作：
    echo 1. 更新贪吃蛇游戏代码为 snake-vue3
    echo 2. 添加植物大战僵尸游戏 plants-vs-zombie
    echo 3. 更新主题游戏关联表
    echo.
    echo 请重启后端服务以使更改生效
) else (
    echo.
    echo ========================================
    echo ✗ 修复失败！
    echo ========================================
    echo.
    echo 请检查：
    echo 1. MySQL是否运行
    echo 2. 用户名密码是否正确
    echo 3. 数据库是否存在
)

echo.
pause
