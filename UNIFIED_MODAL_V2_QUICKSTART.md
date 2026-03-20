# 统一弹窗组件 V2 - 快速开始

## 🚀 5 分钟快速上手

### 1️⃣ 导入（仅需一行代码）

```typescript
import { modal } from '@/composables/useUnifiedModalV2';
```

### 2️⃣ 使用（超级简单）

```typescript
// 成功提示
modal.success('操作成功！');

// 错误提示
modal.error('出错了，请稍后重试');

// 确认框
const confirmed = await modal.question('确定要删除吗？');
if (confirmed) {
  // 执行删除
}

// 危险操作确认
const dangerConfirmed = await modal.danger('此操作不可恢复！');
```

## 📖 常用场景

### ✅ 提示用户

```typescript
// 信息
modal.info('这是一个提示信息');

// 成功
modal.success('保存成功！');

// 警告
modal.warning('请注意安全');

// 错误
modal.error('网络错误，请稍后重试');
```

### ❓ 确认操作

```typescript
// 普通确认
const ok = await modal.question('确定要执行这个操作吗？');

// 危险操作（红色按钮）
const ok = await modal.danger('确定要删除吗？此操作不可恢复');

// 自定义文本
const ok = await modal.question('确定继续？', {
  confirmText: '继续',
  cancelText: '再想想'
});
```

### 🎮 游戏相关

```typescript
// 游戏结算
modal.result('游戏结束', [
  { label: '得分', value: 1500 },
  { label: '连击', value: 25 },
  { label: '时间', value: '2:30' }
]);

// 获得奖励
modal.reward('恭喜获得奖励', '获得 100 趣乐币！');

// 等级提升
modal.levelup('恭喜升级', '当前等级：Lv.5');

// 游戏失败
modal.gameover('游戏结束', [
  { label: '最终得分', value: 850 },
  { label: '击败敌人', value: 12 }
]);
```

## 💡 完整示例

### 示例 1: 删除确认

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

async function handleDelete(id: number) {
  const confirmed = await modal.question('确定要删除这个项目吗？');
  
  if (confirmed) {
    try {
      await deleteItem(id);
      modal.success('删除成功！');
    } catch (error) {
      modal.error('删除失败，请重试');
    }
  }
}
</script>
```

### 示例 2: 游戏结算

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

function onGameEnd() {
  const stats = [
    { label: '得分', value: score },
    { label: '连击', value: combo },
    { label: '时间', value: formatTime(time) }
  ];
  
  modal.result('游戏结束', stats);
}
</script>
```

### 示例 3: 危险操作

```vue
<script setup lang="ts">
import { modal } from '@/composables/useUnifiedModalV2';

async function handleDangerousAction() {
  const confirmed = await modal.danger(
    '此操作将永久删除所有数据，确定继续？'
  );
  
  if (confirmed) {
    // 执行危险操作
  }
}
</script>
```

## 🎨 高级用法（可选）

### 自定义弹窗

```typescript
import { showUnifiedModalV2 } from '@/composables/useUnifiedModalV2';

showUnifiedModalV2({
  title: '自定义标题',
  type: 'info',
  size: 'lg',
  contentMaxHeight: '400px',
  customContent: '<div>自定义 HTML 内容</div>',
  actions: [
    { text: '取消', variant: 'secondary', onClick: () => {} },
    { text: '确定', variant: 'primary', onClick: () => {} }
  ]
});
```

### 模板方式使用

```vue
<template>
  <KidUnifiedModalV2
    v-model:show="showModal"
    title="标题"
    type="success"
    :closable="true"
    @confirm="handleConfirm"
  >
    <p>弹窗内容</p>
  </KidUnifiedModalV2>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import KidUnifiedModalV2 from '@/components/ui/KidUnifiedModalV2.vue';

const showModal = ref(false);
</script>
```

## ⚡ 类型速查

| 方法 | 用途 | 返回值 |
|------|------|--------|
| `modal.info()` | 信息提示 | `Promise<void>` |
| `modal.success()` | 成功提示 | `Promise<void>` |
| `modal.warning()` | 警告提示 | `Promise<void>` |
| `modal.error()` | 错误提示 | `Promise<void>` |
| `modal.question()` | 普通确认 | `Promise<boolean>` |
| `modal.danger()` | 危险确认 | `Promise<boolean>` |
| `modal.result()` | 游戏结算 | `Promise<void>` |
| `modal.reward()` | 奖励弹窗 | `Promise<void>` |
| `modal.levelup()` | 升级弹窗 | `Promise<void>` |
| `modal.gameover()` | 游戏结束 | `Promise<void>` |

## 🎯 尺寸选择

| 尺寸 | 宽度 | 适用场景 |
|------|------|----------|
| `sm` | 380px | 简单提示、确认框 |
| `md` | 500px | 标准弹窗（默认） |
| `lg` | 650px | 包含较多内容 |
| `xl` | 800px | 包含大量内容或表单 |

## ✨ 核心优势

✅ **简单** - 一行代码即可弹出  
✅ **统一** - 一个 API 替代所有弹窗  
✅ **美观** - 儿童主题动画效果  
✅ **智能** - 自动处理 ESC、滚动锁定  
✅ **灵活** - 支持完全自定义  

## 📚 更多资源

- 📖 [完整使用指南](./UNIFIED_MODAL_V2_GUIDE.md)
- 🎨 [在线演示](./kids-game-frontend/src/components/docs/UnifiedModalV2Demo.vue)
- 📝 [整合总结](./UNIFIED_MODAL_INTEGRATION_SUMMARY.md)

---

**开始使用吧！** 🚀
