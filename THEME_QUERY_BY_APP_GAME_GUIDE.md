# 主题查询功能：支持按应用或游戏查询

## 功能概述

已完成主题查询功能的增强，支持按以下两种类型查询主题：

1. **应用主题** (`applicableScope = 'all'`) - 适用于所有游戏/应用的通用主题
2. **游戏主题** (`applicableScope = 'specific'`) - 仅适用于特定游戏的专用主题

## 后端API改动

### 1. ThemeService 接口
```java
// 新增参数：applicableScope, gameId, gameCode
Page<ThemeInfo> listThemes(String applicableScope, Long gameId, String gameCode, String status, Integer page, Integer pageSize);
```

### 2. ThemeController API
- **接口**：`GET /api/theme/list`
- **参数**：
  - `applicableScope` (可选)：`all` - 应用主题，`specific` - 游戏主题
  - `gameId` (可选)：游戏ID（仅当`applicableScope=specific`时有效）
  - `gameCode` (可选)：游戏代码（仅当`applicableScope=specific`时有效）
  - `status` (可选)：状态筛选 `on_sale`/`offline`/`pending`
  - `page`：页码，默认1
  - `pageSize`：每页大小，默认20

### 3. 查询逻辑
- `applicableScope='all'`：查询`theme_info`表中`applicable_scope='all'`的主题
- `applicableScope='specific'`：查询`theme_info`表中`applicable_scope='specific'`的主题
  - 如果指定了`gameId`或`gameCode`，通过`theme_game_relation`表关联查询
  - 如果未指定游戏，返回所有游戏专用主题

## 前端改动

### 1. ThemeManager 新增方法
```typescript
// 按应用范围查询主题
getThemesByScope(params: ThemeListParams): Promise<ThemeConfig[]>

// 获取应用主题
getApplicationThemes(status?: string): Promise<ThemeConfig[]>

// 获取游戏主题
getGameThemes(gameId?: number, gameCode?: string, status?: string): Promise<ThemeConfig[]>
```

### 2. 创建者中心筛选器
在创建者中心添加了主题筛选功能：

**特性**：
- 应用主题/游戏主题切换按钮
- 游戏选择器（选择游戏主题时显示）
- 实时统计信息显示
- 自动重新加载数据

**使用方式**：
1. 点击"应用主题"按钮，查看所有通用主题
2. 点击"游戏主题"按钮，选择具体的游戏
3. 系统自动筛选并显示对应主题

## 数据库结构

### 1. theme_info 表
- `applicable_scope` 字段：`all`（应用主题）或 `specific`（游戏主题）
- 主题类型由该字段决定

### 2. theme_game_relation 表
- 存储游戏专用主题与游戏的关联关系
- 字段：`theme_id`, `game_id`, `game_code`, `is_default`, `sort_order`

## 使用示例

### 1. 前端调用示例
```typescript
// 获取所有应用主题
const appThemes = await themeManager.getApplicationThemes('on_sale');

// 获取特定游戏的游戏主题
const gameThemes = await themeManager.getGameThemes(1, 'plane-shooter', 'on_sale');

// 使用通用查询
const themes = await themeManager.getThemesByScope({
  applicableScope: 'specific',
  gameId: 2,
  gameCode: 'snake-vue3',
  status: 'on_sale',
  page: 1,
  pageSize: 20
});
```

### 2. API调用示例
```bash
# 查询所有应用主题
GET /api/theme/list?applicableScope=all&status=on_sale&page=1&pageSize=20

# 查询飞机大战的游戏主题
GET /api/theme/list?applicableScope=specific&gameCode=plane-shooter&status=on_sale

# 查询游戏ID为1的游戏主题
GET /api/theme/list?applicableScope=specific&gameId=1&status=on_sale
```

## 创建者中心界面说明

### 筛选器组件
1. **类型切换**：
   - 📱 应用主题：显示适用于所有应用的通用主题
   - 🎮 游戏主题：显示特定游戏的专用主题

2. **游戏选择**：
   - 仅当选择"游戏主题"时显示
   - 列出所有可用游戏（飞机大战、贪吃蛇大冒险、超级染色体、算术大战）
   - 点击游戏名称筛选该游戏的专用主题

3. **统计信息**：
   - 显示当前筛选条件下的主题数量
   - 显示当前选择的主题类型
   - 显示当前选择的游戏（如果选择游戏主题）

## 测试建议

### 后端测试
1. 重启后端服务：`mvn clean install -DskipTests`
2. 测试API接口：
   - `/api/theme/list?applicableScope=all`
   - `/api/theme/list?applicableScope=specific&gameCode=plane-shooter`
   - `/api/theme/list?applicableScope=specific&gameId=1`

### 前端测试
1. 清理缓存并重启：
   ```bash
   npm run dev
   ```
2. 访问创建者中心：`/creator-center`
3. 测试筛选功能：
   - 点击"应用主题"查看通用主题
   - 点击"游戏主题"并选择不同游戏
   - 验证主题列表是否正确筛选

## 注意事项

1. **向后兼容**：原有`listThemes`接口已更新，调用时需注意参数变化
2. **游戏ID与游戏代码**：建议优先使用`gameCode`进行查询，更稳定
3. **状态筛选**：默认只显示`on_sale`状态的已上架主题
4. **分页支持**：所有查询都支持分页，避免大数据量问题

## 扩展建议

1. **搜索功能**：可在筛选器基础上添加关键词搜索
2. **主题预览**：添加主题预览功能，查看主题效果
3. **批量操作**：支持批量管理主题（上架/下架/删除）
4. **主题分类**：可进一步对主题进行分类（颜色、风格等）

## 相关文件

1. **后端**：
   - `ThemeService.java` - 接口定义
   - `ThemeServiceImpl.java` - 业务实现
   - `ThemeController.java` - API控制器

2. **前端**：
   - `ThemeManager.ts` - 主题管理器
   - `themeApi.ts` - API服务
   - `creator-center/index.vue` - 创建者中心主页面

3. **数据库**：
   - `theme_info` - 主题信息表
   - `theme_game_relation` - 主题-游戏关联表