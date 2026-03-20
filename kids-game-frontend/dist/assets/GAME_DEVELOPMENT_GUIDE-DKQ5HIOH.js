const n=`# 游戏开发对接文档\r
\r
## 📖 概述\r
\r
本文档说明如何将第三方游戏接入儿童游戏平台。平台采用**完全解耦**的架构，游戏独立部署，通过 **iframe** 加载，使用 **postMessage** 与平台通信。\r
\r
## 🎯 接入流程\r
\r
\`\`\`\r
1. 开发游戏 → 2. 独立部署 → 3. 平台注册 → 4. 测试对接 → 5. 上线运营\r
\`\`\`\r
\r
---\r
\r
## 📦 游戏部署\r
\r
### 1. 游戏独立部署\r
\r
游戏可以是任何技术栈（Vue3、React、Phaser、Unity WebGL等），只需满足以下要求：\r
\r
- 单页面应用（SPA）\r
- 通过 URL 参数接收初始化数据\r
- 使用 postMessage 与父窗口通信\r
- 响应式设计，适配不同屏幕\r
\r
### 2. 部署示例\r
\r
假设游戏部署到 \`https://games.example.com/snake\`：\r
\r
\`\`\`\r
https://games.example.com/snake/\r
├── index.html\r
├── game.js\r
├── game.css\r
└── assets/\r
    ├── snake.png\r
    └── food.png\r
\`\`\`\r
\r
---\r
\r
## 🤝 平台对接协议\r
\r
### 1. 接收平台参数（URL Query）\r
\r
游戏启动时，平台会通过 URL 参数传递初始化数据：\r
\r
\`\`\`typescript\r
interface PlatformParams {\r
  session_id: string;      // 会话令牌（必填）\r
  user_id: string;         // 用户ID（必填）\r
  user_name: string;       // 用户名（必填）\r
  game_mode: string;       // 游戏模式（可选）\r
  game_config?: string;     // 游戏配置JSON（可选）\r
}\r
\`\`\`\r
\r
**示例 URL**：\r
\`\`\`\r
https://games.example.com/snake?session_id=abc123&user_id=1&user_name=小明&game_mode=single&game_config={"difficulty":"medium","gridSize":20}\r
\`\`\`\r
\r
**解析参数示例**：\r
\r
\`\`\`javascript\r
const params = new URLSearchParams(window.location.search);\r
\r
const sessionId = params.get('session_id');\r
const userId = params.get('user_id');\r
const userName = params.get('user_name');\r
const gameMode = params.get('game_mode');\r
const gameConfig = params.get('game_config');\r
\r
if (gameConfig) {\r
  const config = JSON.parse(gameConfig);\r
  console.log('游戏配置:', config);\r
}\r
\`\`\`\r
\r
---\r
\r
### 2. 发送游戏状态（postMessage）\r
\r
游戏需要定期向平台发送游戏状态，以便平台更新UI：\r
\r
\`\`\`typescript\r
interface GameStatusData {\r
  score: number;           // 当前分数\r
  duration: number;        // 游戏时长（秒）\r
  lives?: number;          // 剩余生命（可选）\r
  level?: number;          // 当前关卡（可选）\r
  [key: string]: any;     // 其他自定义字段\r
}\r
\`\`\`\r
\r
**发送状态示例**：\r
\r
\`\`\`javascript\r
// 定义发送状态函数\r
function sendGameStatus(score, duration, lives) {\r
  window.parent.postMessage({\r
    type: 'GAME_STATUS',\r
    data: {\r
      score: score,\r
      duration: duration,\r
      lives: lives,\r
    }\r
  }, '*');\r
}\r
\r
// 定期发送（例如每秒）\r
setInterval(() => {\r
  sendGameStatus(game.score, game.duration, game.lives);\r
}, 1000);\r
\r
// 或在游戏状态变化时发送\r
game.onScoreChanged = (score) => {\r
  sendGameStatus(score, game.duration, game.lives);\r
};\r
\`\`\`\r
\r
---\r
\r
### 3. 发送游戏结束（postMessage）\r
\r
游戏结束时，需要向平台发送最终结果：\r
\r
\`\`\`typescript\r
interface GameOverData {\r
  final_score: number;      // 最终分数（必填）\r
  duration: number;         // 游戏时长（秒）（必填）\r
  lives?: number;           // 剩余生命（可选）\r
  level?: number;           // 最终关卡（可选）\r
  is_win?: boolean;         // 是否胜利（可选）\r
  details?: {               // 详细数据（可选）\r
    [key: string]: any;\r
  };\r
}\r
\`\`\`\r
\r
**发送结束示例**：\r
\r
\`\`\`javascript\r
function sendGameOver(result) {\r
  window.parent.postMessage({\r
    type: 'GAME_OVER',\r
    data: {\r
      final_score: result.score,\r
      duration: result.duration,\r
      lives: result.lives,\r
      level: result.level,\r
      is_win: result.isWin,\r
      details: {\r
        apples: result.apples,     // 吃到食物数量\r
        max_length: result.maxLength, // 最长长度\r
        // 其他自定义数据...\r
      }\r
    }\r
  }, '*');\r
}\r
\r
// 游戏结束时调用\r
game.onGameOver = (result) => {\r
  sendGameOver(result);\r
};\r
\`\`\`\r
\r
---\r
\r
### 4. 发送游戏错误（postMessage）\r
\r
游戏发生错误时，可以通知平台：\r
\r
\`\`\`typescript\r
interface GameErrorData {\r
  error_code: string;      // 错误码\r
  error_message: string;   // 错误信息\r
}\r
\`\`\`\r
\r
**发送错误示例**：\r
\r
\`\`\`javascript\r
function sendError(errorCode, errorMessage) {\r
  window.parent.postMessage({\r
    type: 'GAME_ERROR',\r
    data: {\r
      error_code: errorCode,\r
      error_message: errorMessage\r
    }\r
  }, '*');\r
}\r
\`\`\`\r
\r
---\r
\r
### 5. 接收平台指令（postMessage）\r
\r
平台可以向游戏发送控制指令：\r
\r
\`\`\`typescript\r
// 暂停游戏\r
interface PauseGameEvent {\r
  type: 'PAUSE_GAME';\r
  data: { paused: boolean; };\r
}\r
\r
// 继续游戏\r
interface ResumeGameEvent {\r
  type: 'RESUME_GAME';\r
  data: {};\r
}\r
\r
// 强制结束\r
interface ForceEndGameEvent {\r
  type: 'FORCE_END_GAME';\r
  data: { reason: string; };\r
}\r
\`\`\`\r
\r
**监听平台指令示例**：\r
\r
\`\`\`javascript\r
// 监听平台消息\r
window.addEventListener('message', (event) => {\r
  const { type, data } = event.data;\r
\r
  switch (type) {\r
    case 'PAUSE_GAME':\r
      if (data.paused) {\r
        game.pause();\r
      }\r
      break;\r
\r
    case 'RESUME_GAME':\r
      game.resume();\r
      break;\r
\r
    case 'FORCE_END_GAME':\r
      game.end(data.reason);\r
      break;\r
\r
    default:\r
      console.log('未知消息类型:', type);\r
  }\r
});\r
\r
// 游戏暂停处理\r
game.onPause = () => {\r
  console.log('游戏已暂停');\r
  // 可以显示暂停UI\r
};\r
\r
// 游戏继续处理\r
game.onResume = () => {\r
  console.log('游戏已继续');\r
  // 隐藏暂停UI\r
};\r
\r
// 游戏结束处理\r
game.onEnd = (reason) => {\r
  console.log('游戏结束:', reason);\r
  sendGameOver(game.getFinalResult());\r
};\r
\`\`\`\r
\r
---\r
\r
## 🎮 完整示例代码\r
\r
### HTML + JavaScript 示例\r
\r
\`\`\`html\r
<!DOCTYPE html>\r
<html lang="zh-CN">\r
<head>\r
  <meta charset="UTF-8">\r
  <meta name="viewport" content="width=device-width, initial-scale=1.0">\r
  <title>贪吃蛇游戏</title>\r
  <style>\r
    * {\r
      margin: 0;\r
      padding: 0;\r
      box-sizing: border-box;\r
    }\r
    \r
    body {\r
      display: flex;\r
      justify-content: center;\r
      align-items: center;\r
      height: 100vh;\r
      background: #000;\r
      font-family: Arial, sans-serif;\r
    }\r
    \r
    #game-container {\r
      position: relative;\r
    }\r
    \r
    canvas {\r
      border: 2px solid #42b983;\r
      background: #1a1a1a;\r
      display: block;\r
    }\r
    \r
    .game-info {\r
      color: #fff;\r
      text-align: center;\r
      margin-bottom: 10px;\r
    }\r
  </style>\r
</head>\r
<body>\r
  <div id="game-container">\r
    <div class="game-info">\r
      <span id="score">分数: 0</span> | \r
      <span id="duration">时长: 0s</span> |\r
      <span id="lives">生命: 3</span>\r
    </div>\r
    <canvas id="gameCanvas"></canvas>\r
  </div>\r
\r
  <script>\r
    // ==================== 配置和状态 ====================\r
    \r
    // 解析平台参数\r
    const params = new URLSearchParams(window.location.search);\r
    const sessionId = params.get('session_id');\r
    const userId = params.get('user_id');\r
    const userName = params.get('user_name');\r
    const gameConfigStr = params.get('game_config');\r
    \r
    // 游戏配置\r
    let gameConfig = {\r
      difficulty: 'medium',\r
      gridSize: 20,\r
      initialSpeed: 150,\r
    };\r
    \r
    if (gameConfigStr) {\r
      try {\r
        gameConfig = { ...gameConfig, ...JSON.parse(gameConfigStr) };\r
      } catch (e) {\r
        console.error('解析游戏配置失败:', e);\r
      }\r
    }\r
    \r
    // 游戏状态\r
    const gameState = {\r
      score: 0,\r
      duration: 0,\r
      lives: 3,\r
      isPaused: false,\r
      isGameOver: false,\r
      apples: 0,\r
      maxLength: 3,\r
      startTime: Date.now(),\r
    };\r
    \r
    // ==================== 工具函数 ====================\r
    \r
    /**\r
     * 发送游戏状态到平台\r
     */\r
    function sendGameStatus() {\r
      window.parent.postMessage({\r
        type: 'GAME_STATUS',\r
        data: {\r
          score: gameState.score,\r
          duration: gameState.duration,\r
          lives: gameState.lives,\r
        }\r
      }, '*');\r
    }\r
    \r
    /**\r
     * 发送游戏结束到平台\r
     */\r
    function sendGameOver() {\r
      window.parent.postMessage({\r
        type: 'GAME_OVER',\r
        data: {\r
          final_score: gameState.score,\r
          duration: gameState.duration,\r
          lives: gameState.lives,\r
          details: {\r
            apples: gameState.apples,\r
            max_length: gameState.maxLength,\r
          }\r
        }\r
      }, '*');\r
    }\r
    \r
    /**\r
     * 发送游戏错误\r
     */\r
    function sendError(errorCode, errorMessage) {\r
      window.parent.postMessage({\r
        type: 'GAME_ERROR',\r
        data: {\r
          error_code: errorCode,\r
          error_message: errorMessage\r
        }\r
      }, '*');\r
    }\r
    \r
    /**\r
     * 更新UI\r
     */\r
    function updateUI() {\r
      document.getElementById('score').textContent = \`分数: \${gameState.score}\`;\r
      document.getElementById('duration').textContent = \`时长: \${gameState.duration}s\`;\r
      document.getElementById('lives').textContent = \`生命: \${gameState.lives}\`;\r
    }\r
    \r
    // ==================== 游戏逻辑 ====================\r
    \r
    const canvas = document.getElementById('gameCanvas');\r
    const ctx = canvas.getContext('2d');\r
    const gridSize = gameConfig.gridSize;\r
    const canvasWidth = 400;\r
    const canvasHeight = 400;\r
    \r
    canvas.width = canvasWidth;\r
    canvas.height = canvasHeight;\r
    \r
    // 蛇\r
    let snake = [\r
      { x: 10, y: 10 },\r
      { x: 9, y: 10 },\r
      { x: 8, y: 10 },\r
    ];\r
    \r
    let direction = { x: 1, y: 0 };\r
    let food = { x: 15, y: 15 };\r
    let gameLoop;\r
    let statusInterval;\r
    \r
    /**\r
     * 生成食物\r
     */\r
    function spawnFood() {\r
      const maxX = canvasWidth / gridSize - 1;\r
      const maxY = canvasHeight / gridSize - 1;\r
      food = {\r
        x: Math.floor(Math.random() * maxX),\r
        y: Math.floor(Math.random() * maxY),\r
      };\r
    }\r
    \r
    /**\r
     * 绘制游戏\r
     */\r
    function draw() {\r
      // 清空画布\r
      ctx.fillStyle = '#1a1a1a';\r
      ctx.fillRect(0, 0, canvasWidth, canvasHeight);\r
      \r
      // 绘制食物\r
      ctx.fillStyle = '#ff4444';\r
      ctx.fillRect(food.x * gridSize, food.y * gridSize, gridSize - 2, gridSize - 2);\r
      \r
      // 绘制蛇\r
      snake.forEach((segment, index) => {\r
        ctx.fillStyle = index === 0 ? '#00ff00' : '#42b983';\r
        ctx.fillRect(segment.x * gridSize, segment.y * gridSize, gridSize - 2, gridSize - 2);\r
      });\r
    }\r
    \r
    /**\r
     * 更新游戏状态\r
     */\r
    function update() {\r
      if (gameState.isPaused || gameState.isGameOver) {\r
        return;\r
      }\r
      \r
      // 移动蛇\r
      const head = { ...snake[0] };\r
      head.x += direction.x;\r
      head.y += direction.y;\r
      \r
      // 边界检测\r
      if (head.x < 0 || head.x >= canvasWidth / gridSize ||\r
          head.y < 0 || head.y >= canvasHeight / gridSize) {\r
        loseLife();\r
        return;\r
      }\r
      \r
      // 自身碰撞检测\r
      for (let segment of snake) {\r
        if (head.x === segment.x && head.y === segment.y) {\r
          loseLife();\r
          return;\r
        }\r
      }\r
      \r
      snake.unshift(head);\r
      \r
      // 吃食物\r
      if (head.x === food.x && head.y === food.y) {\r
        gameState.score += 10;\r
        gameState.apples++;\r
        spawnFood();\r
        updateUI();\r
        sendGameStatus();\r
      } else {\r
        snake.pop();\r
      }\r
      \r
      // 更新最长长度\r
      if (snake.length > gameState.maxLength) {\r
        gameState.maxLength = snake.length;\r
      }\r
    }\r
    \r
    /**\r
     * 失去生命\r
     */\r
    function loseLife() {\r
      gameState.lives--;\r
      updateUI();\r
      \r
      if (gameState.lives <= 0) {\r
        gameOver();\r
      } else {\r
        // 重置蛇的位置\r
        snake = [\r
          { x: 10, y: 10 },\r
          { x: 9, y: 10 },\r
          { x: 8, y: 10 },\r
        ];\r
        direction = { x: 1, y: 0 };\r
        spawnFood();\r
      }\r
    }\r
    \r
    /**\r
     * 游戏结束\r
     */\r
    function gameOver() {\r
      gameState.isGameOver = true;\r
      clearInterval(gameLoop);\r
      clearInterval(statusInterval);\r
      \r
      sendGameOver();\r
      \r
      // 显示游戏结束信息\r
      ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';\r
      ctx.fillRect(0, 0, canvasWidth, canvasHeight);\r
      ctx.fillStyle = '#fff';\r
      ctx.font = '30px Arial';\r
      ctx.textAlign = 'center';\r
      ctx.fillText('游戏结束', canvasWidth / 2, canvasHeight / 2);\r
    }\r
    \r
    /**\r
     * 暂停游戏\r
     */\r
    function pauseGame() {\r
      gameState.isPaused = true;\r
      console.log('游戏暂停');\r
    }\r
    \r
    /**\r
     * 继续游戏\r
     */\r
    function resumeGame() {\r
      gameState.isPaused = false;\r
      console.log('游戏继续');\r
    }\r
    \r
    /**\r
     * 强制结束\r
     */\r
    function forceEndGame(reason) {\r
      console.log('强制结束:', reason);\r
      gameState.isGameOver = true;\r
      clearInterval(gameLoop);\r
      clearInterval(statusInterval);\r
      sendGameOver();\r
    }\r
    \r
    // ==================== 游戏循环 ====================\r
    \r
    function startGame() {\r
      spawnFood();\r
      \r
      // 游戏循环（60fps）\r
      gameLoop = setInterval(() => {\r
        update();\r
        draw();\r
      }, 1000 / 60);\r
      \r
      // 状态更新（每秒）\r
      statusInterval = setInterval(() => {\r
        if (!gameState.isPaused && !gameState.isGameOver) {\r
          gameState.duration = Math.floor((Date.now() - gameState.startTime) / 1000);\r
          updateUI();\r
          sendGameStatus();\r
        }\r
      }, 1000);\r
    }\r
    \r
    // ==================== 键盘控制 ====================\r
    \r
    document.addEventListener('keydown', (e) => {\r
      if (gameState.isPaused || gameState.isGameOver) return;\r
      \r
      switch (e.key) {\r
        case 'ArrowUp':\r
        case 'w':\r
        case 'W':\r
          if (direction.y !== 1) direction = { x: 0, y: -1 };\r
          break;\r
        case 'ArrowDown':\r
        case 's':\r
        case 'S':\r
          if (direction.y !== -1) direction = { x: 0, y: 1 };\r
          break;\r
        case 'ArrowLeft':\r
        case 'a':\r
        case 'A':\r
          if (direction.x !== 1) direction = { x: -1, y: 0 };\r
          break;\r
        case 'ArrowRight':\r
        case 'd':\r
        case 'D':\r
          if (direction.x !== -1) direction = { x: 1, y: 0 };\r
          break;\r
      }\r
    });\r
    \r
    // ==================== 监听平台指令 ====================\r
    \r
    window.addEventListener('message', (event) => {\r
      const { type, data } = event.data;\r
      \r
      switch (type) {\r
        case 'PAUSE_GAME':\r
          pauseGame();\r
          break;\r
          \r
        case 'RESUME_GAME':\r
          resumeGame();\r
          break;\r
          \r
        case 'FORCE_END_GAME':\r
          forceEndGame(data.reason);\r
          break;\r
      }\r
    });\r
    \r
    // ==================== 启动游戏 ====================\r
    \r
    console.log('游戏初始化:', {\r
      sessionId,\r
      userId,\r
      userName,\r
      gameConfig\r
    });\r
    \r
    startGame();\r
  <\/script>\r
</body>\r
</html>\r
\`\`\`\r
\r
---\r
\r
## 🔧 平台注册\r
\r
### 1. 登录后台管理系统\r
\r
使用管理员账号登录平台后台。\r
\r
### 2. 添加游戏\r
\r
在游戏管理页面，点击"添加游戏"，填写以下信息：\r
\r
| 字段 | 说明 | 示例 |\r
|------|------|------|\r
| 游戏代码 | 唯一标识 | \`SNAKE_VUE3\` |\r
| 游戏名称 | 显示名称 | 贪吃蛇大冒险 |\r
| 游戏分类 | 所属分类 | 益智 |\r
| 适龄阶段 | 适合年级 | 一年级 |\r
| 图标URL | 游戏图标 | \`/images/games/snake-icon.png\` |\r
| 游戏URL | **独立部署地址** | \`https://games.example.com/snake\` |\r
| 游戏密钥 | 签名验证（可选） | \`snake_secret_123\` |\r
| 游戏配置 | JSON配置 | \`{"difficulty":"medium","gridSize":20}\` |\r
| 状态 | 启用/禁用 | 启用 |\r
\r
### 3. 测试游戏\r
\r
1. 在前端平台点击游戏卡片\r
2. 确认游戏正常加载\r
3. 测试游戏流程（开始、暂停、继续、结束）\r
4. 检查分数、时长、生命值是否正确更新\r
\r
---\r
\r
## ⚠️ 注意事项\r
\r
### 安全性\r
\r
1. **消息来源验证**：平台会验证 postMessage 来源，游戏不需要处理\r
2. **会话令牌**：不要将 \`session_id\` 暴露给第三方\r
3. **CORS 配置**：确保游戏服务器允许平台域名的跨域请求\r
\r
### 兼容性\r
\r
1. **postMessage**：所有现代浏览器都支持\r
2. **URL 参数**：使用标准的 URLSearchParams API\r
3. **响应式**：游戏需要适配不同屏幕尺寸\r
\r
### 性能\r
\r
1. **状态更新频率**：建议每秒发送一次状态\r
2. **静态资源**：建议使用 CDN 加速\r
3. **代码压缩**：发布前压缩 JS/CSS 代码\r
\r
---\r
\r
## 🐛 故障排查\r
\r
### 问题 1：游戏无法加载\r
\r
**可能原因**：\r
- 游戏URL配置错误\r
- CORS 未配置\r
- 游戏服务器未启动\r
\r
**解决方法**：\r
1. 检查数据库 \`t_game\` 表的 \`game_url\` 字段\r
2. 配置游戏服务器的 CORS\r
3. 确认游戏服务器正常运行\r
\r
---\r
\r
### 问题 2：postMessage 未生效\r
\r
**可能原因**：\r
- 消息类型不匹配\r
- 游戏在 iframe 中运行\r
\r
**解决方法**：\r
1. 检查消息类型是否为 \`GAME_STATUS\`、\`GAME_OVER\` 等\r
2. 确保游戏在 iframe 中运行\r
3. 使用浏览器开发者工具查看 postMessage 事件\r
\r
---\r
\r
### 问题 3：游戏结果未提交\r
\r
**可能原因**：\r
- \`session_id\` 未传递\r
- 后端接口未正确调用\r
\r
**解决方法**：\r
1. 检查 URL 参数是否包含 \`session_id\`\r
2. 在浏览器开发者工具查看网络请求\r
3. 确认后端 \`/api/game/session/{sessionId}/result\` 接口正常\r
\r
---\r
\r
## 📚 相关资源\r
\r
- [完整架构设计文档](GAME_PLATFORM_DECOUPLING_DESIGN.md)\r
- [实施指南](IMPLEMENTATION_GUIDE.md)\r
- [API 接口文档](API_REFERENCE.md)（待完善）\r
\r
---\r
\r
## 💡 最佳实践\r
\r
1. **定期发送状态**：每秒发送一次游戏状态，保证 UI 实时更新\r
2. **异常处理**：所有网络操作都要有异常处理\r
3. **用户反馈**：游戏加载、错误时要有明确的用户提示\r
4. **日志记录**：使用 console.log 记录关键操作，方便调试\r
5. **测试覆盖**：测试各种场景（正常、异常、网络问题等）\r
\r
---\r
\r
## 📞 技术支持\r
\r
如遇到对接问题，请联系平台技术团队：\r
- Email: support@kids-game.com\r
- QQ群: 123456789\r
`;export{n as default};
//# sourceMappingURL=GAME_DEVELOPMENT_GUIDE-DKQ5HIOH.js.map
