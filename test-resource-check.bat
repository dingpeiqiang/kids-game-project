@echo off
chcp 65001 >nul
echo.
echo ============================================
echo    游戏资源检查功能测试
echo ============================================
echo.

echo [1/3] 清理前端缓存...
cd kids-game-frontend
if exist node_modules\.vite (
    rmdir /s /q node_modules\.vite
    echo ✅ 已清理 Vite 缓存
) else (
    echo ℹ️  Vite 缓存不存在
)

if exist dist (
    rmdir /s /q dist
    echo ✅ 已清理 dist 目录
) else (
    echo ℹ️  dist 目录不存在
)
echo.

echo [2/3] 启动前端服务...
echo 请在浏览器中打开 http://localhost:5173
echo.
echo 测试步骤：
echo 1. 登录系统
echo 2. 点击游戏卡片
echo 3. 选择游戏模式
echo 4. 打开浏览器 F12 控制台
echo 5. 查找 "[ResourceChecker]" 开头的日志
echo 6. 观察是否有资源检查的提示
echo.
echo 预期日志示例：
echo   [ResourceChecker] 开始检查游戏资源
echo   [ResourceChecker] 步骤 1: 检查游戏信息...
echo   [ResourceChecker] 步骤 2: 检查游戏 URL...
echo   [ResourceChecker] 步骤 3: 检查游戏 URL 可访问性...
echo   [ResourceChecker] 游戏资源检查通过
echo.

start cmd /k "npm run dev"
echo ✅ 前端服务已启动
echo.

echo [3/3] 验证功能...
echo.
echo 请按照以下场景测试：
echo.
echo 场景 1：正常游戏
echo   - 预期：资源检查通过，进入游戏
echo.
echo 场景 2：游戏未配置 URL（需要在数据库中设置 gameUrl = NULL）
echo   - 预期：提示"游戏未配置访问地址，请联系管理员"
echo.
echo 场景 3：游戏已下线（需要在数据库中设置 status = 0）
echo   - 预期：提示"游戏已下线或维护中，请稍后再试"
echo.
echo 场景 4：游戏不存在（使用无效的 gameCode）
echo   - 预期：提示"游戏不存在或已下线"
echo.

echo ============================================
echo    测试指南已生成，请查看上方说明
echo ============================================
echo.
pause
