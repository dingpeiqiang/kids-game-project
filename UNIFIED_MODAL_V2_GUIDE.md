# 统一弹窗组件 V2 使用指南

## 📦 简介

**KidUnifiedModalV2** 是项目中所有弹窗组件的统一整合版本，提供了最全面的功能和最灵活的使用方式。

### ✨ 主要特性

- 🎨 **丰富的类型支持**: info, success, warning, error, question, result, reward, levelup, gameover
- 📏 **多种尺寸**: sm (380px), md (500px), lg (650px), xl (800px)，也支持自定义宽度
- 🎮 **游戏专用**: 内置游戏结算、奖励、升级、游戏结束等场景支持
- 🎯 **统计数据展示**: 支持展示游戏得分、连击等统计数据
- ⚡ **灵活的按钮**: 支持自定义操作按钮，支持水平/垂直布局
- 🎪 **精美动画**: 带有儿童主题的渐变、浮动、弹跳等动画效果
- ♿ **无障碍支持**: 支持 ESC 键关闭、自动锁定页面滚动
- 🖼️ **自定义内容**: 支持通过插槽放置任意 HTML/Vue 组件内容
- 💻 **编程式调用**: 提供 composable API，支持 Promise 方式调用

---

## 🚀 快速开始

### 方式一：模板方式使用

```vue
<template>
  <div>
    <button @click="showModal = true">打开弹窗</button>
    
    <KidUnifiedModalV2
      v-model:show="showModal"
      title="提示"
      type="info"
      :closable="true"
      @confirm="handleConfirm"
    >
      <p>这是弹窗内容</p>
    </KidUnifiedModalV2>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import KidUnifiedModalV2 from '@/components/ui/KidUnifiedModalV2.vue';

const showModal = ref(false);

function handleConfirm() {
  console.log('确认');
}
</script>
```

### 方式二：编程式调用（推荐）

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

// 简单提示
await modal.success('操作成功！');

// 确认框
const confirmed = await modal.question('确定要删除吗？');
if (confirmed) {
  // 执行删除
}

// 危险操作确认
const dangerConfirmed = await modal.danger('此操作不可恢复，确定继续？');
</script>
```

---

## 📖 Props 详细说明

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| show | `boolean` | `false` | 是否显示弹窗 |
| title | `string` | `-` | 弹窗标题 |
| subtitle | `string` | `-` | 副标题/描述 |
| type | `'info' \| 'success' \| 'warning' \| 'error' \| 'question' \| 'result' \| 'reward' \| 'levelup' \| 'gameover'` | `'info'` | 弹窗类型 |
| icon | `string` | `-` | 自定义图标 Emoji |
| size | `'sm' \| 'md' \| 'lg' \| 'xl'` | `'md'` | 弹窗尺寸 |
| width | `string` | `-` | 自定义宽度（优先级高于 size） |
| stats | [`Stat[]`](#stat) | `[]` | 统计数据数组 |
| actions | [`Action[]`](#action) | `[]` | 操作按钮数组 |
| actionsLayout | `'horizontal' \| 'vertical'` | `'vertical'` | 按钮布局方式 |
| closeOnClickOverlay | `boolean` | `false` | 点击遮罩是否关闭 |
| closable | `boolean` | `false` | 是否显示关闭按钮 |
| showDecorations | `boolean` | `true` | 是否显示装饰元素 |
| showFooter | `boolean` | `false` | 是否显示底部按钮区域 |
| showCancel | `boolean` | `true` | 是否显示取消按钮 |
| showConfirm | `boolean` | `true` | 是否显示确认按钮 |
| cancelText | `string` | `'取消'` | 取消按钮文本 |
| confirmText | `string` | `'确定'` | 确认按钮文本 |
| confirmVariant | `'primary' \| 'success' \| 'danger' \| 'warning'` | `'primary'` | 确认按钮样式 |
| contentMaxHeight | `string` | `-` | 内容区域最大高度 |
| style | `CSSProperties` | `-` | 自定义样式 |

---

## 🎯 Events 事件

| 事件名 | 回调参数 | 说明 |
|--------|----------|------|
| update:show | `(value: boolean)` | 显示状态变化时触发 |
| confirm | `-` | 点击确认按钮时触发 |
| cancel | `-` | 点击取消按钮时触发 |
| close | `-` | 关闭弹窗时触发 |

---

## 📊 类型定义

### Stat

统计数据接口，用于游戏结算等场景。

```typescript
interface Stat {
  label: string;   // 统计项标签，如 "得分"
  value: string | number;  // 统计项值，如 1500
}
```

### Action

操作按钮接口，用于自定义操作按钮。

```typescript
interface Action {
  text: string;  // 按钮文本
  variant?: 'primary' | 'secondary' | 'success' | 'danger' | 'warning';  // 按钮样式
  onClick: () => void;  // 点击回调函数
}
```

---

## 💡 使用示例

### 1️⃣ 基础提示

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

// 信息提示
modal.info('这是一个提示信息');

// 成功提示
modal.success('操作成功！');

// 警告提示
modal.warning('请注意安全');

// 错误提示
modal.error('出错了，请稍后重试');
</script>
```

### 2️⃣ 确认框

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

// 普通确认
const confirmed = await modal.question('确定要执行这个操作吗？');

// 危险操作确认
const dangerConfirmed = await modal.danger('此操作不可恢复，确定继续？');

// 带自定义文本的确认框
const customConfirmed = await modal.question('确定要删除吗？', {
  title: '删除确认',
  confirmText: '删除',
  cancelText: '再想想'
});
</script>
```

### 3️⃣ 游戏结算

```vue
<script setup lang="ts">
import { showUnifiedModalV2 } from '@/composables/useUnifiedModalV2';

showUnifiedModalV2({
  title: '游戏结束',
  type: 'result',
  stats: [
    { label: '得分', value: 1500 },
    { label: '连击', value: 25 },
    { label: '时间', value: '2:30' }
  ],
  actions: [
    { 
      text: '再来一局', 
      variant: 'primary', 
      onClick: () => restartGame() 
    },
    { 
      text: '返回首页', 
      variant: 'secondary', 
      onClick: () => goHome() 
    }
  ]
});
</script>
```

### 4️⃣ 奖励弹窗

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

modal.reward('恭喜获得奖励', '获得 100 趣乐币！');
</script>
```

### 5️⃣ 升级弹窗

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

modal.levelup('恭喜升级', '当前等级：Lv.5');
</script>
```

### 6️⃣ 自定义内容

```vue
<template>
  <KidUnifiedModalV2
    v-model:show="showModal"
    title="自定义内容"
    :closable="true"
  >
    <div class="custom-content">
      <p>在这里放置任意 HTML 内容</p>
      <img src="/path/to/image.png" alt="图片" />
      <form>
        <!-- 表单内容 -->
      </form>
    </div>
  </KidUnifiedModalV2>
</template>
```

### 7️⃣ 多个操作按钮

```vue
<script setup lang="ts">
import { showUnifiedModalV2 } from '@/composables/useUnifiedModalV2';

showUnifiedModalV2({
  title: '选择操作',
  type: 'question',
  actions: [
    { text: '取消', variant: 'secondary', onClick: () => console.log('取消') },
    { text: '稍后', variant: 'warning', onClick: () => console.log('稍后') },
    { text: '确定', variant: 'primary', onClick: () => console.log('确定') }
  ],
  actionsLayout: 'horizontal'
});
</script>
```

### 8️⃣ 超大尺寸弹窗

```vue
<script setup lang="ts">
import { showUnifiedModalV2 } from '@/composables/useUnifiedModalV2';

showUnifiedModalV2({
  title: '详细信息',
  type: 'info',
  size: 'xl',
  contentMaxHeight: '400px',
  customContent: `
    <div style="padding: 20px;">
      <p>这是一个超大尺寸的弹窗</p>
      <p>可以容纳大量内容...</p>
    </div>
  `
});
</script>
```

---

## 🎨 最佳实践

### 1. 选择合适的类型

根据场景选择合适的弹窗类型：
- 普通提示：`info`
- 操作成功：`success`
- 警告提示：`warning`
- 错误提示：`error`
- 确认操作：`question`
- 游戏结算：`result`
- 获得奖励：`reward`
- 等级提升：`levelup`
- 游戏失败：`gameover`

### 2. 编程式 vs 模板式

**推荐使用编程式调用**（`modal.xxx()`），代码更简洁：

```vue
<!-- ❌ 不推荐：需要在 template 中写很多代码 -->
<template>
  <div>
    <button @click="showDeleteConfirm = true">删除</button>
    <KidUnifiedModalV2
      v-model:show="showDeleteConfirm"
      title="删除确认"
      type="question"
      @confirm="handleDelete"
    >
      确定要删除这个项目吗？
    </KidUnifiedModalV2>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import KidUnifiedModalV2 from '@/components/ui/KidUnifiedModalV2.vue';

const showDeleteConfirm = ref(false);

function handleDelete() {
  // 执行删除
}
</script>
```

```vue
<!-- ✅ 推荐：使用编程式调用，代码简洁 -->
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

async function handleDelete() {
  const confirmed = await modal.question('确定要删除这个项目吗？');
  if (confirmed) {
    // 执行删除
  }
}
</script>
```

### 3. 处理用户操作

使用 Promise 方式处理用户操作：

```typescript
// ✅ 推荐：Promise 方式
const confirmed = await modal.question('确定吗？');
if (confirmed) {
  // 用户确认
} else {
  // 用户取消
}

// ❌ 不推荐：回调方式
modal.question('确定吗？', {
  actions: [
    { text: '取消', onClick: () => console.log('取消') },
    { text: '确定', onClick: () => console.log('确定') }
  ]
});
```

---

## 🔧 从旧组件迁移

### KidAlertDialog → modal.info/success/warning/error

```typescript
// 旧代码
<KidAlertDialog
  v-model:show="showAlert"
  title="提示"
  message="操作成功"
  type="success"
/>

// 新代码
modal.success('操作成功');
```

### KidConfirmModal → modal.question/danger

```typescript
// 旧代码
<KidConfirmModal
  v-model:show="showConfirm"
  title="确认"
  message="确定要删除吗？"
  @confirm="handleDelete"
/>

// 新代码
const confirmed = await modal.question('确定要删除吗？');
if (confirmed) {
  handleDelete();
}
```

### KidGameModal → showUnifiedModalV2

```typescript
// 旧代码
<KidGameModal
  v-model:show="showResult"
  title="游戏结束"
  type="result"
  :stats="[...]"
/>

// 新代码
showUnifiedModalV2({
  title: '游戏结束',
  type: 'result',
  stats: [...]
});
```

---

## 🎯 常见问题

### Q: 如何自定义弹窗样式？

A: 使用 `style` 属性或 `width` 属性：

```typescript
showUnifiedModalV2({
  title: '自定义样式',
  width: '600px',
  style: {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
  }
});
```

### Q: 如何让弹窗内容可滚动？

A: 使用 `contentMaxHeight` 属性：

```typescript
showUnifiedModalV2({
  title: '长内容',
  contentMaxHeight: '400px',
  customContent: '<div>...</div>'
});
```

### Q: 如何在弹窗中使用表单？

A: 通过插槽放置表单内容：

```vue
<KidUnifiedModalV2
  v-model:show="showModal"
  title="填写信息"
  :show-footer="true"
  @confirm="handleSubmit"
>
  <form>
    <input v-model="formData.name" placeholder="姓名" />
    <input v-model="formData.email" placeholder="邮箱" />
  </form>
</KidUnifiedModalV2>
```

---

## 📝 总结

KidUnifiedModalV2 是项目统一的弹窗组件，提供了：

- ✅ 丰富的类型和尺寸选择
- ✅ 游戏专用场景支持
- ✅ 编程式和模板式两种调用方式
- ✅ 精美的动画效果
- ✅ 完全的 TypeScript 支持
- ✅ 响应式设计

**推荐使用编程式调用** (`modal.xxx()`) 可以让代码更简洁易读！
