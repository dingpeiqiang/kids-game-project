# 儿童游戏平台 - 编码规范

本文档定义了儿童游戏平台项目的编码规范，所有开发人员必须遵守。

> 本规范基于阿里巴巴 Java 开发手册和前端开发最佳实践制定。

## 目录

- [通用原则](#通用原则)
- [Java 后端规范](#java-后端规范)
  - [命名规范](#命名规范)
  - [代码结构](#代码结构)
  - [代码质量](#代码质量)
  - [注释规范](#注释规范)
  - [异常处理](#异常处理)
  - [日志规范](#日志规范)
- [TypeScript/JavaScript 前端规范](#typescriptjavascript-前端规范)
  - [命名规范](#命名规范-1)
  - [代码结构](#代码结构-1)
  - [代码质量](#代码质量-1)
  - [注释规范](#注释规范-1)
- [Git 提交规范](#git-提交规范)

---

## 通用原则

### 1. 可读性优先
- 代码应该像散文一样易于阅读
- 避免过于"聪明"但难以理解的代码
- 简单优于复杂，清晰优于巧妙

### 2. DRY 原则 (Don't Repeat Yourself)
- 避免代码重复
- 提取公共逻辑到工具类或基类
- 使用常量替代魔法值

### 3. 单一职责原则
- 每个类/方法只做一件事
- 类的行数不超过 500 行
- 方法的行数不超过 50 行

### 4. KISS 原则 (Keep It Simple, Stupid)
- 保持简单，不要过度设计
- 在满足需求的前提下，选择最简单的方案

---

## Java 后端规范

### 命名规范

#### 1. 包名
- 全部小写，多个单词用 `.` 分隔
- 例：`com.kidgame.service.impl`

#### 2. 类名
- 使用大驼峰命名法 (PascalCase)
- 类名应该是名词
- 接口名可加 `I` 前缀（本项目不使用，直接用接口描述功能）

```java
// ✅ 正确
public class UserServiceImpl {}
public interface UserService {}

// ❌ 错误
public class userServiceImpl {}
public class userservice {}
```

#### 3. 方法名
- 使用小驼峰命名法 (camelCase)
- 方法名应该是动词或动词短语
- 布尔类型返回值的方法以 `is`、`has`、`can` 开头

```java
// ✅ 正确
public void updateUser() {}
public boolean isValid() {}
public boolean hasPermission() {}

// ❌ 错误
public void UpdateUser() {}
public boolean Valid() {}
```

#### 4. 变量名
- 使用小驼峰命名法 (camelCase)
- 避免单字符变量名（循环变量除外）
- 常量使用全大写，单词间用 `_` 分隔

```java
// ✅ 正确
private String userName;
private static final int MAX_RETRY_COUNT = 3;

// ❌ 错误
private String username;
private static final int maxRetryCount = 3;
```

### 代码结构

#### 1. 类结构顺序
```java
1. 包声明
2. 导入语句（按字母顺序排序）
3. 类文档注释
4. 类声明
5. 静态常量
6. 静态变量
7. 实例变量
8. 构造方法
9. 公共方法
10. 私有/受保护方法
11. 内部类（如果有）
```

#### 2. 项目包结构
```
com.kidgame
├── common              # 公共模块
│   ├── constant       # 常量定义
│   ├── config         # 配置类
│   ├── exception      # 异常定义
│   ├── handler        # 处理器
│   ├── interceptor    # 拦截器
│   ├── model          # 通用模型
│   └── util           # 工具类
├── dao                # 数据访问层
│   ├── entity         # 实体类
│   └── mapper         # Mapper 接口
├── service            # 业务逻辑层
│   ├── dto            # 数据传输对象
│   ├── impl           # 服务实现
│   └── schedule       # 定时任务
└── web                # Web 层
    ├── controller     # 控制器
    ├── config         # Web 配置
    └── websocket      # WebSocket 处理
```

### 代码质量

#### 1. 避免魔法值
```java
// ✅ 正确 - 使用常量
if (game.getStatus() == GameConstants.GameStatus.ENABLED) {
    // ...
}

// ❌ 错误 - 使用魔法值
if (game.getStatus() == 1) {
    // ...
}
```

#### 2. 方法长度控制
- 单个方法不超过 50 行
- 复杂逻辑拆分为多个私有方法

```java
// ✅ 正确 - 方法职责单一
@Override
public Parent login(ParentLoginDTO dto) {
    validateLoginParams(dto);
    String phone = dto.getPhone().trim();
    Parent parent = getOrRegisterParent(phone, dto.getPassword());
    return parent;
}

// ❌ 错误 - 方法过长，包含过多逻辑
@Override
public Parent login(ParentLoginDTO dto) {
    // 50+ 行的逻辑...
}
```

#### 3. 参数验证
```java
// ✅ 正确 - 参数验证集中处理
private void validateLoginParams(ParentLoginDTO dto) {
    if (dto.getPhone() == null || dto.getPhone().trim().isEmpty()) {
        throw new BusinessException(ErrorCode.PARAM_ERROR, 
            GameConstants.ErrorMessage.PHONE_EMPTY);
    }
    // ...
}

// ❌ 错误 - 参数验证分散
public void someMethod(String phone) {
    if (phone == null) {
        // ...
    }
    // ...
}
```

### 注释规范

#### 1. 类注释
```java
/**
 * 儿童用户业务服务实现
 * 
 * 提供儿童用户的登录、注册、疲劳点管理等功能
 * 
 * @author KidsGame
 * @since 1.0.0
 */
@Slf4j
@Service
public class KidServiceImpl extends ServiceImpl<KidMapper, Kid> implements KidService {
    // ...
}
```

#### 2. 方法注释
```java
/**
 * 验证登录参数
 * 
 * 检查手机号和密码的有效性，包括非空校验和格式校验
 * 
 * @param dto 登录请求对象
 * @throws BusinessException 参数校验失败时抛出
 */
private void validateLoginParams(ParentLoginDTO dto) {
    // ...
}
```

#### 3. 字段注释
```java
/** 疲劳点缓存 Key 前缀 */
private static final String FATIGUE_POINTS_CACHE_KEY = "kid:fatigue:";

/** 初始疲劳点数 */
@Value("${kidgame.game.fatigue-points.initial:10}")
private Integer initialFatiguePoints;
```

#### 4. 行内注释
```java
// 克隆对象避免修改原始数据
Kid resultKid = new Kid();
resultKid.setUsername(kid.getUsername());

// TODO: 通过 WebSocket 推送暂停指令到前端
public void remotePauseGame(Long kidId) {
    log.info("Remote pause game. KidId: {}", kidId);
}
```

### 异常处理

#### 1. 使用业务异常
```java
// ✅ 正确 - 使用业务异常
if (kid == null) {
    throw new BusinessException(ErrorCode.KID_NOT_FOUND);
}

// ❌ 错误 - 直接返回 null 或抛出 RuntimeException
if (kid == null) {
    return null;
}
```

#### 2. 事务处理
```java
// ✅ 正确 - 明确指定回滚异常
@Override
@Transactional(rollbackFor = Exception.class)
public void register(KidRegisterDTO dto) {
    // ...
}

// ❌ 错误 - 不指定回滚异常
@Transactional
public void register(KidRegisterDTO dto) {
    // ...
}
```

### 日志规范

#### 1. 日志级别使用
- `ERROR`: 系统错误、异常
- `WARN`: 警告信息（不影响业务）
- `INFO`: 关键业务操作
- `DEBUG`: 调试信息（生产环境不输出）

#### 2. 日志格式
```java
// ✅ 正确 - 使用参数化日志
log.info("用户登录成功. Username: {}, UserId: {}", username, userId);

// ❌ 错误 - 字符串拼接
log.info("用户登录成功. Username: " + username + ", UserId: " + userId);

// ❌ 错误 - 错误信息不规范
log.info("error: {}", e);
```

#### 3. 异常日志
```java
// ✅ 正确
try {
    // ...
} catch (Exception e) {
    log.error("JSON 序列化失败: {}", obj, e);
    throw new BusinessException(ErrorCode.SYSTEM_ERROR, "操作失败");
}

// ❌ 错误 - 不记录异常堆栈
catch (Exception e) {
    log.error("操作失败");
}
```

---

## TypeScript/JavaScript 前端规范

### 命名规范

#### 1. 文件命名
- 组件文件：`PascalCase.vue`
- 工具类文件：`kebab-case.ts`
- 常量文件：`kebab-case.ts`
- 服务文件：`kebab-case.service.ts`

```
// ✅ 正确
UserProfile.vue
date-util.ts
api-constants.ts
user-api.service.ts

// ❌ 错误
userProfile.vue
dateUtil.ts
apiConstants.ts
```

#### 2. 变量命名
- 使用小驼峰命名法 (camelCase)
- 常量使用全大写，单词间用 `_` 分隔

```typescript
// ✅ 正确
const userName: string = '张三';
const MAX_RETRY_COUNT = 3;

// ❌ 错误
const username = '张三';
const maxRetryCount = 3;
```

#### 3. 函数命名
- 使用小驼峰命名法 (camelCase)
- 函数名应该是动词或动词短语

```typescript
// ✅ 正确
function getUserInfo(): void {}
async function login(): Promise<void> {}

// ❌ 错误
function UserInfo(): void {}
function Login(): void {}
```

### 代码结构

#### 1. Vue 组件结构
```vue
<template>
  <!-- 模板 -->
</template>

<script setup lang="ts">
// 1. 导入语句
import { ref, computed } from 'vue';

// 2. Props 定义
const props = defineProps<{ ... }>();

// 3. Emits 定义
const emit = defineEmits<{ ... }>();

// 4. 类型定义
interface User { ... }

// 5. 响应式数据
const count = ref(0);

// 6. 计算属性
const doubleCount = computed(() => count.value * 2);

// 7. 方法
function increment() { ... }

// 8. 生命周期钩子
onMounted(() => { ... });
</script>

<style scoped>
/* 样式 */
</style>
```

#### 2. 服务类结构
```typescript
/**
 * API 服务类
 */
export class SomeApiService extends BaseApiService {
  private static instance: SomeApiService;

  private constructor() {
    super();
  }

  static getInstance(): SomeApiService {
    if (!SomeApiService.instance) {
      SomeApiService.instance = new SomeApiService();
    }
    return SomeApiService.instance;
  }

  // 公共方法
  async getData(): Promise<any> {
    return this.get('/api/data');
  }
}

export const someApi = SomeApiService.getInstance();
```

### 代码质量

#### 1. TypeScript 类型定义
```typescript
// ✅ 正确 - 明确定义类型
interface ApiResponse<T = any> {
  code: number;
  msg: string;
  data: T;
}

async function getUser(): Promise<User> {
  // ...
}

// ❌ 错误 - 使用 any
async function getUser(): Promise<any> {
  // ...
}
```

#### 2. 异步处理
```typescript
// ✅ 正确 - 使用 async/await
async function loadData() {
  try {
    const data = await apiService.getData();
    return data;
  } catch (error) {
    console.error('加载数据失败:', error);
    throw error;
  }
}

// ❌ 错误 - Promise 链式调用（复杂场景）
function loadData() {
  return apiService.getData()
    .then(data => data)
    .catch(error => {
      console.error('加载数据失败:', error);
      throw error;
    });
}
```

#### 3. 避免魔法值
```typescript
// ✅ 正确 - 使用常量
if (result.code === API_CONSTANTS.HTTP_STATUS.OK) {
  // ...
}

// ❌ 错误 - 使用魔法值
if (result.code === 200) {
  // ...
}
```

### 注释规范

#### 1. 类注释
```typescript
/**
 * HTTP 请求基类
 * 封装通用的请求逻辑和错误处理
 */
export class BaseApiService {
  // ...
}
```

#### 2. 方法注释
```typescript
/**
 * 设置 Token
 * 
 * @param token 认证令牌
 */
setToken(token: string): void {
  this.token = token;
  localStorage.setItem(API_CONSTANTS.TOKEN_KEY, token);
}
```

#### 3. 行内注释
```typescript
// 检查 Token 是否有效
if (!response.ok) {
  // ...
}
```

---

## Git 提交规范

### 提交信息格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 类型
- `feat`: 新功能
- `fix`: 修复 Bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 重构（不是新功能，也不是修复 Bug）
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具相关

### 示例
```bash
feat(service): 添加用户注册功能

- 实现 KidService.register() 方法
- 添加参数验证逻辑
- 支持多家长绑定

Closes #123
```

```bash
fix(util): 修复 JSON 序列化异常处理

- 在 JsonUtil 中添加安全序列化方法
- 完善异常日志记录

Fixes #456
```

---

## 代码审查清单

### 提交代码前自查

- [ ] 所有方法都有适当的注释
- [ ] 没有魔法值，使用了常量
- [ ] 方法长度不超过 50 行
- [ ] 类长度不超过 500 行
- [ ] 异常处理完善
- [ ] 日志使用参数化格式
- [ ] 命名符合规范
- [ ] 没有重复代码
- [ ] 代码格式化
- [ ] 通过单元测试（如果有）

---

## 工具推荐

### 后端
- **IDE**: IntelliJ IDEA
- **代码格式化**: 使用 IDE 默认格式化配置
- **代码检查**: SonarLint、Alibaba Java Coding Guidelines 插件

### 前端
- **IDE**: VSCode
- **代码格式化**: Prettier
- **代码检查**: ESLint + TypeScript ESLint
- **Git Hook**: Husky + lint-staged

---

## 参考资料

- [阿里巴巴 Java 开发手册](https://github.com/alibaba/p3c)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [TypeScript 官方文档](https://www.typescriptlang.org/docs/)

---

**最后更新**: 2026-03-06
**维护者**: KidsGame 开发团队
