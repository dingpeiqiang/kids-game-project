@echo off
chcp 65001 >nul
echo ========================================
echo    /api/game/start 接口修复测试
echo ========================================
echo.
echo 🔧 本次修复内容：
echo.
echo ========================================
echo 修复的问题：
echo ========================================
echo.
echo 1. ✅ 修复参数名称错误
echo    - 问题：前端传递 {kidId, gameId}
echo    - 修复：改为 {userId, gameId}
echo    - 原因：后端期望 userId 字段
echo.
echo 2. ✅ 修复 currentUser 字段引用
echo    - 问题：使用 userStore.currentUser?.kidId
echo    - 修复：改为 userStore.currentUser?.id
echo    - 原因：UserInfo 接口只有 id 字段，没有 kidId
echo.
echo 3. ✅ 添加 GameSession 类型定义
echo    - 新增 GameSession 接口到 api.types.ts
echo    - 包含 sessionId、gameId、userId 等字段
echo.
echo ========================================
echo 后端期望参数：
echo ========================================
echo.
echo // GameStartDTO.java
echo @Data
echo public class GameStartDTO {
echo     private Long userId;   // ← 用户ID
echo     private Long gameId;   // ← 游戏ID
echo }
echo.
echo ========================================
echo 前端修复前后对比：
echo ========================================
echo.
echo // ❌ 错误（修复前）
echo async start(kidId: number, gameId: number) {
echo   return this.post('/api/game/start', { kidId, gameId });
echo }
echo.
echo // ✅ 正确（修复后）
echo async start(userId: number, gameId: number) {
echo   return this.post('/api/game/start', { userId, gameId });
echo }
echo.
echo ========================================
echo UserInfo 接口定义：
echo ========================================
echo.
echo export interface UserInfo {
echo   id: number;              // ✅ 正确的字段名
echo   username: string;
echo   nickname: string;
echo   avatar?: string;
echo   grade: string;
echo   fatiguePoints: number;
echo   dailyAnswerPoints: number;
echo   parentId?: number;
echo   userType?: 'KID' ^| 'PARENT' ^| 'ADMIN';
echo }
echo.
echo 注意：没有 kidId 字段！
echo.
echo ========================================
echo 测试步骤：
echo ========================================
echo.
echo 1. 清除前端缓存（如果需要）
echo    cd kids-game-frontend
echo    Remove-Item -Recurse -Force node_modules\.vite, dist
echo    npm run dev
echo.
echo 2. 测试儿童端
echo    a. 以儿童账号登录
echo    b. 打开浏览器 F12 → Network 标签
echo    c. 点击任意游戏卡片
echo    d. 查看 /api/game/start 请求
echo    e. 确认 Request Payload: {"userId":123,"gameId":1}
echo    f. 确认游戏正常启动
echo.
echo 3. 测试家长端
echo    a. 以家长账号登录
echo    b. 打开浏览器 F12 → Network 标签
echo    c. 点击任意游戏卡片
echo    d. 查看 /api/game/start 请求
echo    e. 确认 Request Payload: {"userId":456,"gameId":1}
echo    f. 确认游戏正常启动
echo.
echo ========================================
echo 常见问题：
echo ========================================
echo.
echo Q: 请求返回 400 Bad Request？
echo A: 检查请求体格式，确认字段名是 userId 而不是 kidId
echo.
echo Q: 请求返回 401 Unauthorized？
echo A: 检查是否已登录，确认 Authorization header 已携带
echo.
echo Q: 游戏无法启动？
echo A: 查看 Console 和 Network 日志，确认 API 调用成功
echo.
echo ========================================
pause
