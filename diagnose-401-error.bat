@echo off
chcp 65001 >nul
echo ========================================
echo    401 错误诊断工具
echo ========================================
echo.
echo 此脚本将帮助你诊断 /api/game/start 接口的 401 错误
echo.
echo 请在浏览器中按 F12 打开开发者工具，然后：
echo 1. 切换到 Console 标签
echo 2. 运行以下命令检查 token：
echo.
echo    localStorage.getItem('authToken')
echo    localStorage.getItem('parentToken')
echo.
echo 3. 如果返回 null，说明你没有登录或 token 已丢失
echo 4. 如果有值，请复制 token 内容
echo.
echo ========================================
echo 常见原因及解决方案：
echo ========================================
echo.
echo 【原因 1】未登录
echo   解决：请先登录，确保登录成功后再访问游戏
echo.
echo 【原因 2】Token 已过期
echo   解决：重新登录获取新 token
echo.
echo 【原因 3】使用了错误的 API 服务实例
echo   解决：确保使用 gameApi 而不是直接 fetch
echo.
echo 【原因 4】后端 SecurityConfig 配置问题
echo   解决：检查后端是否将 /api/game/start 添加到公开接口列表
echo.
echo ========================================
echo 快速测试方法：
echo ========================================
echo.
echo 在浏览器 Console 中运行：
echo.
echo // 检查 token
echo const token = localStorage.getItem('authToken') || localStorage.getItem('parentToken');
echo console.log('Token:', token ? '存在' : '不存在');
echo.
echo // 测试 API 调用
echo fetch('http://localhost:8080/api/game/start', {
echo   method: 'POST',
echo   headers: {
echo     'Content-Type': 'application/json',
echo     'Authorization': `Bearer ${token}`
echo   },
echo   body: JSON.stringify({ kidId: 1, gameId: 1 })
echo }).then(r =^> r.json()).then(console.log);
echo.
echo ========================================
pause
