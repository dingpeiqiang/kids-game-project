# 原生 fetch() 清理计划

## 📊 当前状态

### 发现的原生 fetch 使用（11 处）

| 文件 | 行号 | 用途 | 优先级 |
|------|------|------|--------|
| `creator-center/index.vue` | 266 | 加载游戏列表 | 🔴 **高** - 需统一错误处理 |
| `game/LocalBattleLogin.vue` | 186 | 用户登录 | 🔴 **高** - 涉及认证 |
| `themeTemplateLoader.ts` | 57, 63, 214, 222 | 加载主题模板 | 🔴 **高** - 工具函数 |
| `GameThemeLoader.ts` | 64, 198 | 游戏主题加载 | 🔴 **高** - 核心功能 |
| `ThemeManager.ts` | 113 | 主题管理 | 🟡 中 - 基础服务 |
| `docs/03-development/index.md` | 371 | 文档示例 | 🟢 低 - 仅文档 |

---

## 🎯 修复策略

### 方案 A：使用统一 API 服务（推荐）
```typescript
// ✅ 推荐方式
import { gameApi } from '@/services';

const games = await gameApi.getList();
```

### 方案 B：继承 BaseApiService
```typescript
// ✅ 适用于新服务
class CustomService extends BaseApiService {
  async getData() {
    return this.get('/api/custom/data');
  }
}
```

### 方案 C：添加 Token 和错误处理（临时方案）
```typescript
// ⚠️ 仅在无法重构时使用
const token = localStorage.getItem('token');
const response = await fetch(url, {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

## 📝 修复清单

### P0 - 立即修复（核心功能）
- [ ] `creator-center/index.vue:266` - 加载游戏列表
- [ ] `game/LocalBattleLogin.vue:186` - 用户登录
- [ ] `themeTemplateLoader.ts:57,63` - 主题模板加载
- [ ] `GameThemeLoader.ts:64,198` - 游戏主题检查

### P1 - 近期修复（重要功能）
- [ ] `ThemeManager.ts:113` - 主题管理基础服务
- [ ] `themeTemplateLoader.ts:214,222` - 游戏列表备用加载

### P2 - 文档更新（非紧急）
- [ ] `docs/03-development/index.md:371` - 更新文档示例

---

## 🔧 修复步骤

### 1. creator-center/index.vue
**位置**: Line 266
**当前代码**:
```typescript
const response = await fetch('/api/game/list');
const result = await response.json();
```

**修复后**:
```typescript
import { gameApi } from '@/services';

const result = await gameApi.getList();
```

### 2. LocalBattleLogin.vue
**位置**: Line 186
**当前代码**:
```typescript
const response = await fetch(`${API_URL}/api/user/login`, {
  method: 'POST',
  body: JSON.stringify(credentials)
});
```

**修复后**:
```typescript
import { kidApi } from '@/services';

const result = await kidApi.login(credentials);
```

### 3. themeTemplateLoader.ts
**位置**: Lines 57, 63, 214, 222
**策略**: 创建统一的模板加载服务

### 4. GameThemeLoader.ts
**位置**: Lines 64, 198
**策略**: 使用 gameApi 和 themeApi

---

## 📊 预期效果

| 指标 | 修复前 | 修复后 |
|------|--------|--------|
| **原生 fetch 使用** | 11 处 | 0 处（除文档外） |
| **Token 管理** | ❌ 手动处理 | ✅ 统一拦截器 |
| **错误处理** | ❌ 各自为政 | ✅ 统一规范 |
| **代码复用** | ❌ 重复代码 | ✅ 服务化 |
| **可维护性** | ⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 🧪 验证方法

### 自动化测试
```bash
# 检查是否还有原生 fetch
grep -r "await fetch(" kids-game-frontend/src --include="*.ts" --include="*.vue" | grep -v ".md"
```

### 功能测试
1. ✅ 创作者中心 - 游戏列表加载
2. ✅ 登录功能 - 本地对战登录
3. ✅ 主题 DIY - 模板加载
4. ✅ 游戏主题 - 动态加载

---

**创建时间**: 2026-03-18  
**执行者**: AI Coding Team  
**预计工时**: 2-3 小时
