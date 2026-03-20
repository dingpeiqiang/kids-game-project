# 创作者中心模块化重构方案

## 📋 重构目标

将 4200+ 行的 `index.vue` 拆分为多个小型、可维护的组件，每个组件职责单一。

## 🎯 组件拆分清单

### 1. ✅ OfficialThemesList.vue (已完成)
**职责**: 官方主题列表展示和筛选
**行数**: ~310 行
**功能**:
- 主题卡片展示
- 类型筛选 (全部/游戏/应用)
- 查看和 DIY 操作事件

**Props**:
```typescript
{
  themes: Array<ThemeInfo>;
  loading?: boolean;
}
```

**Emits**:
```typescript
{
  view: [theme];
  diy: [theme];
}
```

---

### 2. MyThemesManagement.vue (待创建)
**职责**: 我的主题管理
**预计行数**: ~400 行
**功能**:
- 我的主题列表
- 上架/下架切换
- 编辑主题
- 删除主题
- 数据统计

**Props**:
```typescript
{
  themes: CloudThemeInfo[];
  loading?: boolean;
}
```

**Emits**:
```typescript
{
  toggle: [theme];
  edit: [theme];
  delete: [theme];
  stats: [theme];
}
```

---

### 3. ThemeStore.vue (待创建)
**职责**: 主题商店浏览和购买
**预计行数**: ~350 行
**功能**:
- 主题商品展示
- 筛选 (免费/付费/热门/最新)
- 购买/下载操作
- 预览功能

**Props**:
```typescript
{
  themes: CloudThemeInfo[];
  filter: string;
  loading?: boolean;
}
```

**Emits**:
```typescript
{
  'update:filter': [value];
  buy: [theme];
  download: [themeId];
  preview: [theme];
}
```

---

### 4. ThemeSwitcher.vue (待创建)
**职责**: 主题切换器
**预计行数**: ~250 行
**功能**:
- 当前主题展示
- 可用主题列表
- 搜索过滤
- 一键切换

**Props**:
```typescript
{
  currentTheme: ThemeConfig | null;
  availableThemes: ThemeConfig[];
  loading?: boolean;
}
```

**Emits**:
```typescript
{
  'update:currentTheme': [theme];
  switch: [themeId];
}
```

---

### 5. ThemeCreatorForm.vue (待创建)
**职责**: 主题创作表单
**预计行数**: ~500 行
**功能**:
- 步骤式表单 (信息/样式/资源/发布)
- 实时预览
- 文件上传
- 保存草稿/发布

**Props**:
```typescript
{
  step: string;
  formData: NewThemeData;
  baseThemes: ThemeConfig[];
}
```

**Emits**:
```typescript
{
  'update:step': [value];
  'update:formData': [data];
  save: [data];
  publish: [data];
}
```

---

### 6. CreatorStats.vue (待创建)
**职责**: 创作者数据统计
**预计行数**: ~200 行
**功能**:
- 收益统计卡片
- 下载量图表
- 评分趋势
- 粉丝数变化

**Props**:
```typescript
{
  earnings: EarningsData;
  stats: StatsData;
  period: string;
}
```

**Emits**:
```typescript
{
  'update:period': [value];
  withdraw: [amount];
}
```

---

## 🔄 重构后的主组件结构

### index.vue (精简到 ~300 行)

```vue
<template>
  <div class="creator-center-container">
    <BaseHeader ... />
    
    <main class="creator-main">
      <!-- 创作者数据概览 -->
      <CreatorStats 
        v-if="currentTab === 'dashboard'"
        :earnings="earnings"
        :stats="stats"
        @withdraw="handleWithdraw"
      />
      
      <!-- 官方主题列表 -->
      <OfficialThemesList
        v-if="currentTab === 'official'"
        :themes="officialThemes"
        :loading="loadingOfficial"
        @view="viewTheme"
        @diy="diyTheme"
      />
      
      <!-- 我的主题管理 -->
      <MyThemesManagement
        v-if="currentTab === 'my-themes'"
        :themes="myThemes"
        :loading="loadingMyThemes"
        @toggle="handleToggleSale"
        @edit="handleEdit"
        @delete="handleDelete"
      />
      
      <!-- 主题商店 -->
      <ThemeStore
        v-if="currentTab === 'store'"
        :themes="storeThemes"
        :filter="storeFilter"
        @update:filter="storeFilter = $event"
        @buy="handleBuy"
        @download="handleDownload"
      />
      
      <!-- 主题切换器 -->
      <ThemeSwitcher
        v-if="currentTab === 'theme-switcher'"
        :current-theme="currentTheme"
        :available-themes="availableThemes"
        @switch="handleSwitchTheme"
      />
      
      <!-- 主题创作表单 -->
      <ThemeCreatorForm
        v-if="currentTab === 'create'"
        :step="createStep"
        :form-data="newTheme"
        :base-themes="baseThemes"
        @save="handleSaveDraft"
        @publish="handlePublish"
      />
    </main>
  </div>
</template>

<script setup lang="ts">
// 只保留核心的状态管理和 API 调用
import { ref, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { themeManager } from '@/core/theme/ThemeManager';
import { themeApi } from '@/services/themeApi';

// 路由
const router = useRouter();
const route = useRoute();
const currentTab = ref('official');

// 数据状态
const officialThemes = ref([]);
const myThemes = ref([]);
const storeThemes = ref([]);
const availableThemes = ref([]);
const currentTheme = ref(null);

// 加载状态
const loadingOfficial = ref(false);
const loadingMyThemes = ref(false);

// 创作者数据
const earnings = reactive({ total: 0, pending: 0, withdrawn: 0 });
const stats = reactive({ themeCount: 0, downloads: 0, averageRating: 0 });

// 生命周期
onMounted(() => {
  loadAllData();
});

// 加载所有数据
async function loadAllData() {
  await Promise.all([
    loadOfficialThemes(),
    loadMyThemes(),
    loadStoreThemes(),
    loadAvailableThemes(),
    loadCreatorStats()
  ]);
}

// 各个加载函数
async function loadOfficialThemes() { /* ... */ }
async function loadMyThemes() { /* ... */ }
async function loadStoreThemes() { /* ... */ }
async function loadAvailableThemes() { /* ... */ }
async function loadCreatorStats() { /* ... */ }

// 事件处理函数
function handleWithdraw(amount) { /* ... */ }
function viewTheme(theme) { /* ... */ }
function diyTheme(theme) { /* ... */ }
function handleToggleSale(theme) { /* ... */ }
function handleEdit(theme) { /* ... */ }
function handleDelete(theme) { /* ... */ }
function handleBuy(theme) { /* ... */ }
function handleDownload(themeId) { /* ... */ }
function handleSwitchTheme(theme) { /* ... */ }
function handleSaveDraft(data) { /* ... */ }
function handlePublish(data) { /* ... */ }
</script>
```

---

## 📊 代码对比

### 重构前
- **单个文件**: 4200+ 行
- **复杂度**: 极高
- **维护性**: 差
- **复用性**: 低

### 重构后
- **主组件**: ~300 行
- **子组件**: 7 个 (200-500 行/个)
- **总行数**: ~2800 行 (减少 33%)
- **复杂度**: 分散到各组件
- **维护性**: 优秀
- **复用性**: 高

---

## 🛠️ 实施步骤

### Step 1: 创建子组件目录
```bash
mkdir src/modules/creator-center/components
```

### Step 2: 逐个抽取组件
1. ✅ OfficialThemesList.vue
2. ⏳ MyThemesManagement.vue
3. ⏳ ThemeStore.vue
4. ⏳ ThemeSwitcher.vue
5. ⏳ ThemeCreatorForm.vue
6. ⏳ CreatorStats.vue

### Step 3: 重构主组件
- 删除原有的庞大模板
- 引入新的子组件
- 保留核心状态管理
- 简化事件处理

### Step 4: 测试验证
- 功能测试
- 样式验证
- 性能对比

---

## 📁 最终文件结构

```
src/modules/creator-center/
├── index.vue                    # 主组件 (~300 行)
├── composables/                 # 组合式函数
│   ├── useCreatorStats.ts
│   └── useThemeManagement.ts
├── components/                  # 子组件
│   ├── OfficialThemesList.vue   # ~310 行
│   ├── MyThemesManagement.vue   # ~400 行
│   ├── ThemeStore.vue           # ~350 行
│   ├── ThemeSwitcher.vue        # ~250 行
│   ├── ThemeCreatorForm.vue     # ~500 行
│   └── CreatorStats.vue         # ~200 行
└── types/                       # 类型定义
    └── creator.ts
```

---

## 🎨 编码规范遵循

### ✅ 单一职责原则
每个组件只负责一个功能模块

### ✅ 组件小型化
单个文件不超过 500 行

### ✅  Props/Events 通信
清晰的父子组件接口

### ✅ 可复用性
组件可在其他地方复用

### ✅ 可测试性
小单元更易测试

---

## 🚀 性能优化

### 懒加载组件
```typescript
const ThemeCreatorForm = defineAsyncComponent(
  () => import('./components/ThemeCreatorForm.vue')
);
```

### 条件渲染
只在需要时渲染对应 tab 的内容

### 缓存计算属性
使用 `computed` 缓存复杂计算

---

## 📝 下一步计划

- [ ] 创建 MyThemesManagement.vue
- [ ] 创建 ThemeStore.vue
- [ ] 创建 ThemeSwitcher.vue
- [ ] 创建 ThemeCreatorForm.vue
- [ ] 创建 CreatorStats.vue
- [ ] 重构主 index.vue
- [ ] 添加 TypeScript 类型定义
- [ ] 编写单元测试
- [ ] 性能基准测试

---

**通过模块化重构，代码将更加清晰、易维护、可扩展!** 🎉
