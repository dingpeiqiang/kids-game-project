@echo off
chcp 65001 >nul
echo ========================================
echo    退出登录功能测试工具
echo ========================================
echo.
echo 此脚本将帮助你测试退出登录功能
echo.
echo ========================================
echo 修复内容：
echo ========================================
echo.
echo 1. ✅ 修复了 logoutKid() 方法
echo    - 现在会清除 authToken、refreshToken
echo    - 确保完全退出登录状态
echo.
echo 2. ✅ 修复了 logoutParent() 方法
echo    - 现在会清除 parentToken、refreshToken
echo    - 确保家长账号完全退出
echo.
echo 3. ✅ 优化了退出登录弹窗样式
echo    - 添加了副标题说明
echo    - 优化了按钮大小和间距
echo    - 使用红色危险按钮强调退出操作
echo    - 按钮文字更清晰（"继续玩" vs "确认退出"）
echo.
echo ========================================
echo 测试步骤：
echo ========================================
echo.
echo 【测试 1】儿童退出登录
echo 1. 以儿童账号登录系统
echo 2. 点击右上角的退出按钮（🚪）
echo 3. 查看退出确认弹窗：
echo    - 标题："确认退出"
echo    - 副标题："退出后需要重新登录才能继续游戏哦"
echo    - 图标：🤔（思考的表情）
echo    - 两个按钮："继续玩"（灰色）和 "确认退出"（红色）
echo 4. 点击"确认退出"按钮
echo 5. 验证：
echo    - 自动跳转到登录页
echo    - 浏览器 F12 ^> Application ^> Local Storage 中：
echo      * authToken 应该被删除
echo      * userInfo 应该被删除
echo      * refreshToken 应该被删除
echo    - 刷新页面后不会自动登录
echo.
echo 【测试 2】家长退出登录
echo 1. 以家长账号登录系统
echo 2. 点击右上角的退出按钮
echo 3. 查看退出确认弹窗：
echo    - 标题："确认退出"
echo    - 副标题："退出后需要重新登录才能管理孩子哦"
echo    - 图标：🤔
echo    - 两个按钮："继续管理"和 "确认退出"（红色）
echo 4. 点击"确认退出"按钮
echo 5. 验证：
echo    - 自动跳转到登录页
echo    - Local Storage 中：
echo      * parentToken 应该被删除
echo      * parentInfo 应该被删除
echo      * refreshToken 应该被删除
echo.
echo 【测试 3】取消退出
echo 1. 点击退出按钮打开弹窗
echo 2. 点击"继续玩"或"继续管理"按钮
echo 3. 验证：
echo    - 弹窗关闭
echo    - 仍然停留在当前页面
echo    - 未退出登录
echo.
echo ========================================
echo 调试技巧：
echo ========================================
echo.
echo 如果退出登录后仍然可以访问页面：
echo.
echo 1. 打开浏览器 F12 开发者工具
echo 2. 在 Console 中运行：
echo    localStorage.clear()
echo    sessionStorage.clear()
echo 3. 刷新页面
echo.
echo 如果弹窗样式不正确：
echo.
echo 1. 清除前端缓存：
echo    cd kids-game-frontend
echo    Remove-Item -Recurse -Force node_modules\.vite, dist
echo    npm run dev
echo.
echo 2. 强制刷新浏览器（Ctrl+Shift+R）
echo.
echo ========================================
pause
