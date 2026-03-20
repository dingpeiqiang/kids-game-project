# 游戏系统架构原则：避免游戏硬编码依赖

## 核心原则

### ✅ **除了游戏本身，其他地方不应该存在依赖特定游戏的硬编码**

**这意味着：**
- ❌ 前端编辑器不应该知道"贪吃蛇"需要"蛇头"图片
- ❌ 资源检查器不应该知道"植物大战僵尸"需要"豌豆射手"
- ✅ 前端应该只提供通用的编辑界面，让用户自由定义资源
- ✅ 游戏自己负责定义和检查需要的资源

---

## 当前架构的问题

### 问题 1：前端编辑器包含游戏特定逻辑

**位置：** `kids-game-frontend/src/config/gameAssetConfig.ts`

```typescript
// ❌ 前端知道贪吃蛇需要什么资源
'snake-vue3': {
  imageAssets: [
    { key: 'snakeHead', label: '蛇头图片', required: true },
    { key: 'snakeBody', label: '蛇身图片', required: true },
    // ...
  ]
}
```

**问题：**
- 新增游戏时需要修改前端代码
- 前端版本和游戏版本必须同步
- 前端部署影响所有游戏

### 问题 2：游戏资源检查器包含游戏特定逻辑

**位置：** `kids-game-frontend/src/utils/gameResourceChecker.ts`

```typescript
// ❌ 前端检查器知道游戏需要什么资源
const assetConfig = getGameAssetConfig(gameCode);
for (const asset of assetConfig.imageAssets) {
  if (asset.required) {
    // 检查资源是否存在
  }
}
```

**问题：**
- 检查逻辑在前端，游戏无法自定义检查规则
- 前端需要知道每个游戏的资源定义

---

## 正确的架构设计

### 原则：关注点分离（Separation of Concerns）

```
┌─────────────────────────────────────────────────────────────┐
│                        前端（通用）                           │
│  - 主题编辑器：提供通用的资源上传界面                          │
│  - 主题管理：通用的主题 CRUD 操作                            │
│  - 游戏启动器：通用的游戏启动逻辑                             │
│                                                             │
│  ❌ 不包含：任何特定游戏的逻辑                                 │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                      GTRS 规范（通用）                        │
│  - 定义通用的主题 JSON 格式                                   │
│  - 定义通用的资源分类（login, scene, ui, icon, effect）     │
│  - 不关心具体游戏需要什么资源                                 │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    游戏（特定，独立）                         │
│  - 定义自己需要的资源                                         │
│  - 自己检查资源是否完整                                       │
│  - 自己加载和使用资源                                         │
│                                                             │
│  ✅ 游戏自己负责：资源定义、检查、加载                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 架构重构方案

### 方案 A：游戏自己定义和检查资源（推荐）

#### 1. 游戏通过 API 注册自己的配置

**后端新增 API：**
```typescript
// 游戏注册自己的资源配置
POST /api/game/register-config

{
  "gameId": "game_snake_v3",
  "gameCode": "snake-vue3",
  "gameName": "贪吃蛇大冒险",
  "requiredResources": {
    "images": [
      {
        "category": "scene",
        "keys": ["bg_main", "snake_head", "snake_body", "snake_tail", "food_apple"]
      }
    ],
    "audio": [
      {
        "category": "effect",
        "keys": ["sfx_eat", "sfx_gameover"]
      }
    ]
  }
}
```

**后端存储：**
```sql
-- 游戏资源配置表
CREATE TABLE game_resource_config (
  id INT PRIMARY KEY AUTO_INCREMENT,
  game_id VARCHAR(50) NOT NULL,
  game_code VARCHAR(50) NOT NULL,
  game_name VARCHAR(100) NOT NULL,
  required_resources JSON NOT NULL,
  optional_resources JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_game_id (game_id)
);
```

#### 2. 前端编辑器从后端获取游戏配置

**修改主题编辑器：**
```typescript
// ✅ 前端不知道游戏需要什么资源，只是从后端获取配置
async function loadGameConfig(gameId: string) {
  try {
    const config = await gameApi.getResourceConfig(gameId);
    return config;
  } catch (error) {
    // 如果游戏没有注册配置，使用默认配置（允许用户自由上传）
    return getDefaultConfig();
  }
}

// 默认配置：允许用户自由定义资源
function getDefaultConfig() {
  return {
    images: {
      login: [],
      scene: [],
      ui: [],
      icon: [],
      effect: []
    },
    audio: {
      bgm: [],
      effect: [],
      voice: []
    }
  };
}
```

#### 3. 游戏自己检查资源

**GTRSThemeLoader 中移除硬编码：**
```typescript
// ❌ 删除：硬编码的贪吃蛇资源配置
// const requiredSceneImages: Record<string, string> = {
//   bg_main: '游戏背景',
//   snake_head: '蛇头',
//   // ...
// }

// ✅ 新增：游戏自己注册检查逻辑
export interface GameResourceValidator {
  gameId: string
  validateResources(theme: GTRSTheme): { valid: boolean; missing: string[] }
}

/**
 * 游戏资源验证器注册表
 */
const resourceValidators: Map<string, GameResourceValidator> = new Map()

/**
 * 注册游戏的资源验证器
 */
export function registerResourceValidator(validator: GameResourceValidator): void {
  resourceValidators.set(validator.gameId, validator)
}

/**
 * 验证主题资源
 */
function validateRequiredResources(theme: GTRSTheme): void {
  const gameId = theme.themeInfo.gameId
  const validator = resourceValidators.get(gameId)

  if (validator) {
    // 使用游戏自己注册的验证器
    const result = validator.validateResources(theme)
    if (!result.valid) {
      throw new GTRSValidationError([
        `游戏运行必需资源缺失:`,
        ...result.missing.map(m => `• ${m}`),
        '',
        `当前主题: ${theme.themeInfo.themeName}`,
        `游戏ID: ${gameId}`
      ])
    }
  } else {
    // 游戏没有注册验证器，跳过检查（允许自由模式）
    console.warn(`[GTRSThemeLoader] 游戏 ${gameId} 未注册资源验证器，跳过资源检查`)
  }
}
```

**贪吃蛇游戏注册自己的验证器：**
```typescript
// 在贪吃蛇游戏初始化时注册
import { registerResourceValidator } from '@/core/GTRSThemeLoader'

registerResourceValidator({
  gameId: 'game_snake_v3',
  validateResources(theme: GTRSTheme): { valid: boolean; missing: string[] } {
    const missing: string[] = []

    // ✅ 游戏自己定义需要的资源
    const requiredImages = ['bg_main', 'snake_head', 'snake_body', 'snake_tail', 'food_apple']
    const requiredAudio = ['sfx_eat', 'sfx_gameover']

    // 检查图片
    for (const key of requiredImages) {
      if (!theme.resources.images.scene[key]) {
        missing.push(`images.scene.${key}`)
      }
    }

    // 检查音频
    for (const key of requiredAudio) {
      if (!theme.resources.audio.effect[key]) {
        missing.push(`audio.effect.${key}`)
      }
    }

    return {
      valid: missing.length === 0,
      missing
    }
  }
})
```

---

### 方案 B：主题 JSON 包含资源定义（更推荐）

#### 核心思想

**主题自己声明提供了哪些资源，游戏自己检查是否满足需求。**

#### GTRS 规范增强

**在 `themeInfo` 中添加 `providedResources` 字段：**
```typescript
export interface GTRSThemeInfo {
  themeId: string
  gameId: string
  themeName: string
  isDefault: boolean
  author?: string
  description?: string

  // ✅ 新增：主题提供的资源列表
  providedResources?: {
    images: {
      scene: string[]      // 主题提供的 scene 图片资源 keys
      ui: string[]
      login: string[]
      icon: string[]
      effect: string[]
    }
    audio: {
      bgm: string[]       // 主题提供的 bgm 资源 keys
      effect: string[]
      voice: string[]
    }
  }
}
```

#### 主题 JSON 示例

```json
{
  "specMeta": {
    "specName": "GTRS",
    "specVersion": "1.0.0",
    "compatibleVersion": "1.0.0"
  },
  "themeInfo": {
    "themeId": "snake_forest_v1",
    "gameId": "game_snake_v3",
    "themeName": "森林冒险",
    "isDefault": false,
    "author": "创作者A",
    "description": "贪吃蛇森林主题",

    // ✅ 主题声明提供了哪些资源
    "providedResources": {
      "images": {
        "scene": ["bg_main", "snake_head", "snake_body", "snake_tail", "food_apple"],
        "ui": [],
        "login": [],
        "icon": [],
        "effect": []
      },
      "audio": {
        "bgm": ["bgm_main"],
        "effect": ["sfx_eat", "sfx_gameover"],
        "voice": []
      }
    }
  },

  "globalStyle": {
    "primaryColor": "#4ade80",
    "secondaryColor": "#22c55e",
    "bgColor": "#1a3320",
    "textColor": "#ffffff"
  },

  "resources": {
    "images": {
      "scene": {
        "bg_main": {
          "src": "https://cdn.example.com/bg-main.png",
          "type": "png",
          "alias": "游戏背景"
        },
        "snake_head": {
          "src": "https://cdn.example.com/snake-head.png",
          "type": "png",
          "alias": "蛇头"
        },
        "snake_body": {
          "src": "https://cdn.example.com/snake-body.png",
          "type": "png",
          "alias": "蛇身"
        },
        "snake_tail": {
          "src": "https://cdn.example.com/snake-tail.png",
          "type": "png",
          "alias": "蛇尾"
        },
        "food_apple": {
          "src": "https://cdn.example.com/food-apple.png",
          "type": "png",
          "alias": "苹果食物"
        }
      }
    },
    "audio": {
      "bgm": {
        "bgm_main": {
          "src": "https://cdn.example.com/bgm.mp3",
          "type": "mp3",
          "volume": 0.7,
          "alias": "背景音乐"
        }
      },
      "effect": {
        "sfx_eat": {
          "src": "https://cdn.example.com/eat.mp3",
          "type": "mp3",
          "volume": 0.8,
          "alias": "吃东西音效"
        },
        "sfx_gameover": {
          "src": "https://cdn.example.com/gameover.mp3",
          "type": "mp3",
          "volume": 1.0,
          "alias": "游戏结束音效"
        }
      }
    }
  }
}
```

#### 游戏自己检查资源

```typescript
// GTRSThemeLoader 中移除所有硬编码
// ❌ 删除：validateRequiredResources() 方法中的硬编码

// ✅ 游戏自己检查资源
class SnakePhaserGame {
  /**
   * 游戏自己定义需要的资源
   */
  private readonly requiredResources = {
    images: ['bg_main', 'snake_head', 'snake_body', 'snake_tail', 'food_apple'],
    audio: ['sfx_eat', 'sfx_gameover']
  }

  /**
   * 检查主题是否提供所需资源
   */
  private checkThemeResources(theme: GTRSTheme): void {
    const missing: string[] = []

    // 检查图片
    const providedImages = theme.themeInfo.providedResources?.images?.scene || []
    for (const key of this.requiredResources.images) {
      if (!providedImages.includes(key)) {
        missing.push(`images.scene.${key}`)
      }
    }

    // 检查音频
    const providedAudio = [
      ...(theme.themeInfo.providedResources?.audio?.bgm || []),
      ...(theme.themeInfo.providedResources?.audio?.effect || [])
    ]
    for (const key of this.requiredResources.audio) {
      if (!providedAudio.includes(key)) {
        missing.push(`audio.${key}`)
      }
    }

    if (missing.length > 0) {
      throw new GTRSValidationError([
        `游戏运行必需资源缺失:`,
        ...missing.map(m => `• ${m}`),
        '',
        `当前主题: ${theme.themeInfo.themeName}`,
        `游戏ID: ${theme.themeInfo.gameId}`
      ])
    }
  }

  async start(themeId?: string): Promise<void> {
    // ...

    // ✅ 游戏自己检查资源
    this.checkThemeResources(this.gtrsLoader.getTheme())

    // ...
  }
}
```

#### 前端编辑器

**前端不需要知道游戏需要什么资源：**
```typescript
// ✅ 前端只是提供通用的编辑界面
<template>
  <div>
    <h3>场景图片</h3>
    <ResourceUploader
      category="scene"
      :resources="theme.resources.images.scene"
    />

    <h3>背景音乐</h3>
    <ResourceUploader
      category="bgm"
      :resources="theme.resources.audio.bgm"
    />

    <h3>音效</h3>
    <ResourceUploader
      category="effect"
      :resources="theme.resources.audio.effect"
    />
  </div>
</template>
```

**主题保存时自动生成 `providedResources`：**
```typescript
function generateProvidedResources(theme: GTRSTheme): GTRSThemeInfo['providedResources'] {
  return {
    images: {
      scene: Object.keys(theme.resources.images.scene),
      ui: Object.keys(theme.resources.images.ui),
      login: Object.keys(theme.resources.images.login),
      icon: Object.keys(theme.resources.images.icon),
      effect: Object.keys(theme.resources.images.effect)
    },
    audio: {
      bgm: Object.keys(theme.resources.audio.bgm),
      effect: Object.keys(theme.resources.audio.effect),
      voice: Object.keys(theme.resources.audio.voice)
    }
  }
}

async function saveTheme(theme: GTRSTheme) {
  // ✅ 自动生成 providedResources
  theme.themeInfo.providedResources = generateProvidedResources(theme)

  await themeApi.updateTheme(theme)
}
```

---

## 方案对比

| 维度 | 方案 A（游戏注册） | 方案 B（主题声明） |
|------|-------------------|-------------------|
| **前端依赖** | ❌ 需要从后端获取游戏配置 | ✅ 完全无依赖 |
| **游戏自由度** | ✅ 游戏自己定义检查逻辑 | ✅ 游戏自己定义需要的资源 |
| **主题灵活性** | ✅ 主题可以包含任意资源 | ✅ 主题声明提供的资源 |
| **实现复杂度** | ⚠️ 需要后端 API 和注册机制 | ⚠️ 需要增强 GTRS 规范 |
| **维护成本** | ⚠️ 需要维护验证器注册表 | ✅ 无需维护 |
| **扩展性** | ✅ 新增游戏时注册验证器 | ✅ 新增游戏时无需修改前端 |

---

## 推荐方案

### ✅ **方案 B：主题自己声明提供的资源，游戏自己检查**

**理由：**
1. ✅ **前端完全无依赖**：前端不知道任何游戏特定逻辑
2. ✅ **游戏完全自主**：游戏自己定义需要的资源，自己检查
3. ✅ **主题灵活**：主题可以声明提供了哪些资源
4. ✅ **GTRS 规范增强**：主题 JSON 包含 `providedResources` 字段
5. ✅ **零维护成本**：不需要维护验证器注册表

---

## 实施步骤

### 步骤 1：增强 GTRS 规范

```typescript
export interface GTRSThemeInfo {
  // ... 其他字段

  // 新增：主题提供的资源列表
  providedResources?: {
    images: {
      scene: string[]
      ui: string[]
      login: string[]
      icon: string[]
      effect: string[]
    }
    audio: {
      bgm: string[]
      effect: string[]
      voice: string[]
    }
  }
}
```

### 步骤 2：移除 GTRSThemeLoader 中的硬编码

```typescript
// ❌ 删除：validateRequiredResources() 方法中的硬编码
// ✅ 保留：validateRequiredResources() 方法，但不包含任何游戏特定逻辑
```

### 步骤 3：游戏自己实现资源检查

```typescript
class SnakePhaserGame {
  private readonly requiredResources = {
    images: ['bg_main', 'snake_head', 'snake_body', 'snake_tail', 'food_apple'],
    audio: ['sfx_eat', 'sfx_gameover']
  }

  private checkThemeResources(theme: GTRSTheme): void {
    // 游戏自己检查资源
  }
}
```

### 步骤 4：前端编辑器保存时自动生成 providedResources

```typescript
function generateProvidedResources(theme: GTRSTheme) {
  // 自动生成
}
```

### 步骤 5：删除 GameAssetConfig

```bash
rm kids-game-frontend/src/config/gameAssetConfig.ts
```

---

## 总结

### 核心原则

✅ **除了游戏本身，其他地方不应该存在依赖特定游戏的硬编码**

### 推荐方案

✅ **方案 B：主题自己声明提供的资源，游戏自己检查**

### 主要收益

1. ✅ **前端完全无依赖**：前端不知道任何游戏特定逻辑
2. ✅ **游戏完全自主**：游戏自己定义需要的资源，自己检查
3. ✅ **维护成本低**：不需要维护配置文件或注册表
4. ✅ **扩展性强**：新增游戏时无需修改前端

### 下一步

你想要我：

**A.** 立即实施方案 B（增强 GTRS 规范，移除硬编码）？

**B.** 先创建详细的实施计划？

**C.** 继续讨论其他方案？

请告诉我你的选择！
