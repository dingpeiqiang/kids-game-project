@echo off
chcp 65001 >nul
echo ========================================
echo 贪吃蛇游戏登录验证测试
echo ========================================
echo.

echo [测试 1] 测试后端未登录访问主题列表
echo ----------------------------------------
curl -s http://localhost:8080/api/theme/list?status=on_sale^&page=1^&pageSize=5 > temp_result.json
findstr /C:"401" temp_result.json >nul
if %errorlevel% equ 0 (
    echo ✅ 正确：未登录返回 401
) else (
    echo ❌ 错误：未登录应该返回 401
    type temp_result.json
)
del temp_result.json >nul 2>&1
echo.

echo [测试 2] 测试后端未登录下载主题
echo ----------------------------------------
curl -s http://localhost:8080/api/theme/download?id=1 > temp_result.json
findstr /C:"401" temp_result.json >nul
if %errorlevel% equ 0 (
    echo ✅ 正确：未登录返回 401
) else (
    findstr /C:"请先登录" temp_result.json >nul
    if %errorlevel% equ 0 (
        echo ✅ 正确：返回"请先登录"错误
    ) else (
        echo ❌ 错误：应该返回 401 或"请先登录"
        type temp_result.json
    )
)
del temp_result.json >nul 2>&1
echo.

echo [测试 3] 检查前端路由守卫
echo ----------------------------------------
if exist "kids-game-house\snake-vue3\src\router\index.ts" (
    findstr /C:"beforeEach" kids-game-house\snake-vue3\src\router\index.ts >nul
    if %errorlevel% equ 0 (
        echo ✅ 路由守卫已添加
    ) else (
        echo ❌ 路由守卫未找到
    )
) else (
    echo ❌ 路由文件不存在
)
echo.

echo [测试 4] 检查主题加载逻辑
echo ----------------------------------------
if exist "kids-game-house\snake-vue3\src\stores\theme.ts" (
    findstr /C:"localStorage.getItem('token')" kids-game-house\snake-vue3\src\stores\theme.ts >nul
    if %errorlevel% equ 0 (
        echo ✅ Token 检查已添加
    ) else (
        echo ❌ Token 检查未找到
    )
    
    findstr /C:"window.location.href" kids-game-house\snake-vue3\src\stores\theme.ts >nul
    if %errorlevel% equ 0 (
        echo ✅ 登录跳转已添加
    ) else (
        echo ❌ 登录跳转未找到
    )
) else (
    echo ❌ 主题 store 文件不存在
)
echo.

echo [测试 5] 检查 SecurityConfig
echo ----------------------------------------
if exist "kids-game-backend\kids-game-common\src\main\java\com\kidgame\common\config\SecurityConfig.java" (
    findstr /C:"api/theme/list" kids-game-backend\kids-game-common\src\main\java\com\kidgame\common\config\SecurityConfig.java >nul
    if %errorlevel% equ 0 (
        echo ❌ 错误：主题接口仍在公开访问列表中
    ) else (
        echo ✅ 主题接口已从公开访问列表移除
    )
) else (
    echo ❌ SecurityConfig 文件不存在
)
echo.

echo ========================================
echo 测试完成
echo ========================================
echo.
echo 接下来请执行以下操作：
echo.
echo 1. 重新编译并启动后端：
echo    cd kids-game-backend
echo    mvn clean install -DskipTests
echo    mvn spring-boot:run
echo.
echo 2. 启动主系统前端：
echo    cd kids-game-frontend
echo    npm run dev
echo.
echo 3. 启动贪吃蛇游戏：
echo    cd kids-game-house\snake-vue3
echo    npm run dev
echo.
echo 4. 测试未登录访问：
echo    - 打开浏览器，清除所有缓存和 localStorage
echo    - 访问 http://localhost:5174
echo    - 应该自动跳转到 http://localhost:5173/login
echo.
echo 5. 测试已登录访问：
echo    - 在主系统登录
echo    - 访问 http://localhost:5174
echo    - 应该正常显示贪吃蛇游戏
echo.
pause
