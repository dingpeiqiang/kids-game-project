# /api/game/start 接口参数修复

## 问题描述

前端调用 `/api/game/start` 接口时，传递的参数名称不正确。

## 问题分析

### 后端期望参数
```java
// GameStartDTO.java
@Data
public class GameStartDTO {
    /**
     * 用户ID（儿童或家长）
     */
    private Long userId;  // ← 字段名是 userId

    /**
     * 游戏ID
     */
    private Long gameId;
}
```

### 前端错误传递
```typescript
// 错误 ❌
async start(kidId: number, gameId: number): Promise<number> {
  return this.post<number>('/api/game/start', { kidId, gameId });
  //                                                    ↑ 错误：应该是 userId
}
```

### 前端正确传递
```typescript
// 正确 ✅
async start(userId: number, gameId: number): Promise<number> {
  return this.post<number>('/api/game/start', { userId, gameId });
  //                                                    ↑ 正确：字段名匹配
}
```

## 修复内容

### 1. 修复 game-api.service.ts

**文件**：`kids-game-frontend/src/services/game-api.service.ts`

```typescript
// 修复前
async start(kidId: number, gameId: number): Promise<number> {
  return this.post<number>('/api/game/start', { kidId, gameId });
}

// 修复后
async start(userId: number, gameId: number): Promise<number> {
  return this.post<number>('/api/game/start', { userId, gameId });
}
```

### 2. 修复 kids-home/index.vue

**文件**：`kids-game-frontend/src/modules/kids-home/index.vue`

```typescript
// 修复前
gameStore.currentSession = {
  sessionId,
  gameId: game.gameId,
  gameCode: game.gameCode,
  gameName: game.gameName,
  userId: userStore.currentUser?.kidId,  // ❌ 错误：currentUser 没有 kidId 字段
  startTime: Date.now(),
  duration: 0,
  score: 0,
  status: 'playing' as const
};

// 修复后
gameStore.currentSession = {
  sessionId,
  gameId: game.gameId,
  gameCode: game.gameCode,
  gameName: game.gameName,
  userId: userStore.currentUser?.id,  // ✅ 正确：使用 id 字段
  startTime: Date.now(),
  duration: 0,
  score: 0,
  status: 'playing' as const
};
```

## UserInfo 接口定义

```typescript
export interface UserInfo {
  id: number;              // ✅ 正确的字段名
  username: string;
  nickname: string;
  avatar?: string;
  grade: string;
  fatiguePoints: number;
  dailyAnswerPoints: number;
  parentId?: number;
  userType?: 'KID' | 'PARENT' | 'ADMIN';
}
```

**注意**：`UserInfo` 接口没有 `kidId` 字段，只有 `id` 字段。

## 调用示例

### 儿童端调用
```typescript
// ✅ 正确
const sessionId = await gameApi.start(userStore.currentUser?.id, game.gameId);
```

### 家长端调用
```typescript
// ✅ 正确
const parentId = userStore.parentUser?.parentId;
const sessionId = await gameApi.start(parentId, game.gameId);
```

## 验证步骤

### 1. 清除缓存
```bash
# 清除前端缓存
cd kids-game-frontend
Remove-Item -Recurse -Force node_modules\.vite, dist
npm run dev
```

### 2. 测试儿童端
1. 以儿童账号登录
2. 点击任意游戏卡片
3. 查看网络请求：
   - 打开浏览器 F12 → Network 标签
   - 找到 `/api/game/start` 请求
   - 查看 Request Payload，应该包含 `{userId: xxx, gameId: xxx}`
4. 确认游戏正常启动

### 3. 测试家长端
1. 以家长账号登录
2. 点击任意游戏卡片
3. 查看网络请求：
   - Request Payload 应该包含 `{userId: xxx, gameId: xxx}`
4. 确认游戏正常启动

## 相关文件

- `kids-game-frontend/src/services/game-api.service.ts` - API 服务
- `kids-game-frontend/src/modules/kids-home/index.vue` - 儿童首页
- `kids-game-frontend/src/modules/parent/index.vue` - 家长首页
- `kids-game-frontend/src/core/store/user.store.ts` - 用户状态管理
- `kids-game-backend/kids-game-service/src/main/java/com/kidgame/service/dto/GameStartDTO.java` - 后端 DTO

## 注意事项

1. **字段名统一**：前端和后端的字段名必须保持一致
2. **类型匹配**：前端传递的类型必须与后端期望的类型匹配
3. **调试技巧**：遇到 401/400 错误时，优先检查请求参数是否正确
4. **文档同步**：修改接口参数时，务必同步更新前后端文档

## 总结

本次修复解决了前后端参数名称不匹配的问题，确保 `/api/game/start` 接口能够正确接收用户ID和游戏ID。
