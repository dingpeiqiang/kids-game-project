# 主题加载错误检测与提示实现

## 概述

为贪吃蛇游戏添加了严格的主题资源检测和友好的错误提示系统，确保游戏启动前验证所有必需资源，并在检测失败时给用户清晰的反馈。

## 修改内容

### 1. GTRSThemeLoader.ts - 添加严格资源检查

**新增方法：`validateRequiredResources()`**

```typescript
private validateRequiredResources(): void {
  const errors: string[] = []

  // 贪吃蛇游戏必需的 scene 资源
  const requiredSceneImages: Record<string, string> = {
    bg_main: '游戏背景',
    snake_head: '蛇头',
    snake_body: '蛇身',
    snake_tail: '蛇尾',
    food_apple: '苹果食物'
  }

  for (const [key, name] of Object.entries(requiredSceneImages)) {
    const phaserKey = buildImageKey('scene', key)
    if (!this.registeredImages.has(phaserKey)) {
      errors.push(`缺少必需的 scene 图片资源: ${key} (${name})`)
    }
  }

  if (errors.length > 0) {
    throw new GTRSValidationError([...errors])
  }
}
```

**调用位置：** 在 `registerResources()` 方法末尾自动调用

**行为：**
- ✅ 如果所有必需资源都存在：正常继续
- ❌ 如果缺少任何必需资源：抛出 `GTRSValidationError`，阻止游戏启动

---

### 2. SnakeGame.vue - 友好的错误提示 UI

#### 新增错误状态

```typescript
const loadError = ref<{
  type: 'gtrs_validation' | 'network' | 'unknown'
  message: string
  errors?: string[]
  themeInfo?: { themeName: string; themeId: string }
  rawError: string
} | null>(null)
```

#### 错误提示覆盖层

**视觉效果：**
- 红色渐变背景（`from-red-900/90 to-red-950/90`）
- 半透明黑色遮罩（`bg-black/80`）
- 毛玻璃效果（`backdrop-blur-md`）
- 动画效果（`slideIn`, `bounceIn`, `pulse`）

**显示内容：**
1. **错误图标**：⚠️（带脉冲动画）
2. **错误标题**："主题加载失败"
3. **错误详情**：
   - GTRS 验证错误：列出所有缺失的资源
   - 其他错误：显示错误消息
4. **主题信息**：显示主题名称和 ID
5. **操作按钮**：
   - "返回" - 返回上一页
   - "重新加载" - 重新尝试加载主题
6. **技术详情**（折叠）：显示完整的错误堆栈

#### 错误处理逻辑

```typescript
try {
  await phaserGame.start(settingsStore.difficulty, themeId)
} catch (err) {
  if (err instanceof GTRSValidationError) {
    // 提取缺失资源列表
    const missingResources = err.errors
      .filter(e => e.includes('缺少必需的 scene 图片资源'))
      .map(e => e.replace('缺少必需的 scene 图片资源: ', ''))

    loadError.value = {
      type: 'gtrs_validation',
      message: '主题配置缺少游戏运行必需的图片资源',
      errors: missingResources,
      rawError: err.toString()
    }
  } else {
    // 其他错误
    loadError.value = {
      type: 'unknown',
      message: (err as Error).message || '未知错误',
      rawError: (err as Error).toString()
    }
  }
  return // 不进入游戏循环
}
```

---

## 工作流程

```
1. 用户打开游戏页面
   ↓
2. 组件挂载（onMounted）
   ↓
3. 调用 phaserGame.start()
   ↓
4. Phaser 预加载阶段（preload）
   ↓
5. GTRSThemeLoader.load()
   ├─ 加载主题 JSON
   ├─ 验证 GTRS 格式
   ├─ 注册资源
   └─ ⭐ validateRequiredResources() ← 严格检查
       ├─ 检查 bg_main
       ├─ 检查 snake_head
       ├─ 检查 snake_body
       ├─ 检查 snake_tail
       └─ 检查 food_apple
   ↓
6a. 检查通过 → 游戏正常启动
6b. 检查失败 → 抛出 GTRSValidationError
   ↓
7. SnakeGame.vue 捕获异常
   ↓
8. 显示友好的错误提示 UI
   └─ 用户点击"返回"或"重新加载"
```

---

## 必需资源列表

| 资源 Key | 描述 | 分类 | 用途 |
|---------|------|------|------|
| `bg_main` | 游戏背景 | scene | 游戏主背景图 |
| `snake_head` | 蛇头 | scene | 蛇的头部图片 |
| `snake_body` | 蛇身 | scene | 蛇的身体图片 |
| `snake_tail` | 蛇尾 | scene | 蛇的尾部图片 |
| `food_apple` | 苹果食物 | scene | 食物图片（苹果） |

---

## 错误提示示例

### GTRS 验证错误

```
⚠️ 主题加载失败

主题配置缺少游戏运行必需的图片资源

  • bg_main (游戏背景)
  • snake_head (蛇头)
  • snake_body (蛇身)
  • snake_tail (蛇尾)
  • food_apple (苹果食物)

主题信息
经典绿野
ID: snake_default_v1

[返回] [重新加载]

▼ 查看技术详情
  [GTRSValidationError: 主题 JSON 不符合规范...]
```

---

## 如何修复缺失资源

### 方案 1：提供真实的图片资源

在主题 JSON 中添加完整的资源定义：

```json
{
  "resources": {
    "images": {
      "scene": {
        "bg_main": {
          "src": "https://your-cdn.com/themes/snake/bg-main.png",
          "type": "png",
          "alias": "游戏背景"
        },
        "snake_head": {
          "src": "https://your-cdn.com/themes/snake/snake-head.png",
          "type": "png",
          "alias": "蛇头"
        },
        "snake_body": {
          "src": "https://your-cdn.com/themes/snake/snake-body.png",
          "type": "png",
          "alias": "蛇身"
        },
        "snake_tail": {
          "src": "https://your-cdn.com/themes/snake/snake-tail.png",
          "type": "png",
          "alias": "蛇尾"
        },
        "food_apple": {
          "src": "https://your-cdn.com/themes/snake/food-apple.png",
          "type": "png",
          "alias": "苹果食物"
        }
      }
    }
  }
}
```

### 方案 2：使用占位图片

可以创建一个简单的占位图片生成器，自动生成纯色占位图。

---

## 技术特点

1. **严格检查**：游戏启动前验证所有必需资源，不符合则拒绝启动
2. **友好提示**：使用美观的 UI 显示错误，而非原生的 `alert()`
3. **详细信息**：显示缺失资源列表、主题信息、技术详情
4. **用户操作**：提供"返回"和"重新加载"按钮
5. **动画效果**：使用过渡动画提升用户体验
6. **响应式设计**：适配移动端和桌面端

---

## 测试

### 测试场景 1：缺少必需资源

**操作：** 使用当前 `gtrs-theme-snake.json`（`resources.images.scene` 为空对象 `{}`）

**预期结果：**
- 游戏启动时立即显示错误提示
- 列出所有 5 个缺失的资源
- 用户可以选择返回或重新加载

### 测试场景 2：资源完整

**操作：** 在主题 JSON 中添加所有必需的资源定义

**预期结果：**
- 游戏正常启动
- 不显示错误提示
- 游戏正常渲染

---

## 下一步

当前实现已经完成，现在：

1. **选择解决方案**：
   - 提供真实的图片资源（推荐）
   - 或移除游戏中的资源依赖（不推荐）

2. **测试验证**：
   - 启动游戏，查看错误提示是否正常显示
   - 添加资源后验证游戏能否正常启动

请告诉我你想采用哪个方案，我会继续帮你实现！
