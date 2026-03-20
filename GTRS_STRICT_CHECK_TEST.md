# GTRS 严格资源检查测试

## 修改内容

在 `GTRSThemeLoader.ts` 中添加了 `validateRequiredResources()` 方法，用于严格检查游戏运行必需的资源。

## 必需资源列表

贪吃蛇游戏运行时必须提供以下 `scene` 分类图片资源：

1. `bg_main` - 游戏背景
2. `snake_head` - 蛇头
3. `snake_body` - 蛇身
4. `snake_tail` - 蛇尾
5. `food_apple` - 苹果食物

## 行为

- ✅ 如果所有必需资源都存在：游戏正常启动
- ❌ 如果缺少任何必需资源：抛出 `GTRSValidationError`，阻止游戏启动

## 当前状态

**当前 `gtrs-theme-snake.json` 配置：**
```json
"resources": {
  "images": {
    "scene": {}  // 空对象，没有定义任何图片资源
  }
}
```

**预期结果：**
启动游戏时应该看到错误：
```
[GTRS] 主题 JSON 不符合规范，共 5 个错误:
  · 游戏运行必需资源缺失:
  · 缺少必需的 scene 图片资源: bg_main (游戏背景)
  · 缺少必需的 scene 图片资源: snake_head (蛇头)
  · 缺少必需的 scene 图片资源: snake_body (蛇身)
  · 缺少必需的 scene 图片资源: snake_tail (蛇尾)
  · 缺少必需的 scene 图片资源: food_apple (苹果食物)
```

## 如何修复

有两种选择：

### 方案 1：提供真实的图片资源（推荐用于生产环境）

在 `gtrs-theme-snake.json` 中添加完整的图片资源定义：

```json
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
```

### 方案 2：移除游戏中的资源依赖（使用程序化渲染）

如果不想提供图片资源，需要修改游戏代码，将所有使用 `getThemeAssetKey()` 的地方改为程序化绘制。

**不推荐：** 这会使游戏看起来很简陋，且不符合用户体验标准。

---

## 下一步

请告诉我你想采用哪个方案：
- **方案 1**：我会帮你准备占位图片或生成真实的图片资源
- **方案 2**：我会修改游戏代码，移除所有资源依赖
