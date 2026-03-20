# 主题系统重构 - 游戏和应用分离

## 重构目标

将游戏 (Game) 和应用 (Application) 独立定义，主题唯一归属于一个所有者 (游戏或应用),简化系统架构。

## 设计原则

1. **独立性**: 游戏和应用是两个独立的实体，各自有自己的主题
2. **唯一归属**: 每个主题只能属于一个所有者 (一个游戏或一个应用)
3. **简化架构**: 通过在 `theme_info` 表上新增字段，移除复杂的关系表

## 核心变更

### 1. 数据库层面

#### 新增字段

在 `theme_info` 表中新增两个字段:

```sql
-- 所有者类型：GAME-游戏，APPLICATION-应用
ALTER TABLE theme_info 
ADD COLUMN owner_type VARCHAR(20) NOT NULL DEFAULT 'APPLICATION' COMMENT '所有者类型：GAME-游戏，APPLICATION-应用';

-- 所有者 ID:关联 t_game.game_id 或未来的 t_application.app_id
ALTER TABLE theme_info 
ADD COLUMN owner_id BIGINT COMMENT '所有者 ID(游戏 ID 或应用 ID)';
```

#### 索引优化

```sql
ALTER TABLE theme_info 
ADD INDEX idx_owner_type (owner_type);

ALTER TABLE theme_info 
ADD INDEX idx_owner_id (owner_id);
```

#### 数据迁移策略

```sql
-- 通用主题 (applicable_scope = 'all') -> APPLICATION 类型
UPDATE theme_info 
SET owner_type = 'APPLICATION', owner_id = NULL 
WHERE applicable_scope = 'all';

-- 游戏主题 (applicable_scope = 'specific') -> GAME 类型
-- 从 theme_game_relation 表中取第一个关联的游戏
UPDATE theme_info ti
INNER JOIN (
    SELECT theme_id, MIN(game_id) as game_id
    FROM theme_game_relation
    GROUP BY theme_id
) tgr ON ti.theme_id = tgr.theme_id
SET ti.owner_type = 'GAME', ti.owner_id = tgr.game_id
WHERE ti.applicable_scope = 'specific';
```

### 2. Java 实体层

#### ThemeInfo 实体更新

```java
@Data
@TableName("theme_info")
public class ThemeInfo implements Serializable {
    
    // ... 其他字段 ...
    
    /**
     * 所有者类型：GAME-游戏，APPLICATION-应用
     */
    @TableField("owner_type")
    private String ownerType;
    
    /**
     * 所有者 ID(游戏 ID 或应用 ID)
     */
    @TableField("owner_id")
    private Long ownerId;
}
```

### 3. DTO 层

#### ThemeUploadDTO 更新

```java
@Data
public class ThemeUploadDTO {
    
    // ... 其他字段 ...
    
    /**
     * 所有者类型：GAME-游戏，APPLICATION-应用
     */
    private String ownerType;
    
    /**
     * 所有者 ID(游戏 ID 或应用 ID)
     */
    private Long ownerId;
}
```

**移除的字段**:
- `applicableScope` - 适用范围
- `gameId` - 游戏 ID
- `gameCode` - 游戏代码  
- `isDefault` - 是否为默认主题

### 4. Service 层

#### ThemeService 接口变更

**方法签名变更**:
```java
// 旧方法
Page<ThemeInfo> listThemes(String applicableScope, Long gameId, String gameCode, String status, Integer page, Integer pageSize);

// 新方法
Page<ThemeInfo> listThemes(String ownerType, Long ownerId, String status, Integer page, Integer pageSize);
```

**移除的方法**:
```java
// 这些方法不再需要，因为关系表已被移除
boolean addGameTheme(Long themeId, Long gameId, String gameCode, Boolean isDefault);
boolean removeGameTheme(Long themeId, Long gameId);
boolean setGameDefaultTheme(Long gameId, Long themeId);
List<Long> getThemeGames(Long themeId);
```

**新增的方法**:
```java
/**
 * 获取主题所有者 ID
 */
Long getThemeOwner(Long themeId);
```

#### ThemeServiceImpl 实现变更

**查询逻辑简化**:
```java
@Override
public Page<ThemeInfo> listThemes(String ownerType, Long ownerId, String status, Integer page, Integer pageSize) {
    LambdaQueryWrapper<ThemeInfo> wrapper = new LambdaQueryWrapper<>();
    
    // 根据所有者类型筛选
    if ("APPLICATION".equals(ownerType)) {
        wrapper.eq(ThemeInfo::getOwnerType, "APPLICATION");
    } else if ("GAME".equals(ownerType)) {
        wrapper.eq(ThemeInfo::getOwnerType, "GAME");
        // 如果有指定游戏 ID，进一步筛选
        if (ownerId != null) {
            wrapper.eq(ThemeInfo::getOwnerId, ownerId);
        }
    }
    
    // 状态筛选
    if (status != null && !status.isEmpty()) {
        wrapper.eq(ThemeInfo::getStatus, status);
    }
    
    wrapper.orderByDesc(ThemeInfo::getCreatedAt);
    
    return themeInfoMapper.selectPage(new Page<>(page, pageSize), wrapper);
}
```

**上传主题逻辑**:
```java
@Override
public ThemeInfo uploadTheme(Long authorId, ThemeUploadDTO themeData) {
    ThemeInfo theme = new ThemeInfo();
    theme.setAuthorId(authorId);
    theme.setThemeName(themeData.getThemeName());
    theme.setOwnerType(themeData.getOwnerType());  // 新增
    theme.setOwnerId(themeData.getOwnerId());      // 新增
    // ... 其他属性设置 ...
    
    themeInfoMapper.insert(theme);
    return theme;
}
```

### 5. 前端影响

#### TypeScript 类型定义

需要更新前端的类型定义:

```typescript
// 旧的类型定义
export interface ThemeInfo {
  themeId: number;
  applicableScope: 'all' | 'specific';
  // ... 其他字段 ...
}

// 新的类型定义
export interface ThemeInfo {
  themeId: number;
  ownerType: 'GAME' | 'APPLICATION';
  ownerId: number | null;
  // ... 其他字段 ...
}
```

#### API 调用调整

```typescript
// 旧的 API 调用
themeService.listThemes('specific', gameId, gameCode, 'on_sale', 1, 10);

// 新的 API 调用
themeService.listThemes('GAME', gameId, 'on_sale', 1, 10);
```

## 优势分析

### 1. 架构简化
- ✅ 移除了复杂的多对多关系表
- ✅ 减少了数据库 JOIN 操作
- ✅ 查询性能提升

### 2. 语义清晰
- ✅ 主题归属关系更明确
- ✅ 一对一关系更符合业务实际
- ✅ 易于理解和维护

### 3. 扩展性强
- ✅ 未来可以轻松支持应用主题
- ✅ 为"应用"概念预留了空间
- ✅ 符合单一职责原则

## 注意事项

### 1. 数据迁移
⚠️ **重要**: 在执行迁移前务必备份数据!

```bash
# 备份现有主题数据
mysqldump -u root -p kids_game theme_info > theme_info_backup.sql
mysqldump -u root -p kids_game theme_game_relation > theme_game_relation_backup.sql
```

### 2. 向后兼容
- 建议保留 `applicable_scope` 字段一段时间，以便回滚
- 不要立即删除 `theme_game_relation` 表
- 可以在确认新系统稳定后再清理旧数据

### 3. 前端适配
- 需要更新前端所有使用主题相关 API 的地方
- 重点检查创作者中心、主题商城等模块
- 确保类型定义和 API 调用同步更新

## 执行步骤

### 第一阶段：数据库迁移
1. 执行 DDL 变更，添加 `owner_type` 和 `owner_id` 字段
2. 创建索引
3. 执行数据迁移
4. 验证迁移结果

### 第二阶段：后端代码更新
1. 更新实体类 `ThemeInfo`
2. 更新 DTO `ThemeUploadDTO`
3. 更新 Service 接口和实现
4. 更新 Controller(如有需要)
5. 编译测试

### 第三阶段：前端适配
1. 更新 TypeScript 类型定义
2. 更新 API 调用代码
3. 更新 UI 组件
4. 测试验证

### 第四阶段：清理优化 (可选)
1. 删除旧的 `applicable_scope` 字段
2. 删除 `theme_game_relation` 表
3. 清理相关的 Mapper 和 XML

## 测试验证

### 单元测试
```java
@Test
public void testListGameThemes() {
    // 测试查询游戏的专属主题
    Page<ThemeInfo> themes = themeService.listThemes("GAME", 1L, "on_sale", 1, 10);
    Assert.assertNotNull(themes);
    Assert.assertTrue(themes.getTotal() > 0);
}

@Test
public void testUploadGameTheme() {
    // 测试上传游戏主题
    ThemeUploadDTO uploadDTO = new ThemeUploadDTO();
    uploadDTO.setOwnerType("GAME");
    uploadDTO.setOwnerId(1L);
    // ... 设置其他属性 ...
    
    ThemeInfo theme = themeService.uploadTheme(1L, uploadDTO);
    Assert.assertNotNull(theme);
    Assert.assertEquals("GAME", theme.getOwnerType());
    Assert.assertEquals(1L, theme.getOwnerId().longValue());
}
```

### 集成测试
1. 测试创作者上传游戏主题
2. 测试用户浏览不同游戏的主题
3. 测试应用主题的管理
4. 测试主题购买和下载流程

## 总结

本次重构通过将游戏和应用分离，使主题系统的架构更加清晰和简化。虽然改动较大，但带来的好处是显而易见的:

- ✅ 代码更易维护
- ✅ 性能更好
- ✅ 扩展性更强
- ✅ 符合单一职责原则

建议在测试充分的前提下，分阶段逐步推进，确保系统稳定过渡。
