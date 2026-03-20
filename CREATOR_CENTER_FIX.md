# 创作者中心官方主题加载修复

## 问题描述

创作者中心的"官方主题"列表使用的是前端硬编码的模拟数据，没有从后台 API 查询真实的主题数据。

## 已完成的修改

### 1. 导入 themeApi
在 `src/modules/creator-center/index.vue` 中添加了 API 导入:

```typescript
import { themeApi } from '@/services/themeApi';
```

### 2. 修改数据结构
将 `officialThemes` 从硬编码的数组改为空数组初始化:

```typescript
// 官方主题 - 从后台加载 (不再硬编码)
const officialThemes = ref<Array<{...}>>([]);

// 官方主题加载中状态
const loadingOfficialThemes = ref(false);
```

### 3. 添加加载函数
创建了 `loadOfficialThemes()` 异步函数:

```typescript
async function loadOfficialThemes(): Promise<void> {
  loadingOfficialThemes.value = true;
  try {
    // 从后台查询所有状态为 on_sale 的主题
    const response = await themeApi.getList({ status: 'on_sale' });
    
    if (response.success && response.data) {
      // 将云主题转换为官方主题格式
      officialThemes.value = response.data.map((theme: CloudThemeInfo) => ({
        id: theme.id,
        name: theme.name,
        type: 'game', // 默认设为游戏主题
        category: '游戏主题',
        description: theme.description || '',
        baseThemeKey: 'default',
        styleOverrides: {},
        assetOverrides: {},
      }));
      
      console.log('[CreatorCenter] 官方主题加载成功:', officialThemes.value.length);
    } else {
      console.warn('[CreatorCenter] 官方主题加载失败:', response.message);
      loadDefaultOfficialThemes(); // 回退到默认主题
    }
  } catch (error) {
    console.error('[CreatorCenter] 加载官方主题出错:', error);
    loadDefaultOfficialThemes(); // 出错时使用默认主题
  } finally {
    loadingOfficialThemes.value = false;
  }
}
```

### 4. 在 onMounted 中调用
在组件挂载时自动加载官方主题:

```typescript
onMounted(() => {
  loadMyThemes();
  loadCreatorData();
  loadBaseThemes();
  loadThemes();
  loadOfficialThemes(); // 新增：从后台加载官方主题
});
```

## 需要完成的后续工作

### 1. 删除硬编码的主题数据

需要从文件中删除所有硬编码的官方主题数据 (大约在第 905-1100 行):

```typescript
// 删除以下内容:
[
  { 
    id: 'plane-shooter', 
    name: '飞机大战', 
    type: 'game',
    // ... 所有硬编码的主题数据
  },
  // ... 更多硬编码主题
]
```

**原因**: 这些数据现在从后台 API 动态加载，硬编码数据会导致语法错误。

### 2. 完善回退方案

在 `loadDefaultOfficialThemes()` 函数中添加实际的默认主题数据:

```typescript
function loadDefaultOfficialThemes(): void {
  // 当后台 API 不可用时，使用少量默认主题
  officialThemes.value = [
    {
      id: 'default-1',
      name: '经典贪吃蛇',
      type: 'game',
      category: '游戏主题',
      description: '怀旧经典贪吃蛇主题',
      baseThemeKey: 'default',
    },
    // ... 可以添加 2-3 个基础主题
  ];
}
```

### 3. 添加加载状态 UI

在模板中添加加载状态的显示:

```vue
<div v-if="loadingOfficialThemes" class="loading-state">
  <div class="loading-spinner"></div>
  <p>正在加载官方主题...</p>
</div>

<div v-else-if="officialThemes.length === 0" class="empty-state">
  <p>暂无官方主题</p>
</div>

<div v-else>
  <!-- 正常显示主题列表 -->
</div>
```

## API 接口说明

### 请求
```
GET /api/theme/list?status=on_sale
```

### 响应示例
```json
{
  "success": true,
  "data": [
    {
      "id": "123",
      "key": "snake-theme-001",
      "name": "经典贪吃蛇",
      "author": "官方设计师",
      "price": 0,
      "description": "怀旧经典主题",
      "thumbnail": "/images/themes/snake-thumb.png",
      "downloadCount": 1000,
      "rating": 4.8,
      "status": "on_sale",
      "createdAt": 1710000000000
    }
  ]
}
```

## 测试验证

1. **启动后端服务**
   ```bash
   cd kids-game-backend
   mvn spring-boot:run
   ```

2. **启动前端服务**
   ```bash
   cd kids-game-frontend
   npm run dev
   ```

3. **访问创作者中心**
   - 打开浏览器访问：`http://localhost:5173/creator-center`
   - 切换到"官方主题"标签页
   - 检查控制台日志，应该看到 `[CreatorCenter] 官方主题加载成功:X`

4. **验证数据源**
   - 打开浏览器开发者工具
   - 查看 Network 面板，应该有 `GET /api/theme/list?status=on_sale` 请求
   - 检查返回的数据是否正确

## 注意事项

1. **后端需要有在售主题数据**
   - 确保数据库 `theme_info` 表中有 `status='on_sale'` 的主题
   - 可以使用之前创建的迁移脚本初始化示例数据

2. **CORS 配置**
   - 确保后端允许前端的跨域请求
   - 检查 `application.yml` 中的 CORS 配置

3. **权限验证**
   - 某些主题 API 可能需要登录态
   - 确保 token 正确传递

## 相关文件

- `kids-game-frontend/src/modules/creator-center/index.vue` - 主要修改文件
- `kids-game-frontend/src/services/themeApi.ts` - API 服务
- `kids-game-frontend/src/core/theme/ThemeManager.ts` - 类型定义
- `kids-game-backend/kids-game-service/src/main/java/com/kidgame/service/impl/ThemeServiceImpl.java` - 后端实现

## 下一步计划

- [ ] 删除所有硬编码的官方主题数据
- [ ] 实现 `loadDefaultOfficialThemes()` 的具体逻辑
- [ ] 添加加载状态和空状态 UI
- [ ] 测试完整的加载流程
- [ ] 优化主题分类 (游戏主题 vs 应用主题)
