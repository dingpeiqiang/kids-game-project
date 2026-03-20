# KidUnifiedModal - 5 分钟快速开始

> 🚀 快速上手统一卡通弹窗组件

---

## ⚡ 第一步：导入使用（30 秒）

### 方式 1：按需导入（推荐）

```vue
<template>
  <KidUnifiedModal
    v-model:show="showModal"
    title="提示"
    type="success"
    message="操作成功！"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { KidUnifiedModal } from '@/components';

const showModal = ref(false);
</script>
```

### 方式 2：编程式调用（更简单）

```typescript
import { modal } from '@/composables/useUnifiedModal';

// 直接调用
await modal.success('保存成功！');
await modal.error('操作失败');
const confirmed = await modal.question('确定删除？');
```

---

## 🎯 第二步：选择场景（1 分钟）

根据你的需求选择合适的弹窗类型：

### 基础提示
```typescript
await modal.info('这是一个提示信息');
await modal.success('操作成功！');
await modal.warning('请小心操作');
await modal.error('出错了，请重试');
```

### 确认框
```typescript
// 普通确认
const ok = await modal.question('确定要删除吗？');
if (ok) {
  // 执行删除
}

// 危险操作确认（红色按钮）
const danger = await modal.danger('此操作不可恢复！');
if (danger) {
  // 执行危险操作
}
```

### 游戏场景
```typescript
// 游戏结算
modal.result('游戏结束', [
  { label: '得分', value: 1500 },
  { label: '时间', value: '2:30' }
]);

// 获得奖励
modal.reward('获得奖励', '恭喜你完成了所有挑战！');

// 等级提升
modal.levelup('等级提升', '恭喜你升级到 Lv.10！');

// 游戏结束
modal.gameover('挑战失败', [
  { label: '最终得分', value: 800 }
]);
```

---

## 🎨 第三步：自定义配置（2 分钟）

### 修改标题和图标

```typescript
await modal.success('操作成功', {
  title: '恭喜',
  icon: '🎉'  // 自定义 Emoji
});
```

### 修改尺寸

```typescript
await modal.info('这是一条很长的消息...', {
  size: 'lg'  // 'sm' | 'md' | 'lg'
});
```

### 自定义按钮

```typescript
await modal.question('你最喜欢什么颜色？', {
  actions: [
    { text: '红色', variant: 'danger', onClick: () => console.log('红') },
    { text: '蓝色', variant: 'primary', onClick: () => console.log('蓝') },
    { text: '绿色', variant: 'success', onClick: () => console.log('绿') }
  ],
  actionsLayout: 'horizontal'  // 水平排列按钮
});
```

### 添加统计数据

```typescript
modal.result('闯关成功', [
  { label: '得分', value: 1500 },
  { label: '连击', value: 25 },
  { label: '时间', value: '2:30' },
  { label: '准确率', value: '95%' }
], {
  title: '🎉 完美通关',
  subtitle: '恭喜你完成了所有挑战！'
});
```

---

## 💡 第四步：组件式使用（可选）

如果你需要在模板中使用组件：

### 基础用法

```vue
<template>
  <button @click="showModal = true">打开弹窗</button>
  
  <KidUnifiedModal
    v-model:show="showModal"
    title="提示"
    type="info"
    message="这是一个弹窗消息"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { KidUnifiedModal } from '@/components';

const showModal = ref(false);
</script>
```

### 带按钮的弹窗

```vue
<template>
  <KidUnifiedModal
    v-model:show="showConfirm"
    title="确认删除"
    type="question"
    message="确定要删除这个项目吗？"
    :actions="[
      { 
        text: '取消', 
        variant: 'secondary', 
        onClick: handleCancel 
      },
      { 
        text: '确定', 
        variant: 'primary', 
        onClick: handleConfirm 
      }
    ]"
  />
</template>

<script setup lang="ts">
const showConfirm = ref(false);

const handleCancel = () => {
  console.log('取消删除');
  showConfirm.value = false;
};

const handleConfirm = () => {
  console.log('确认删除');
  showConfirm.value = false;
};
</script>
```

### 游戏结算弹窗

```vue
<template>
  <KidUnifiedModal
    v-model:show="gameOver"
    title="游戏结束"
    type="result"
    :stats="[
      { label: '得分', value: score },
      { label: '连击', value: combo },
      { label: '时间', value: time }
    ]"
    :actions="[
      { text: '再来一局', variant: 'primary', onClick: restart },
      { text: '返回首页', variant: 'secondary', onClick: goHome }
    ]"
    actions-layout="horizontal"
  />
</template>

<script setup lang="ts">
const gameOver = ref(false);
const score = ref(1500);
const combo = ref(25);
const time = ref('2:30');

const restart = () => {
  console.log('重新开始');
  gameOver.value = false;
};

const goHome = () => {
  console.log('返回首页');
  gameOver.value = false;
};
</script>
```

---

## 📱 实战示例

### 示例 1：删除确认

```typescript
// 在组件方法中
async function handleDelete(itemId: number) {
  const confirmed = await modal.danger('删除后无法恢复，确定继续？');
  
  if (confirmed) {
    try {
      await deleteItem(itemId);
      await modal.success('删除成功！');
    } catch (error) {
      await modal.error('删除失败，请重试');
    }
  }
}
```

### 示例 2：游戏通关流程

```typescript
// 游戏结束时
function onGameComplete() {
  const stats = [
    { label: '得分', value: gameScore },
    { label: '连击', value: maxCombo },
    { label: '时间', value: gameTime }
  ];
  
  modal.result('闯关成功', stats, {
    title: '🎉 恭喜通关',
    subtitle: '太棒了！你完成了这个关卡',
    actions: [
      { 
        text: '下一关', 
        variant: 'success', 
        onClick: () => loadNextLevel() 
      },
      { 
        text: '再来一局', 
        variant: 'primary', 
        onClick: () => restartLevel() 
      }
    ]
  });
}
```

### 示例 3：答题反馈

```typescript
// 答题正确
function onAnswerCorrect(points: number) {
  modal.success('回答正确！', {
    subtitle: `恭喜你获得了 ${points} 点疲劳值`,
    icon: '⭐',
    actions: [
      { text: '继续答题', variant: 'primary', onClick: nextQuestion }
    ]
  });
}

// 答题错误
function onAnswerWrong() {
  modal.info('回答错误', {
    icon: '😢',
    subtitle: '没关系，再接再厉！',
    actions: [
      { text: '知道了', variant: 'secondary', onClick: closeModal }
    ]
  });
}
```

---

## ⚙️ 常用配置速查

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `type` | 弹窗类型 | `info`/`success`/`warning`/`error`/`question`/`result`/`reward`/`levelup`/`gameover` | `info` |
| `size` | 弹窗尺寸 | `sm`/`md`/`lg` | `md` |
| `icon` | 自定义图标 | Emoji 字符串 | 根据 type 自动匹配 |
| `title` | 标题 | 字符串 | - |
| `subtitle` | 副标题 | 字符串 | - |
| `message` | 消息内容 | 字符串 | - |
| `stats` | 统计数据 | `Stat[]` | `[]` |
| `actions` | 操作按钮 | `Action[]` | `[]` |
| `actionsLayout` | 按钮布局 | `horizontal`/`vertical` | `vertical` |
| `closeOnClickOverlay` | 点击遮罩关闭 | `boolean` | `false` |

---

## 🎯 最佳实践

### ✅ 推荐做法

```typescript
// 1. 及时反馈
await modal.success('保存成功');

// 2. 重要操作确认
const ok = await modal.danger('删除后无法恢复');

// 3. 游戏结果展示
modal.result('游戏结束', gameStats);

// 4. 成就奖励通知
modal.reward('获得成就', '收集大师');
```

### ❌ 避免做法

```typescript
// 1. 连续弹出多个弹窗
await modal.success('保存成功');
await modal.info('正在同步');
await modal.warning('请注意');

// 应该合并为一条
await modal.success('保存成功，正在同步数据...');

// 2. 滥用危险确认
await modal.danger('确定要退出吗？'); // 普通操作不需要危险确认

// 3. 不及时关闭弹窗
// 用户确认后应该及时关闭
const confirmed = await modal.question('确定？');
if (confirmed) {
  doSomething();
  // 弹窗已自动关闭，无需手动处理
}
```

---

## 🔍 常见问题

### Q: 如何自定义按钮文字？

```typescript
await modal.question('确定删除？', {
  confirmText: '删除',
  cancelText: '再想想'
});
```

### Q: 如何禁止点击遮罩关闭？

```typescript
await modal.success('操作成功', {
  closeOnClickOverlay: false  // 禁止点击遮罩关闭
});
```

### Q: 如何显示大尺寸弹窗？

```typescript
await modal.info('这是一条很长的消息...', {
  size: 'lg'
});
```

### Q: 如何让按钮水平排列？

```typescript
modal.result('游戏结束', stats, {
  actionsLayout: 'horizontal'
});
```

### Q: 如何在弹窗中使用插槽？

```vue
<KidUnifiedModal v-model:show="show">
  <div class="custom-content">
    <p>这里是自定义内容</p>
    <img src="/award.png" alt="奖励" />
  </div>
  
  <template #actions>
    <button @click="handleClose">关闭</button>
  </template>
</KidUnifiedModal>
```

---

## 📚 进阶学习

- 📖 [完整使用指南](./kids-game-frontend/src/components/docs/KID_UNIFIED_MODAL_GUIDE.md)
- 🎨 [演示页面](./kids-game-frontend/src/components/docs/UnifiedModalDemo.vue)
- 📝 [重构总结](./KID_UNIFIED_MODAL_SUMMARY.md)

---

## 🎉 开始使用

现在你已经掌握了基本用法，开始在你的项目中使用吧！

```typescript
import { modal } from '@/composables/useUnifiedModal';

// 立即体验
await modal.success('Hello, KidUnifiedModal! 🎨');
```

---

**最后更新**: 2026-03-18  
**版本**: v1.0.0
