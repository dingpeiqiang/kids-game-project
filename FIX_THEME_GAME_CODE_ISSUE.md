# 修复贪吃蛇和植物大战僵尸主题查询不到的问题

## 问题描述

在创作者中心选择"游戏主题"时，选择贪吃蛇或植物大战僵尸，无法查询到主题。

## 问题原因

1. **游戏代码大小写不一致**
   - 前端代码中使用：`snake-vue3`（小写）
   - 数据库中使用：`SNAKE_VUE3`（大写）
   - 导致API查询时参数不匹配

2. **植物大战僵尸游戏不存在**
   - 数据库中没有植物大战僵尸游戏记录
   - 主题初始化脚本中引用了不存在的游戏

3. **主题-游戏关联表数据不一致**
   - `theme_game_relation` 表中的 `game_code` 字段没有同步更新
   - 导致关联关系失效

## 解决方案

### 第一步：修复游戏代码

执行脚本：`fix-theme-game-code.bat`

这个脚本会：
1. 更新贪吃蛇游戏的 `game_code` 为 `snake-vue3`（小写）
2. 添加植物大战僵尸游戏（`plants-vs-zombie`）
3. 更新 `theme_game_relation` 表中的 `game_code`

### 第二步：初始化主题数据

执行脚本：`init-missing-game-themes.bat`

这个脚本会：
1. 创建贪吃蛇专属主题：
   - 贪吃蛇 - 清新绿（100游戏币）
   - 贪吃蛇 - 经典复古（免费）

2. 创建植物大战僵尸专属主题：
   - 植物大战僵尸 - 阳光活力（150游戏币）
   - 植物大战僵尸 - 月夜幽深（120游戏币）

3. 建立主题-游戏关联关系

## 执行步骤

```bash
# 1. 修复游戏代码
fix-theme-game-code.bat

# 2. 初始化主题数据
init-missing-game-themes.bat

# 3. 重启后端服务
# (进入后端目录，重启Spring Boot应用)

# 4. 刷新前端页面
# (清除浏览器缓存并刷新)
```

## 验证修复

### 1. 检查游戏列表

```sql
SELECT game_id, game_code, game_name, game_url, status
FROM t_game
WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');
```

应该看到：
```
game_id | game_code         | game_name        | game_url             | status
--------|-------------------|------------------|----------------------|-------
    2   | snake-vue3        | 贪吃蛇大冒险     | http://localhost:3003|   1
    5   | plants-vs-zombie  | 植物大战僵尸     | http://localhost:3004|   1
```

### 2. 检查主题列表

```sql
SELECT theme_id, theme_name, applicable_scope, status, description
FROM theme_info
WHERE theme_name LIKE '%贪吃蛇%' OR theme_name LIKE '%植物%'
ORDER BY theme_id;
```

应该看到4个主题：
- 贪吃蛇 - 清新绿
- 贪吃蛇 - 经典复古
- 植物大战僵尸 - 阳光活力
- 植物大战僵尸 - 月夜幽深

### 3. 检查主题-游戏关联

```sql
SELECT
    ti.theme_id,
    ti.theme_name,
    tgr.game_code,
    g.game_name,
    tgr.is_default
FROM theme_info ti
INNER JOIN theme_game_relation tgr ON ti.theme_id = tgr.theme_id
INNER JOIN t_game g ON tgr.game_id = g.game_id
WHERE tgr.game_code IN ('snake-vue3', 'plants-vs-zombie')
ORDER BY ti.theme_id, g.game_name;
```

应该看到8条关联记录（4个主题 × 2个游戏）

### 4. 测试API接口

```bash
# 测试游戏列表API
curl http://localhost:8080/api/game/list

# 测试贪吃蛇主题列表
curl http://localhost:8080/api/theme/list?applicableScope=specific&gameCode=snake-vue3

# 测试植物大战僵尸主题列表
curl http://localhost:8080/api/theme/list?applicableScope=specific&gameCode=plants-vs-zombie
```

### 5. 前端验证

1. 访问创作者中心：`http://localhost:5173/creator-center`
2. 选择"游戏主题"范围
3. 选择"贪吃蛇大冒险"或"植物大战僵尸"
4. 查看主题列表，应该能看到对应的主题

## 技术细节

### 游戏代码规范

所有游戏的 `game_code` 应该统一使用小写+连字符的格式：
- ✅ `snake-vue3`
- ✅ `plants-vs-zombie`
- ✅ `plane-shooter`
- ❌ `SNAKE_VUE3` (大写)
- ❌ `PLANTS_VS_ZOMBIE` (大写)

### 主题配置格式

主题配置使用JSON格式，存储在 `config_json` 字段：

```json
{
  "version": "1.0",
  "colorScheme": "green",
  "colors": {
    "primary": "#42b983",
    "secondary": "#35495e",
    "background": "#f0f9f0",
    "snakeHead": "#42b983",
    "snakeBody": "#50c878",
    "food": "#ff6b6b"
  }
}
```

### API查询参数

查询游戏主题时的参数：
- `applicableScope=specific` - 指定为游戏主题
- `gameCode=snake-vue3` - 游戏代码（必须小写）
- `status=on_sale` - 上架状态（可选）

## 常见问题

### Q1: 执行脚本后仍然查询不到主题

**A:** 检查以下几点：
1. 后端服务是否重启
2. 浏览器缓存是否清除（Ctrl+Shift+Delete）
3. 检查浏览器控制台是否有错误
4. 确认API返回的数据格式是否正确

### Q2: 主题列表显示为空

**A:** 检查SQL脚本是否执行成功：
```sql
SELECT COUNT(*) as theme_count
FROM theme_game_relation
WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');
```

如果为0，说明关联关系没有建立，需要重新执行初始化脚本。

### Q3: 游戏代码不一致

**A:** 确保前后端游戏代码完全一致：
- 前端：`gameCode`
- 后端：`t_game.game_code`
- 关联表：`theme_game_relation.game_code`

## 后续优化建议

1. **添加游戏代码验证**
   - 在上传主题时验证 `game_code` 是否存在
   - 在查询主题时验证 `game_code` 是否有效

2. **统一游戏代码管理**
   - 使用枚举或常量管理游戏代码
   - 在配置文件中集中定义

3. **添加数据校验**
   - 定期检查数据一致性
   - 自动修复不一致的数据

4. **完善错误提示**
   - 当游戏代码不存在时，返回明确的错误信息
   - 在前端显示友好的错误提示

## 相关文件

- `fix-theme-game-code.sql` - 修复游戏代码的SQL脚本
- `fix-theme-game-code.bat` - 修复游戏代码的批处理脚本
- `init-missing-game-themes.sql` - 初始化主题数据的SQL脚本
- `init-missing-game-themes.bat` - 初始化主题数据的批处理脚本
- `kids-game-frontend/src/modules/creator-center/index.vue` - 创作者中心页面

## 总结

通过修复游戏代码的大小写不一致问题，并添加缺失的游戏和主题数据，现在可以正常查询贪吃蛇和植物大战僵尸的主题了。

执行这两个批处理脚本后，重启后端服务，刷新前端页面即可看到效果。
