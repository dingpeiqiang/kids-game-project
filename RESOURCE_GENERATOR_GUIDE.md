# 🎨 游戏资源生成指南

本指南教你如何使用工具生成游戏所需的图片资源。

---

## 📋 目录

1. [快速开始](#快速开始)
2. [方法一：浏览器生成器 (推荐)](#方法一浏览器生成器-推荐)
3. [方法二：Node.js 批量生成](#方法二 nodejs-批量生成)
4. [生成的资源列表](#生成的资源列表)
5. [资源使用示例](#资源使用示例)
6. [常见问题](#常见问题)

---

## 🚀 快速开始

### 选择生成方式

**方式 1: 浏览器生成器 (最简单)**
```bash
# 直接在浏览器中打开
start easy-resource-generator.html
```

✅ 无需安装任何依赖  
✅ 可视化预览  
✅ 支持单个或批量下载  

**方式 2: Node.js 脚本 (适合批量)**
```bash
# 1. 安装 canvas 库
npm install canvas

# 2. 运行生成脚本
node generate-resources.js
```

✅ 自动化批量生成  
✅ 直接输出到项目目录  
✅ 适合集成到构建流程  

---

## 🌐 方法一：浏览器生成器 (推荐)

### 步骤 1: 打开生成器

双击打开 `easy-resource-generator.html` 文件，或在浏览器中访问:
```
file:///c:/Users/a1521/Desktop/kids-game-project/easy-resource-generator.html
```

### 步骤 2: 选择要生成的资源

点击对应的按钮:

- **🐍 生成贪吃蛇资源** - 生成蛇头、蛇身、食物等
- **✈️ 生成飞机大战资源** - 生成玩家飞机、敌机、子弹等
- **💾 下载所有资源** - 批量下载已生成的资源

### 步骤 3: 预览和下载

生成过程中会实时显示:
- ✅ 资源预览图
- ✅ 资源名称和尺寸
- ✅ 生成进度条
- ✅ 统计信息 (总数和大小)

每个资源都可以:
- 单独点击下载
- 点击"下载所有"批量下载

### 生成的资源

#### 贪吃蛇系列 (7 个资源)
1. `snake_orange_happy.png` (64x64) - 橙色蛇头 (开心表情)
2. `snake_orange_cool.png` (64x64) - 绿色蛇头 (酷酷表情)
3. `snake_body_segment.png` (64x64) - 蛇身体节
4. `food_apple.png` (48x48) - 苹果食物
5. `food_strawberry.png` (48x48) - 草莓食物
6. `particle_sparkle.png` (32x32) - 粒子特效
7. `background_grid.png` (800x600) - 网格背景

#### 飞机大战系列 (6 个资源)
1. `player_plane_blue.png` (80x80) - 蓝色玩家飞机
2. `enemy_plane_red.png` (70x70) - 红色敌机
3. `bullet_player.png` (20x40) - 玩家子弹
4. `bullet_enemy.png` (20x40) - 敌人子弹
5. `explosion_effect.png` (100x100) - 爆炸效果
6. `background_space.png` (800x600) - 星空背景

---

## 💻 方法二：Node.js 批量生成

### 前置要求

需要安装 Node.js 和 canvas 库:

```bash
# 检查 Node.js 版本
node --version

# 安装 canvas 库
npm install canvas
```

如果安装 canvas 失败，可能需要:
- Windows: 安装 [Build Tools for Visual Studio](https://visualstudio.microsoft.com/downloads/)
- macOS: 安装 Xcode Command Line Tools
- Linux: 安装 Cairo、Pango 等依赖

### 执行生成

在项目根目录执行:

```bash
node generate-resources.js
```

输出示例:
```
🎮 游戏资源批量生成器
==================================================
输出目录：C:\...\kids-game-frontend\public\images\games

🐍 正在生成贪吃蛇资源...
✅ 创建目录：...\snake-shooter
✅ 生成：...\snake_orange_happy.png
✅ 生成：...\snake_orange_cool.png
...
✅ 贪吃蛇资源生成完成!

✈️  正在生成飞机大战资源...
✅ 生成：...\player_plane_blue.png
...
✅ 飞机大战资源生成完成!

🎨 正在生成主题资源...
✅ 生成：...\pastel_background.png
...
✅ 主题资源生成完成!

==================================================
✅ 所有资源生成完成! 🎉
```

### 输出位置

生成的资源会自动保存到:
```
kids-game-frontend/public/images/games/
├── snake-shooter/       # 贪吃蛇资源
├── plane-shooter/       # 飞机大战资源
└── themes/             # 主题资源
```

---

## 📦 生成的资源列表

### 贪吃蛇游戏资源

| 文件名 | 尺寸 | 说明 | 用途 |
|--------|------|------|------|
| `snake_orange_happy.png` | 64x64 | 橙色蛇头 (开心) | 蛇头部渲染 |
| `snake_orange_cool.png` | 64x64 | 绿色蛇头 (墨镜) | 蛇头部渲染 |
| `snake_body_segment.png` | 64x64 | 蛇身体节 | 蛇身体渲染 |
| `food_apple.png` | 48x48 | 红苹果 | 食物道具 |
| `food_strawberry.png` | 48x48 | 草莓 | 食物道具 |
| `particle_sparkle.png` | 32x32 | 闪光粒子 | 特效动画 |
| `background_grid.png` | 800x600 | 网格背景 | 游戏背景 |

### 飞机大战游戏资源

| 文件名 | 尺寸 | 说明 | 用途 |
|--------|------|------|------|
| `player_plane_blue.png` | 80x80 | 蓝色彩色飞机 | 玩家战机 |
| `enemy_plane_red.png` | 70x70 | 红色敌机 | 敌方战机 |
| `bullet_player.png` | 20x40 | 黄色子弹 | 玩家攻击 |
| `bullet_enemy.png` | 20x40 | 红色子弹 | 敌人攻击 |
| `explosion_effect.png` | 100x100 | 爆炸特效 | 击毁效果 |
| `background_space.png` | 800x600 | 星空背景 | 游戏背景 |

### 主题系统资源

| 文件名 | 尺寸 | 说明 | 用途 |
|--------|------|------|------|
| `pastel_background.png` | 400x300 | 粉彩渐变背景 | 应用主题背景 |
| `button_primary.png` | 200x60 | 主色调按钮 | UI 组件 |
| `button_secondary.png` | 200x60 | 辅助色按钮 | UI 组件 |
| `icon_placeholder.png` | 64x64 | 占位符图标 | 临时图标 |

---

## 🎯 资源使用示例

### 在贪吃蛇游戏中使用

```typescript
// 加载蛇头资源
const snakeHeadImg = new Image();
snakeHeadImg.src = '/images/games/snake-shooter/snake_orange_happy.png?hash=head123';

// 在游戏渲染中使用
function renderSnake(ctx: CanvasRenderingContext2D, snake: Snake) {
  snake.segments.forEach((segment, index) => {
    if (index === 0) {
      // 绘制蛇头
      ctx.drawImage(snakeHeadImg, segment.x, segment.y, 64, 64);
    } else {
      // 绘制蛇身...
    }
  });
}
```

### 在主题系统中使用

```typescript
// 主题资源配置
const themeAssets = {
  bg_main: {
    type: 'image',
    url: '/images/games/themes/pastel_background.png'
  },
  btn_primary: {
    type: 'image',
    url: '/images/games/themes/button_primary.png'
  }
};

// 应用到 CSS
function applyTheme(theme: ThemeConfig) {
  document.documentElement.style.setProperty(
    '--bg-main',
    `url(${theme.assets.bg_main.url})`
  );
}
```

---

## ❓ 常见问题

### Q1: 浏览器生成器无法打开？

**A:** 确保使用现代浏览器 (Chrome/Edge/Firefox),直接双击 HTML 文件即可。

### Q2: Node.js 安装 canvas 失败？

**A:** canvas 需要编译原生模块，请参考官方文档安装依赖:
- Windows: 安装 Visual Studio Build Tools
- macOS: `xcode-select --install`
- Linux: `sudo apt-get install libcairo2-dev libpango1.0-dev`

或者使用浏览器生成器，无需安装任何依赖!

### Q3: 生成的图片太模糊？

**A:** 可以修改生成脚本中的尺寸参数。例如将 64x64 改为 128x128:
```javascript
const canvas = createCanvas(128, 128); // 增大尺寸
```

### Q4: 如何自定义资源样式？

**A:** 有两种方式:
1. 修改生成脚本中的绘制函数 (颜色、形状等)
2. 使用图像编辑软件 (Photoshop/GIMP) 后期处理

### Q5: 资源可以用于商业项目吗？

**A:** 可以！这些资源都是使用 Canvas 2D API 绘制的原创素材，可以自由使用。

---

## 🔧 高级定制

### 修改颜色方案

在生成脚本中找到对应的绘制函数，修改颜色值:

```javascript
// 修改蛇的颜色
ctx.fillStyle = '#FF9800'; // 改为其他颜色，如 '#E91E63'
```

### 添加新资源

在 resources 数组中添加新的配置:

```javascript
const resources = [
  // ... 现有资源
  { 
    name: 'new_item.png', 
    size: 64, 
    draw: drawNewItem // 实现绘制函数
  }
];
```

### 调整输出格式

修改保存函数，可以输出不同格式:

```javascript
// JPEG 格式 (更小体积)
canvas.toBuffer('image/jpeg', { quality: 0.9 });

// WebP 格式 (更好压缩)
canvas.toBuffer('image/webp');
```

---

## 📞 技术支持

如有问题，请查看:
- [Canvas API 文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Canvas_API)
- [Node.js Canvas 仓库](https://github.com/Automattic/node-canvas)

---

**祝你创作愉快！** 🎨✨
