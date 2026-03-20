# ThemeInfo 添加 isDefault 字段修复说明

## 📋 问题描述

之前 `ThemeInfo` 实体类中没有定义 `isDefault` 字段，但前端代码和 DTO 中都在使用该字段来判断是否为默认主题。

## ✅ 解决方案

在 `ThemeInfo` 实体类中直接添加 `isDefault` 字段，简化设计（不使用关系表）。

---

## 🔧 修改内容

### 1. 后端实体类修改

#### `ThemeInfo.java` - 添加字段

**文件位置**: `kids-game-backend/kids-game-dao/src/main/java/com/kidgame/dao/entity/ThemeInfo.java`

```java
/**
 * 是否为默认主题：0-否，1-是
 */
@TableField("is_default")
private Boolean isDefault;
```

**修改说明**:
- 在 `configJson` 字段后添加 `isDefault` 字段
- 使用 `@TableField("is_default")` 映射数据库列
- 类型为 `Boolean`，支持 null 值处理

---

### 2. DTO 修改

#### `ThemeResponseDTO.java` - 填充字段

**文件位置**: `kids-game-backend/kids-game-dao/src/main/java/com/kidgame/dao/dto/ThemeResponseDTO.java`

```java
public static ThemeResponseDTO from(ThemeInfo theme) {
    ThemeResponseDTO dto = new ThemeResponseDTO();
    // ... 其他字段设置 ...
    dto.setConfigJson(theme.getConfigJson());
    dto.setIsDefault(theme.getIsDefault() != null && theme.getIsDefault()); // ← 新增
    return dto;
}
```

**修改说明**:
- 在 `from()` 方法中添加 `isDefault` 字段的填充逻辑
- 使用 `theme.getIsDefault() != null && theme.getIsDefault()` 确保 null 安全

---

### 3. 数据库迁移脚本

#### `add-is-default-to-theme-info.sql`

**文件位置**: `kids-game-backend/add-is-default-to-theme-info.sql`

```sql
-- 为 theme_info 表添加 is_default 字段
ALTER TABLE `theme_info` 
ADD COLUMN IF NOT EXISTS `is_default` TINYINT DEFAULT 0 COMMENT '是否为默认主题：0-否，1-是' AFTER `config_json`;

-- 添加索引以优化查询
ALTER TABLE `theme_info` 
ADD INDEX IF NOT EXISTS `idx_is_default` (`is_default`);

-- 如果没有默认主题，将第一个主题设为默认
UPDATE theme_info 
SET is_default = 1 
WHERE theme_id = (
    SELECT MIN(theme_id) 
    FROM (
        SELECT theme_id 
        FROM theme_info 
        WHERE applicable_scope = 'all' 
        AND status = 'on_sale'
    ) AS temp
);
```

**执行方式**:
```bash
# 在 MySQL 中执行
mysql -u your_username -p your_database < kids-game-backend/add-is-default-to-theme-info.sql
```

---

## 📊 数据模型对比

### ❌ 之前的设计（使用关系表）

```
theme_info          theme_game_relation
├── theme_id        ├── relation_id
├── theme_name      ├── theme_id
└── config_json     ├── game_id
                    ├── is_default  ← 在关系表中
                    └── ...
```

**问题**: 需要 JOIN 查询才能获取 `isDefault`

---

### ✅ 新的设计（直接在实体中）

```
theme_info          
├── theme_id        
├── theme_name      
├── config_json     
├── is_default  ← 直接在主题表中
└── ...
```

**优势**:
- ✅ 简化查询，不需要 JOIN
- ✅ 一个主题只有一个默认状态（全局默认）
- ✅ 更适合应用场景（应用主题 + 游戏主题统一管理）

---

## 🎯 使用示例

### Controller 层

```java
@GetMapping("/list")
public Result<Page<ThemeResponseDTO>> listThemes(
    @RequestParam String ownerType,
    @RequestParam Long ownerId,
    @RequestParam(defaultValue = "1") Integer page,
    @RequestParam(defaultValue = "10") Integer pageSize
) {
    Page<ThemeInfo> themePage = themeService.listThemes(ownerType, ownerId, null, page, pageSize);
    
    // 转换为 DTO（自动包含 isDefault）
    List<ThemeResponseDTO> dtoList = themePage.getRecords().stream()
        .map(ThemeResponseDTO::from)
        .collect(Collectors.toList());
    
    Page<ThemeResponseDTO> resultPage = new Page<>(page, pageSize);
    resultPage.setRecords(dtoList);
    resultPage.setTotal(themePage.getTotal());
    
    return Result.success(resultPage);
}
```

### Service 层

```java
// 设置默认主题
@Transactional(rollbackFor = Exception.class)
public void setDefaultTheme(Long themeId, Long gameId) {
    // 1. 取消所有主题的默认状态
    LambdaUpdateWrapper<ThemeInfo> wrapper = new LambdaUpdateWrapper<>();
    wrapper.eq(ThemeInfo::getOwnerId, gameId)
           .set(ThemeInfo::getIsDefault, false);
    themeInfoMapper.update(null, wrapper);
    
    // 2. 设置新主题的默认状态
    ThemeInfo theme = themeInfoMapper.selectById(themeId);
    if (theme != null) {
        theme.setIsDefault(true);
        themeInfoMapper.updateById(theme);
    }
}
```

### 前端使用

```typescript
// ThemeSelector.vue
<div v-if="!theme.isDefault" @click="setAsDefault(theme)">
  ⭐ 设为默认
</div>

<div v-else class="default-badge">
  ⭐ 默认
</div>
```

---

## ✅ 验证步骤

### 1. 检查数据库表结构

```sql
DESCRIBE theme_info;
```

应该看到：
```
+---------------+--------------+------+-----+-------------------+
| Field         | Type         | Null | Key | Default           |
+---------------+--------------+------+-----+-------------------+
| theme_id      | bigint       | NO   | PRI | NULL              |
| author_id     | bigint       | NO   | MUL | NULL              |
| theme_name    | varchar(100) | NO   |     | NULL              |
| ...           | ...          | ...  | ... | ...               |
| config_json   | json         | NO   |     | NULL              |
| is_default    | tinyint      | YES  | MUL | 0                 |
| created_at    | datetime     | YES  |     | CURRENT_TIMESTAMP |
| updated_at    | datetime     | YES  |     | CURRENT_TIMESTAMP |
+---------------+--------------+------+-----+-------------------+
```

### 2. 查询测试

```sql
SELECT 
    theme_id,
    theme_name,
    applicable_scope,
    is_default,
    status
FROM theme_info
ORDER BY is_default DESC, theme_id;
```

### 3. API 测试

```bash
# 调用主题列表接口
curl http://localhost:8080/api/theme/list?ownerType=GAME&ownerId=1&page=1&pageSize=10

# 检查返回的 JSON 中是否包含 isDefault 字段
{
  "success": true,
  "data": {
    "records": [
      {
        "themeId": 1,
        "themeName": "清新绿",
        "isDefault": true,  ← 应该有这个字段
        ...
      }
    ]
  }
}
```

### 4. 前端测试

1. 打开主题管理页面
2. 查看主题列表中是否正确显示"默认"标识
3. 点击"设为默认"按钮，检查是否正常工作

---

## 🔄 兼容性说明

### 与关系表的兼容

如果你之前使用了 `theme_game_relation` 表中的 `is_default` 字段，需要注意：

**方案 A**: 完全迁移到新设计
- 删除 `theme_game_relation` 表（如果不再需要多对多关系）
- 使用 `theme_info.is_default` 作为唯一的默认标识

**方案 B**: 保留关系表（支持多游戏默认主题）
- 保留 `theme_game_relation.is_default` 用于游戏专属默认
- 新增 `theme_info.is_default` 用于全局默认/应用主题默认

本实现采用**方案 A**（简化设计），适用于：
- ✅ 应用主题（首页、个人中心等）
- ✅ 游戏主题（每个游戏一个默认主题）

---

## 📝 注意事项

1. **数据库字段类型**: 使用 `TINYINT(1)` 或 `BOOLEAN`
2. **默认值**: 设置为 `0`（false）
3. **索引**: 添加 `idx_is_default` 索引优化查询性能
4. **null 值处理**: Java 代码中使用 `theme.getIsDefault() != null && theme.getIsDefault()` 避免 NPE

---

## 🚀 后续优化建议

1. **唯一约束**: 如果需要确保每个游戏只有一个默认主题，可以添加部分唯一索引
2. **触发器**: 使用数据库触发器自动维护默认状态
3. **缓存**: 将默认主题缓存到 Redis，减少数据库查询

---

## 📚 相关文件

- `kids-game-backend/kids-game-dao/src/main/java/com/kidgame/dao/entity/ThemeInfo.java`
- `kids-game-backend/kids-game-dao/src/main/java/com/kidgame/dao/dto/ThemeResponseDTO.java`
- `kids-game-backend/add-is-default-to-theme-info.sql`

---

**完成时间**: 2026-03-17  
**影响范围**: 主题系统相关的所有模块  
**测试状态**: 待验证
