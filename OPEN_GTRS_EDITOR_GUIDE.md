# GTRS主题编辑器使用指南

## 🎨 打开方式

### 方式一：通过路由访问（推荐）

**URL路径**：
```
http://localhost:5173/admin/gtrs-theme-creator
```

### 方式二：通过管理菜单访问

**路径**：
```
首页 → 创作者中心 → 主题创作 → GTRS主题编辑器
```

---

## 🔧 路由集成步骤

### 步骤1：添加路由配置

在 `kids-game-frontend/src/router/index.ts` 中添加GTRS编辑器路由：

```typescript
// 导入GTRS主题编辑器组件
import GTRSThemeCreator from '@/modules/admin/components/GTRSThemeCreator.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    // ... 其他路由
    
    // GTRS主题编辑器路由
    {
      path: '/admin/gtrs-theme-creator',
      name: 'GTRSThemeCreator',
      component: GTRSThemeCreator,
      meta: {
        title: 'GTRS主题编辑器',
        requiresAuth: true,
        role: 'admin'
      }
    }
  ]
})

export default router
```

### 步骤2：添加菜单项

在创作者中心菜单中添加GTRS编辑器入口：

**文件位置**：`kids-game-frontend/src/modules/admin/components/CreatorCenter.vue`

```vue
<template>
  <div class="creator-center">
    <el-menu
      :default-active="activeMenu"
      class="sidebar-menu"
      @select="handleMenuSelect"
    >
      <!-- 现有菜单项 -->
      <el-menu-item index="theme-list">
        <el-icon><List /></el-icon>
        <span>主题列表</span>
      </el-menu-item>
      
      <el-menu-item index="theme-create">
        <el-icon><Plus /></el-icon>
        <span>创建主题</span>
      </el-menu-item>

      <!-- 新增：GTRS主题编辑器 -->
      <el-menu-item index="gtrs-theme-creator">
        <el-icon><Brush /></el-icon>
        <span>GTRS主题编辑器</span>
      </el-menu-item>

      <!-- ... 其他菜单项 -->
    </el-menu>

    <!-- 内容区域 -->
    <div class="content">
      <!-- ... -->
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeMenu = ref('theme-list')

const handleMenuSelect = (index: string) => {
  activeMenu.value = index
  
  switch(index) {
    case 'gtrs-theme-creator':
      router.push('/admin/gtrs-theme-creator')
      break
    // ... 其他case
  }
}
</script>
```

---

## 🚀 快速启动指南

### 1. 启动前端开发服务器

```bash
cd kids-game-frontend
npm run dev
```

### 2. 访问GTRS编辑器

**直接访问**：
```
http://localhost:5173/admin/gtrs-theme-creator
```

**或通过菜单访问**：
1. 打开首页：`http://localhost:5173`
2. 点击"创作者中心"
3. 选择"GTRS主题编辑器"

---

## 📝 编辑器功能说明

### 界面布局

```
┌─────────────────────────────────────────────────┐
│  🎨 GTRS 主题编辑器                          │
│  [加载模板] [重置默认] [保存主题]            │
├──────────────────┬──────────────────────────────┤
│                  │                              │
│  📋 编辑区       │  👁️ 预览区                  │
│                  │                              │
│  主题基础信息     │  主题名称                    │
│  全局样式        │  ID: game_default_theme     │
│  图片资源        │  创作者: 官方               │
│  音频资源        │                              │
│                  │  🎨 样式预览                │
│                  │  [主色调] [背景色] [文字色]     │
│                  │                              │
│                  │  📊 资源统计                │
│                  │  登录图片: 3 个            │
│                  │  UI图片: 5 个             │
│                  │  背景音乐: 2 个            │
│                  │  音效: 4 个               │
│                  │                              │
│                  │  ✅ 校验结果                │
│                  │  ✓ 校验通过                │
└──────────────────┴──────────────────────────────┘
```

### 核心功能

#### 1. 主题基础信息
- 主题ID（英文+数字+下划线）
- 游戏ID
- 主题名称（支持中文）
- 默认主题开关
- 创作者名称
- 主题描述

#### 2. 全局样式
- 主色调（颜色选择器）
- 辅助色
- 背景色
- 文字颜色
- 字体
- 圆角

#### 3. 图片资源管理

**5个分类**：
- **登录图片** (login)：登录背景、Logo、按钮等
- **场景图片** (scene)：游戏背景、角色、道具等
- **UI图片** (ui)：面板、按钮、进度条等
- **图标** (icon)：播放、暂停、设置等图标
- **特效图片** (effect)：爆炸、星星、升级等特效

**操作**：
- 点击"+添加图片"按钮
- 自动生成英文Key（如：login_img_1710891234567_123）
- 填写中文名称（如：登录背景图）
- 输入资源路径（如：assets/themes/default/login/bg.png）
- 选择图片格式（PNG/JPG/WEBP/GIF）
- 点击"删除"按钮移除资源

#### 4. 音频资源管理

**3个分类**：
- **背景音乐** (bgm)：主音乐、战斗音乐等
- **音效** (effect)：点击、成功、失败等音效
- **语音** (voice)：角色语音（预留）

**操作**：
- 点击"+添加音频"按钮
- 自动生成英文Key（如：bgm_audio_1710891234567_123）
- 填写中文名称（如：主背景音乐）
- 输入资源路径（如：assets/themes/default/audio/bgm_main.mp3）
- 调节音量（0~1，滑块）
- 选择音频格式（MP3/WAV/OGG）
- 点击"删除"按钮移除资源

#### 5. 实时预览
- 主题名称显示
- 样式颜色预览
- 资源统计
- 校验结果反馈

#### 6. Schema校验
- 前端实时校验
- 自动检测格式错误
- 错误路径和消息显示
- 校验通过/失败状态

---

## 💡 使用示例

### 示例1：创建贪吃蛇主题

**步骤**：

1. **填写基础信息**
   ```
   主题ID: snake_game_theme_forest
   游戏ID: game_snake_v3
   主题名称: 森林主题
   创作者: 官方
   描述: 贪吃蛇的森林冒险主题
   ```

2. **配置全局样式**
   ```
   主色调: #4CAF50 (绿色)
   辅助色: #8BC34A (浅绿)
   背景色: #2E7D32 (深绿)
   文字颜色: #FFFFFF (白色)
   ```

3. **添加图片资源**
   - 登录图片
     - login_bg: 森林背景.png
     - login_logo: 蛇Logo.png
   - 场景图片
     - snake_head: 蛇头.png
     - food_apple: 苹果.png
   - UI图片
     - ui_panel_score: 分数面板.png

4. **添加音频资源**
   - 背景音乐
     - bgm_forest: 森林音乐.mp3 (音量: 0.6)
   - 音效
     - effect_eat: 吃东西.mp3 (音量: 0.5)
     - effect_crash: 碰撞.mp3 (音量: 0.6)

5. **保存主题**
   - 点击"保存主题"按钮
   - 查看校验结果
   - 确认无误后提交到后端

### 示例2：从模板快速创建

**步骤**：

1. 点击"加载模板"按钮
2. 系统自动加载 `gtrs-template.json`
3. 修改主题信息
4. 添加所需的资源
5. 保存主题

---

## 🔍 故障排查

### 问题1：页面404

**原因**：路由未配置

**解决**：
```typescript
// 检查 router/index.ts 是否包含GTRS路由
{
  path: '/admin/gtrs-theme-creator',
  name: 'GTRSThemeCreator',
  component: () => import('@/modules/admin/components/GTRSThemeCreator.vue')
}
```

### 问题2：组件未找到

**原因**：组件路径错误

**解决**：
```bash
# 确认文件存在
ls kids-game-frontend/src/modules/admin/components/GTRSThemeCreator.vue
```

### 问题3：校验失败

**原因**：JSON格式不符合GTRS规范

**解决**：
1. 检查4个顶级字段是否存在
2. 检查资源分类是否正确
3. 检查Key是否为纯英文
4. 查看错误提示，逐项修正

### 问题4：资源路径错误

**原因**：路径格式不正确

**解决**：
- 使用相对路径：`assets/themes/theme_name/resource.png`
- 或使用绝对URL：`https://cdn.example.com/resource.png`

---

## 📚 相关文档

- [GTRS v1.0.0 官方规范](./GTRS_V1_SPECIFICATION.md)
- [GTRS 升级完成总结](./GTRS_UPGRADE_SUMMARY.md)
- [游戏集成指南](./GAME_INTEGRATION_GUIDE.md)

---

**快速访问链接**：

开发环境：`http://localhost:5173/admin/gtrs-theme-creator`
生产环境：`https://your-domain.com/admin/gtrs-theme-creator`

---

**开始创作吧！🎨**
