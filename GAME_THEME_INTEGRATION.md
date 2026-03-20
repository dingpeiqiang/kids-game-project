# 游戏主题集成说明

## 概述

本文档说明如何将创作者中心的主题系统与实际游戏打通，实现游戏根据主题加载资源的功能。

## 架构设计

### 核心组件

1. **GameThemeLoader (game-theme/GameThemeLoader.ts)**
   - 游戏主题加载器核心类
   - 负责从后端API获取主题列表
   - 加载并缓存主题资源
   - 提供主题资源访问接口

2. **GameThemeSelector (components/game/GameThemeSelector.vue)**
   - 主题选择器UI组件
   - 展示可用主题列表
   - 支持主题选择和应用

3. **创作者中心 (modules/creator-center/index.vue)**
   - 从后端API获取游戏列表
   - 创建和管理游戏主题
   - 展示实际系统中在用的主题

4. **游戏页面 (modules/game/index.vue)**
   - 集成主题选择器
   - 将主题ID传递给游戏
   - 支持主题切换后重新加载

## 数据流

### 创作者中心 -> 游戏列表

```
创作者中心
    ↓
GET /api/game/list
    ↓
返回游戏列表（gameId, gameName, gameCode）
    ↓
显示在游戏选择器中
```

### 创作者中心 -> 主题创建

```
创作者中心创建主题
    ↓
POST /api/theme/upload
    ↓
保存到数据库 (theme_info表)
    ↓
主题列表API返回新主题
```

### 游戏 -> 主题加载

```
游戏页面加载
    ↓
GET /api/theme/list?applicableScope=specific&gameCode=xxx
    ↓
返回该游戏的主题列表
    ↓
用户选择主题
    ↓
GET /api/theme/download?themeId=xxx (检查购买状态)
    ↓
加载主题配置和资源
    ↓
应用主题到游戏
```

## 数据库结构

### theme_info 表

| 字段 | 类型 | 说明 |
|-----|------|------|
| theme_id | BIGINT | 主题ID（主键） |
| author_id | BIGINT | 作者ID |
| theme_name | VARCHAR | 主题名称 |
| applicable_scope | VARCHAR | 适用范围：all(应用主题)/specific(游戏主题) |
| author_name | VARCHAR | 作者名称 |
| price | INT | 价格（游戏币） |
| status | VARCHAR | 状态：on_sale/offline/pending |
| download_count | INT | 下载次数 |
| total_revenue | INT | 总收益 |
| thumbnail_url | VARCHAR | 缩略图URL |
| description | TEXT | 描述 |
| config_json | TEXT | 主题配置（JSON格式） |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### 主题配置JSON结构

```json
{
  "default": {
    "name": "主题名称",
    "author": "作者名称",
    "description": "主题描述",
    "applicableScope": "specific",
    "gameCode": "plane-shooter",

    "styles": {
      "colors": {
        "primary": "#4ECDC4",
        "secondary": "#45B7D1",
        "background": "#f5f7fa",
        "surface": "#ffffff",
        "text": "#2d3748"
      },
      "typography": {
        "fontFamily": "Arial, sans-serif",
        "fontSizes": {
          "xs": "12px",
          "sm": "14px",
          "base": "16px",
          "lg": "18px",
          "xl": "20px"
        }
      }
    },

    "assets": {
      "bg_main": {
        "type": "image",
        "url": "https://cdn.example.com/themes/bg-main.png",
        "thumbnailUrl": "https://cdn.example.com/themes/bg-main-thumb.png"
      },
      "player": {
        "type": "image",
        "url": "https://cdn.example.com/themes/player.png"
      },
      "food": {
        "type": "image",
        "url": "https://cdn.example.com/themes/food.png"
      }
    },

    "audio": {
      "bgm_main": {
        "type": "audio",
        "url": "https://cdn.example.com/themes/bgm-main.mp3",
        "volume": 0.5,
        "loop": true
      },
      "sfx_click": {
        "type": "audio",
        "url": "https://cdn.example.com/themes/click.mp3",
        "volume": 0.7
      }
    }
  }
}
```

## 后端API

### 获取游戏列表

```
GET /api/game/list
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "成功",
  "data": [
    {
      "gameId": 1,
      "gameName": "飞机大战",
      "gameCode": "plane-shooter",
      "gameUrl": "http://localhost:3000/game/plane-shooter"
    },
    {
      "gameId": 2,
      "gameName": "贪吃蛇大冒险",
      "gameCode": "snake-vue3",
      "gameUrl": "http://localhost:3000/game/snake-vue3"
    }
  ]
}
```

### 获取主题列表

```
GET /api/theme/list?applicableScope=specific&gameCode=plane-shooter&status=on_sale
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "成功",
  "data": {
    "list": [
      {
        "themeId": 1,
        "themeName": "星际主题",
        "authorName": "主题创作者",
        "applicableScope": "specific",
        "gameCode": "plane-shooter",
        "price": 100,
        "status": "on_sale",
        "thumbnailUrl": "https://cdn.example.com/themes/theme1-thumb.png",
        "description": "炫酷的星际风格主题",
        "downloadCount": 150,
        "totalRevenue": 15000
      }
    ],
    "total": 1,
    "page": 1,
    "pageSize": 20
  }
}
```

### 下载主题

```
GET /api/theme/download?id=1
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "成功",
  "data": {
    "configJson": "{...主题配置JSON...}"
  }
}
```

### 上传主题

```
POST /api/theme/upload
```

**请求体：**
```json
{
  "themeName": "新主题",
  "authorName": "创作者",
  "applicableScope": "specific",
  "gameCode": "plane-shooter",
  "price": 100,
  "description": "主题描述",
  "thumbnailUrl": "https://cdn.example.com/themes/thumb.png",
  "config": {...主题配置...}
}
```

## 前端使用

### 在创作者中心获取游戏列表

```typescript
// modules/creator-center/index.vue
async function loadGamesList() {
  try {
    const response = await fetch('/api/game/list');
    const result = await response.json();

    if (result.code === 200 && result.data) {
      games.value = result.data.map((game: any) => ({
        gameId: game.gameId,
        gameName: game.gameName,
        gameCode: game.gameCode,
      }));
    }
  } catch (error) {
    console.error('加载游戏列表失败:', error);
  }
}
```

### 在游戏中使用主题加载器

```typescript
import { gameThemeLoader } from '@/core/game-theme/GameThemeLoader';

// 获取游戏主题列表
const themes = await gameThemeLoader.getGameThemes('plane-shooter');

// 加载指定主题
const theme = await gameThemeLoader.loadTheme(themeId, userId);

// 获取资源
const bgUrl = gameThemeLoader.getBackground();
const playerAsset = gameThemeLoader.getPlayerAsset();
const bgmUrl = gameThemeLoader.getBackgroundMusic();

// 获取样式
const primaryColor = gameThemeLoader.getStyle('colors.primary');

// 应用主题到游戏容器
gameThemeLoader.applyThemeToGame(gameContainer);
```

### 在游戏中集成主题选择器

```vue
<template>
  <GameThemeSelector
    v-if="gameCode"
    :game-code="gameCode"
    v-model="selectedThemeId"
    @theme-selected="onThemeSelected"
  />
</template>

<script setup lang="ts">
import GameThemeSelector from '@/components/game/GameThemeSelector.vue';
import type { GameThemeConfig } from '@/core/game-theme/GameThemeLoader';

function onThemeSelected(theme: GameThemeConfig) {
  console.log('主题已选择:', theme.themeName);
  // 重新加载游戏以应用新主题
}
</script>
```

## 游戏端集成

### 游戏接收主题参数

游戏从URL参数中获取`theme_id`：

```javascript
// 获取主题ID
const urlParams = new URLSearchParams(window.location.search);
const themeId = urlParams.get('theme_id');

if (themeId) {
  // 加载主题配置
  loadTheme(parseInt(themeId));
}
```

### 游戏加载主题资源

```javascript
async function loadTheme(themeId) {
  try {
    // 从后端获取主题配置
    const response = await fetch(`/api/theme/download?id=${themeId}`);
    const result = await response.json();

    if (result.code === 200 && result.data) {
      const themeConfig = JSON.parse(result.data.configJson);
      const themeData = themeConfig.default;

      // 应用背景
      if (themeData.assets?.bg_main?.url) {
        game.scene.scenes[0].load.image('bg', themeData.assets.bg_main.url);
      }

      // 应用角色
      if (themeData.assets?.player?.url) {
        game.scene.scenes[0].load.image('player', themeData.assets.player.url);
      }

      // 应用食物
      if (themeData.assets?.food?.url) {
        game.scene.scenes[0].load.image('food', themeData.assets.food.url);
      }

      // 应用背景音乐
      if (themeData.audio?.bgm_main?.url) {
        game.scene.scenes[0].load.audio('bgm', themeData.audio.bgm_main.url);
      }

      // 应用音效
      if (themeData.audio?.sfx_click?.url) {
        game.scene.scenes[0].load.audio('click', themeData.audio.sfx_click.url);
      }

      // 开始加载
      game.scene.scenes[0].load.start();
    }
  } catch (error) {
    console.error('加载主题失败:', error);
  }
}
```

## 主题创作流程

### 1. 家长登录创作者中心

访问 `/creator-center` 页面

### 2. 选择"游戏主题"范围

- 选择适用范围：游戏主题
- 选择具体游戏：如"飞机大战"

### 3. 创建新主题

点击"创建主题"按钮，填写：
- 主题名称
- 主题描述
- 价格（游戏币）
- 适用范围：specific
- 游戏代码：plane-shooter

### 4. 配置主题资源

在主题编辑器中配置：
- **样式配置**：颜色、字体、圆角、阴影等
- **资源配置**：背景、角色、道具、UI元素等图片
- **音频配置**：背景音乐、音效等

### 5. 上传主题

点击"发布"按钮，主题保存到数据库

### 6. 孩子游戏中查看

- 孩子打开游戏页面
- 点击"🎨 主题"按钮
- 选择并应用主题
- 游戏加载主题资源

## 主题资源管理

### 资源类型

1. **图片资源**
   - 背景图：bg_main, bg_game等
   - 角色：player, snakeHead, snakeBody等
   - 道具：food, coin, powerup等
   - UI元素：btn_primary, card_bg等

2. **音频资源**
   - 背景音乐：bgm_main, bgm_gameplay等
   - 音效：sfx_click, sfx_success, sfx_explosion等

3. **样式资源**
   - 颜色：colors.primary, colors.secondary等
   - 字体：typography.fontSizes等
   - 圆角：radius.sm, radius.md等
   - 阴影：shadows.sm, shadows.md等

### 资源命名规范

- 使用下划线分隔：bg_main, sfx_click
- 类型前缀：bg_(背景), sfx_(音效), btn_(按钮)
- 功能描述：player, food, enemy

## 测试流程

### 1. 测试创作者中心

1. 访问 `/creator-center`
2. 检查游戏列表是否从后端加载
3. 创建新主题
4. 上传主题
5. 检查主题是否出现在列表中

### 2. 测试游戏主题加载

1. 打开游戏页面
2. 点击"🎨 主题"按钮
3. 检查主题列表是否加载
4. 选择主题
5. 检查游戏是否加载主题资源

### 3. 测试主题切换

1. 选择一个主题
2. 选择另一个主题
3. 检查游戏是否重新加载并应用新主题

## 注意事项

1. **权限检查**
   - 下载主题前必须检查购买状态
   - 未购买的主题不能下载使用

2. **资源缓存**
   - 使用GameThemeLoader缓存资源
   - 避免重复加载相同资源

3. **错误处理**
   - API调用失败时显示友好提示
   - 使用默认主题作为回退

4. **性能优化**
   - 预加载主题资源
   - 使用CDN加速资源加载

5. **安全性**
   - 验证主题配置的合法性
   - 防止XSS攻击

## 总结

通过以上集成，实现了：

1. ✅ 创作者中心与实际游戏列表打通
2. ✅ 主题系统与游戏资源加载打通
3. ✅ 创作者中心展示实际系统中的主题
4. ✅ 游戏能够动态加载和应用主题
5. ✅ 支持主题选择和切换

所有主题数据都存储在后端数据库中，通过统一的API接口访问，确保了创作者中心、游戏页面和实际游戏之间的数据一致性。
