@echo off
chcp 65001 >nul
echo ========================================
echo 贪吃蛇官方主题初始化
echo ========================================
echo.

REM 设置数据库连接参数
REM 根据实际情况修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=kids_game
set DB_USER=root
set DB_PASS=your_password

REM 提示用户输入数据库密码
echo 请输入MySQL数据库密码:
set /p DB_PASS=

echo.
echo 开始初始化贪吃蛇官方主题...
echo.

REM 执行SQL脚本
mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASS% %DB_NAME% < init-snake-official-themes.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✅ 贪吃蛇官方主题初始化成功！
    echo ========================================
    echo.
    echo 下一步操作：
    echo 1. 创建资源文件到服务器目录
    echo    参考 init-snake-official-themes.sql 中的目录结构说明
    echo 2. 重启后端服务
    echo 3. 在创作者中心测试主题加载功能
    echo.
) else (
    echo.
    echo ========================================
    echo ❌ 初始化失败！
    echo ========================================
    echo.
    echo 请检查：
    echo 1. MySQL服务是否运行
    echo 2. 数据库连接参数是否正确
    echo 3. 用户是否有足够的权限
    echo.
)

pause
