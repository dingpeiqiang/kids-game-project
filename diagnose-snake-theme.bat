@echo off
chcp 65001 >nul
echo.
echo ========================================
echo    贪吃蛇主题加载诊断工具
echo ========================================
echo.

echo [1/5] 检查后端服务...
curl -s http://localhost:8080/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 后端服务未运行
    echo    请先启动后端：cd kids-game-backend ^&^& mvn spring-boot:run
    goto :end
) else (
    echo ✅ 后端服务正常运行
)

echo.
echo [2/5] 检查前端服务...
curl -s http://localhost:5173 >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 前端服务未运行
    echo    请先启动前端：cd kids-game-house\snake-vue3 ^&^& npm run dev
    goto :end
) else (
    echo ✅ 前端服务正常运行
)

echo.
echo [3/5] 检查主题 API...
curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/theme/list?status=on_sale^&page=1^&pageSize=10 > %temp%\http_code.txt
set /p http_code=<%temp%\http_code.txt
if "%http_code%"=="200" (
    echo ✅ 主题列表 API 正常
) else if "%http_code%"=="401" (
    echo ⚠️  主题列表 API 需要认证（这是正常的）
) else (
    echo ❌ 主题列表 API 异常，HTTP 状态码：%http_code%
)

echo.
echo [4/5] 检查数据库主题数据...
echo    提示：需要手动检查数据库中是否有主题数据
echo    MySQL 命令：
echo    USE kids_game;
echo    SELECT * FROM t_theme WHERE status = 'on_sale' LIMIT 5;

echo.
echo [5/5] 生成测试 URL...
echo.
echo ========================================
echo 测试步骤：
echo ========================================
echo.
echo 1. 打开浏览器访问：http://localhost:5173
echo 2. 使用测试账号登录
echo 3. 在首页选择主题
echo 4. 点击开始游戏
echo 5. 打开浏览器开发者工具（F12）
echo 6. 查看 Console 标签页，检查以下日志：
echo.
echo    预期日志：
echo    - 🎨 游戏启动，主题 ID: [主题ID]
echo    - 🎨 正在加载主题配置，themeId: [主题ID]
echo    - ✅ 主题配置加载成功
echo    - 🎨 开始加载主题资源
echo    - 🎨 加载图片: snakeHead -^> [URL]
echo    - ✅ 主题资源加载完成
echo.
echo 7. 查看 Network 标签页，检查：
echo    - /api/theme/download 请求是否成功（200）
echo    - 图片资源请求是否成功（200）
echo    - 音频资源请求是否成功（200）
echo.
echo 8. 进入游戏后，验证：
echo    - 蛇的外观是否改变
echo    - 食物的外观是否改变
echo    - 背景颜色或背景图是否改变
echo    - 音效是否改变
echo.

:end
echo.
echo ========================================
echo 诊断完成！
echo ========================================
echo.
echo 如需详细测试指南，请查看：test-snake-theme.md
echo.
pause
