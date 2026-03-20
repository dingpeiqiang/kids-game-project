# 快速修复：贪吃蛇和植物大战僵尸主题查询不到

## 🎯 问题描述

在创作者中心选择游戏主题时，贪吃蛇和植物大战僵尸查询不到主题。

## 🔍 问题原因

1. **游戏代码大小写不一致**
   - 数据库：`SNAKE_VUE3` ❌
   - 前端：`snake-vue3` ✅

2. **植物大战僵尸游戏不存在**
   - 数据库中没有这个游戏记录

## ✅ 解决方案

### 执行以下2个脚本：

#### 1️⃣ 修复游戏代码
```bash
fix-theme-game-code.bat
```

这个脚本会：
- ✅ 更新贪吃蛇代码为 `snake-vue3`
- ✅ 添加植物大战僵尸游戏 `plants-vs-zombie`
- ✅ 修复主题关联表

#### 2️⃣ 初始化主题数据
```bash
init-missing-game-themes.bat
```

这个脚本会：
- ✅ 创建2个贪吃蛇主题（清新绿、经典复古）
- ✅ 创建2个植物大战僵尸主题（阳光活力、月夜幽深）
- ✅ 建立主题-游戏关联

### 3️⃣ 重启服务
```bash
# 重启后端服务
# 刷新前端页面（清除缓存）
```

## 📊 执行后效果

### 贪吃蛇主题
- 贪吃蛇 - 清新绿（100游戏币）
- 贪吃蛇 - 经典复古（免费）

### 植物大战僵尸主题
- 植物大战僵尸 - 阳光活力（150游戏币）
- 植物大战僵尸 - 月夜幽深（120游戏币）

## 🧪 验证方法

### 方法1：SQL查询
```sql
-- 检查游戏
SELECT * FROM t_game WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');

-- 检查主题
SELECT * FROM theme_info WHERE theme_name LIKE '%贪吃蛇%' OR theme_name LIKE '%植物%';

-- 检查关联
SELECT * FROM theme_game_relation WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');
```

### 方法2：API测试
```bash
# 测试游戏列表
curl http://localhost:8080/api/game/list

# 测试贪吃蛇主题
curl "http://localhost:8080/api/theme/list?applicableScope=specific&gameCode=snake-vue3"

# 测试植物大战僵尸主题
curl "http://localhost:8080/api/theme/list?applicableScope=specific&gameCode=plants-vs-zombie"
```

### 方法3：前端验证
1. 访问：`http://localhost:5173/creator-center`
2. 选择"游戏主题"
3. 选择"贪吃蛇大冒险"或"植物大战僵尸"
4. ✅ 应该能看到对应的主题列表

## 📁 相关文件

- `fix-theme-game-code.bat` - 修复游戏代码
- `init-missing-game-themes.bat` - 初始化主题
- `FIX_THEME_GAME_CODE_ISSUE.md` - 详细说明

## ⚠️ 注意事项

1. 执行脚本前确保MySQL正在运行
2. 需要输入MySQL密码（root用户）
3. 执行完脚本后必须重启后端服务
4. 刷新前端时清除浏览器缓存

## 🎉 完成！

执行完这两个脚本后，就可以在创作者中心正常查询和使用这两个游戏的主题了！
