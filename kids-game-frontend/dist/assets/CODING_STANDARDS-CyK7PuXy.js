const r=`# 儿童游戏平台 - 编码规范\r
\r
本文档定义了儿童游戏平台项目的编码规范，所有开发人员必须遵守。\r
\r
> 本规范基于阿里巴巴 Java 开发手册和前端开发最佳实践制定。\r
\r
## 目录\r
\r
- [通用原则](#通用原则)\r
- [Java 后端规范](#java-后端规范)\r
  - [命名规范](#命名规范)\r
  - [代码结构](#代码结构)\r
  - [代码质量](#代码质量)\r
  - [注释规范](#注释规范)\r
  - [异常处理](#异常处理)\r
  - [日志规范](#日志规范)\r
- [TypeScript/JavaScript 前端规范](#typescriptjavascript-前端规范)\r
  - [命名规范](#命名规范-1)\r
  - [代码结构](#代码结构-1)\r
  - [代码质量](#代码质量-1)\r
  - [注释规范](#注释规范-1)\r
- [Git 提交规范](#git-提交规范)\r
\r
---\r
\r
## 通用原则\r
\r
### 1. 可读性优先\r
- 代码应该像散文一样易于阅读\r
- 避免过于"聪明"但难以理解的代码\r
- 简单优于复杂，清晰优于巧妙\r
\r
### 2. DRY 原则 (Don't Repeat Yourself)\r
- 避免代码重复\r
- 提取公共逻辑到工具类或基类\r
- 使用常量替代魔法值\r
\r
### 3. 单一职责原则\r
- 每个类/方法只做一件事\r
- 类的行数不超过 500 行\r
- 方法的行数不超过 50 行\r
\r
### 4. KISS 原则 (Keep It Simple, Stupid)\r
- 保持简单，不要过度设计\r
- 在满足需求的前提下，选择最简单的方案\r
\r
---\r
\r
## Java 后端规范\r
\r
### 命名规范\r
\r
#### 1. 包名\r
- 全部小写，多个单词用 \`.\` 分隔\r
- 例：\`com.kidgame.service.impl\`\r
\r
#### 2. 类名\r
- 使用大驼峰命名法 (PascalCase)\r
- 类名应该是名词\r
- 接口名可加 \`I\` 前缀（本项目不使用，直接用接口描述功能）\r
\r
\`\`\`java\r
// ✅ 正确\r
public class UserServiceImpl {}\r
public interface UserService {}\r
\r
// ❌ 错误\r
public class userServiceImpl {}\r
public class userservice {}\r
\`\`\`\r
\r
#### 3. 方法名\r
- 使用小驼峰命名法 (camelCase)\r
- 方法名应该是动词或动词短语\r
- 布尔类型返回值的方法以 \`is\`、\`has\`、\`can\` 开头\r
\r
\`\`\`java\r
// ✅ 正确\r
public void updateUser() {}\r
public boolean isValid() {}\r
public boolean hasPermission() {}\r
\r
// ❌ 错误\r
public void UpdateUser() {}\r
public boolean Valid() {}\r
\`\`\`\r
\r
#### 4. 变量名\r
- 使用小驼峰命名法 (camelCase)\r
- 避免单字符变量名（循环变量除外）\r
- 常量使用全大写，单词间用 \`_\` 分隔\r
\r
\`\`\`java\r
// ✅ 正确\r
private String userName;\r
private static final int MAX_RETRY_COUNT = 3;\r
\r
// ❌ 错误\r
private String username;\r
private static final int maxRetryCount = 3;\r
\`\`\`\r
\r
### 代码结构\r
\r
#### 1. 类结构顺序\r
\`\`\`java\r
1. 包声明\r
2. 导入语句（按字母顺序排序）\r
3. 类文档注释\r
4. 类声明\r
5. 静态常量\r
6. 静态变量\r
7. 实例变量\r
8. 构造方法\r
9. 公共方法\r
10. 私有/受保护方法\r
11. 内部类（如果有）\r
\`\`\`\r
\r
#### 2. 项目包结构\r
\`\`\`\r
com.kidgame\r
├── common              # 公共模块\r
│   ├── constant       # 常量定义\r
│   ├── config         # 配置类\r
│   ├── exception      # 异常定义\r
│   ├── handler        # 处理器\r
│   ├── interceptor    # 拦截器\r
│   ├── model          # 通用模型\r
│   └── util           # 工具类\r
├── dao                # 数据访问层\r
│   ├── entity         # 实体类\r
│   └── mapper         # Mapper 接口\r
├── service            # 业务逻辑层\r
│   ├── dto            # 数据传输对象\r
│   ├── impl           # 服务实现\r
│   └── schedule       # 定时任务\r
└── web                # Web 层\r
    ├── controller     # 控制器\r
    ├── config         # Web 配置\r
    └── websocket      # WebSocket 处理\r
\`\`\`\r
\r
### 代码质量\r
\r
#### 1. 避免魔法值\r
\`\`\`java\r
// ✅ 正确 - 使用常量\r
if (game.getStatus() == GameConstants.GameStatus.ENABLED) {\r
    // ...\r
}\r
\r
// ❌ 错误 - 使用魔法值\r
if (game.getStatus() == 1) {\r
    // ...\r
}\r
\`\`\`\r
\r
#### 2. 方法长度控制\r
- 单个方法不超过 50 行\r
- 复杂逻辑拆分为多个私有方法\r
\r
\`\`\`java\r
// ✅ 正确 - 方法职责单一\r
@Override\r
public Parent login(ParentLoginDTO dto) {\r
    validateLoginParams(dto);\r
    String phone = dto.getPhone().trim();\r
    Parent parent = getOrRegisterParent(phone, dto.getPassword());\r
    return parent;\r
}\r
\r
// ❌ 错误 - 方法过长，包含过多逻辑\r
@Override\r
public Parent login(ParentLoginDTO dto) {\r
    // 50+ 行的逻辑...\r
}\r
\`\`\`\r
\r
#### 3. 参数验证\r
\`\`\`java\r
// ✅ 正确 - 参数验证集中处理\r
private void validateLoginParams(ParentLoginDTO dto) {\r
    if (dto.getPhone() == null || dto.getPhone().trim().isEmpty()) {\r
        throw new BusinessException(ErrorCode.PARAM_ERROR, \r
            GameConstants.ErrorMessage.PHONE_EMPTY);\r
    }\r
    // ...\r
}\r
\r
// ❌ 错误 - 参数验证分散\r
public void someMethod(String phone) {\r
    if (phone == null) {\r
        // ...\r
    }\r
    // ...\r
}\r
\`\`\`\r
\r
### 注释规范\r
\r
#### 1. 类注释\r
\`\`\`java\r
/**\r
 * 儿童用户业务服务实现\r
 * \r
 * 提供儿童用户的登录、注册、疲劳点管理等功能\r
 * \r
 * @author KidsGame\r
 * @since 1.0.0\r
 */\r
@Slf4j\r
@Service\r
public class KidServiceImpl extends ServiceImpl<KidMapper, Kid> implements KidService {\r
    // ...\r
}\r
\`\`\`\r
\r
#### 2. 方法注释\r
\`\`\`java\r
/**\r
 * 验证登录参数\r
 * \r
 * 检查手机号和密码的有效性，包括非空校验和格式校验\r
 * \r
 * @param dto 登录请求对象\r
 * @throws BusinessException 参数校验失败时抛出\r
 */\r
private void validateLoginParams(ParentLoginDTO dto) {\r
    // ...\r
}\r
\`\`\`\r
\r
#### 3. 字段注释\r
\`\`\`java\r
/** 疲劳点缓存 Key 前缀 */\r
private static final String FATIGUE_POINTS_CACHE_KEY = "kid:fatigue:";\r
\r
/** 初始疲劳点数 */\r
@Value("\${kidgame.game.fatigue-points.initial:10}")\r
private Integer initialFatiguePoints;\r
\`\`\`\r
\r
#### 4. 行内注释\r
\`\`\`java\r
// 克隆对象避免修改原始数据\r
Kid resultKid = new Kid();\r
resultKid.setUsername(kid.getUsername());\r
\r
// TODO: 通过 WebSocket 推送暂停指令到前端\r
public void remotePauseGame(Long kidId) {\r
    log.info("Remote pause game. KidId: {}", kidId);\r
}\r
\`\`\`\r
\r
### 异常处理\r
\r
#### 1. 使用业务异常\r
\`\`\`java\r
// ✅ 正确 - 使用业务异常\r
if (kid == null) {\r
    throw new BusinessException(ErrorCode.KID_NOT_FOUND);\r
}\r
\r
// ❌ 错误 - 直接返回 null 或抛出 RuntimeException\r
if (kid == null) {\r
    return null;\r
}\r
\`\`\`\r
\r
#### 2. 事务处理\r
\`\`\`java\r
// ✅ 正确 - 明确指定回滚异常\r
@Override\r
@Transactional(rollbackFor = Exception.class)\r
public void register(KidRegisterDTO dto) {\r
    // ...\r
}\r
\r
// ❌ 错误 - 不指定回滚异常\r
@Transactional\r
public void register(KidRegisterDTO dto) {\r
    // ...\r
}\r
\`\`\`\r
\r
### 日志规范\r
\r
#### 1. 日志级别使用\r
- \`ERROR\`: 系统错误、异常\r
- \`WARN\`: 警告信息（不影响业务）\r
- \`INFO\`: 关键业务操作\r
- \`DEBUG\`: 调试信息（生产环境不输出）\r
\r
#### 2. 日志格式\r
\`\`\`java\r
// ✅ 正确 - 使用参数化日志\r
log.info("用户登录成功. Username: {}, UserId: {}", username, userId);\r
\r
// ❌ 错误 - 字符串拼接\r
log.info("用户登录成功. Username: " + username + ", UserId: " + userId);\r
\r
// ❌ 错误 - 错误信息不规范\r
log.info("error: {}", e);\r
\`\`\`\r
\r
#### 3. 异常日志\r
\`\`\`java\r
// ✅ 正确\r
try {\r
    // ...\r
} catch (Exception e) {\r
    log.error("JSON 序列化失败: {}", obj, e);\r
    throw new BusinessException(ErrorCode.SYSTEM_ERROR, "操作失败");\r
}\r
\r
// ❌ 错误 - 不记录异常堆栈\r
catch (Exception e) {\r
    log.error("操作失败");\r
}\r
\`\`\`\r
\r
---\r
\r
## TypeScript/JavaScript 前端规范\r
\r
### 命名规范\r
\r
#### 1. 文件命名\r
- 组件文件：\`PascalCase.vue\`\r
- 工具类文件：\`kebab-case.ts\`\r
- 常量文件：\`kebab-case.ts\`\r
- 服务文件：\`kebab-case.service.ts\`\r
\r
\`\`\`\r
// ✅ 正确\r
UserProfile.vue\r
date-util.ts\r
api-constants.ts\r
user-api.service.ts\r
\r
// ❌ 错误\r
userProfile.vue\r
dateUtil.ts\r
apiConstants.ts\r
\`\`\`\r
\r
#### 2. 变量命名\r
- 使用小驼峰命名法 (camelCase)\r
- 常量使用全大写，单词间用 \`_\` 分隔\r
\r
\`\`\`typescript\r
// ✅ 正确\r
const userName: string = '张三';\r
const MAX_RETRY_COUNT = 3;\r
\r
// ❌ 错误\r
const username = '张三';\r
const maxRetryCount = 3;\r
\`\`\`\r
\r
#### 3. 函数命名\r
- 使用小驼峰命名法 (camelCase)\r
- 函数名应该是动词或动词短语\r
\r
\`\`\`typescript\r
// ✅ 正确\r
function getUserInfo(): void {}\r
async function login(): Promise<void> {}\r
\r
// ❌ 错误\r
function UserInfo(): void {}\r
function Login(): void {}\r
\`\`\`\r
\r
### 代码结构\r
\r
#### 1. Vue 组件结构\r
\`\`\`vue\r
<template>\r
  <!-- 模板 -->\r
</template>\r
\r
<script setup lang="ts">\r
// 1. 导入语句\r
import { ref, computed } from 'vue';\r
\r
// 2. Props 定义\r
const props = defineProps<{ ... }>();\r
\r
// 3. Emits 定义\r
const emit = defineEmits<{ ... }>();\r
\r
// 4. 类型定义\r
interface User { ... }\r
\r
// 5. 响应式数据\r
const count = ref(0);\r
\r
// 6. 计算属性\r
const doubleCount = computed(() => count.value * 2);\r
\r
// 7. 方法\r
function increment() { ... }\r
\r
// 8. 生命周期钩子\r
onMounted(() => { ... });\r
<\/script>\r
\r
<style scoped>\r
/* 样式 */\r
</style>\r
\`\`\`\r
\r
#### 2. 服务类结构\r
\`\`\`typescript\r
/**\r
 * API 服务类\r
 */\r
export class SomeApiService extends BaseApiService {\r
  private static instance: SomeApiService;\r
\r
  private constructor() {\r
    super();\r
  }\r
\r
  static getInstance(): SomeApiService {\r
    if (!SomeApiService.instance) {\r
      SomeApiService.instance = new SomeApiService();\r
    }\r
    return SomeApiService.instance;\r
  }\r
\r
  // 公共方法\r
  async getData(): Promise<any> {\r
    return this.get('/api/data');\r
  }\r
}\r
\r
export const someApi = SomeApiService.getInstance();\r
\`\`\`\r
\r
### 代码质量\r
\r
#### 1. TypeScript 类型定义\r
\`\`\`typescript\r
// ✅ 正确 - 明确定义类型\r
interface ApiResponse<T = any> {\r
  code: number;\r
  msg: string;\r
  data: T;\r
}\r
\r
async function getUser(): Promise<User> {\r
  // ...\r
}\r
\r
// ❌ 错误 - 使用 any\r
async function getUser(): Promise<any> {\r
  // ...\r
}\r
\`\`\`\r
\r
#### 2. 异步处理\r
\`\`\`typescript\r
// ✅ 正确 - 使用 async/await\r
async function loadData() {\r
  try {\r
    const data = await apiService.getData();\r
    return data;\r
  } catch (error) {\r
    console.error('加载数据失败:', error);\r
    throw error;\r
  }\r
}\r
\r
// ❌ 错误 - Promise 链式调用（复杂场景）\r
function loadData() {\r
  return apiService.getData()\r
    .then(data => data)\r
    .catch(error => {\r
      console.error('加载数据失败:', error);\r
      throw error;\r
    });\r
}\r
\`\`\`\r
\r
#### 3. 避免魔法值\r
\`\`\`typescript\r
// ✅ 正确 - 使用常量\r
if (result.code === API_CONSTANTS.HTTP_STATUS.OK) {\r
  // ...\r
}\r
\r
// ❌ 错误 - 使用魔法值\r
if (result.code === 200) {\r
  // ...\r
}\r
\`\`\`\r
\r
### 注释规范\r
\r
#### 1. 类注释\r
\`\`\`typescript\r
/**\r
 * HTTP 请求基类\r
 * 封装通用的请求逻辑和错误处理\r
 */\r
export class BaseApiService {\r
  // ...\r
}\r
\`\`\`\r
\r
#### 2. 方法注释\r
\`\`\`typescript\r
/**\r
 * 设置 Token\r
 * \r
 * @param token 认证令牌\r
 */\r
setToken(token: string): void {\r
  this.token = token;\r
  localStorage.setItem(API_CONSTANTS.TOKEN_KEY, token);\r
}\r
\`\`\`\r
\r
#### 3. 行内注释\r
\`\`\`typescript\r
// 检查 Token 是否有效\r
if (!response.ok) {\r
  // ...\r
}\r
\`\`\`\r
\r
---\r
\r
## Git 提交规范\r
\r
### 提交信息格式\r
\`\`\`\r
<type>(<scope>): <subject>\r
\r
<body>\r
\r
<footer>\r
\`\`\`\r
\r
### Type 类型\r
- \`feat\`: 新功能\r
- \`fix\`: 修复 Bug\r
- \`docs\`: 文档更新\r
- \`style\`: 代码格式调整（不影响功能）\r
- \`refactor\`: 重构（不是新功能，也不是修复 Bug）\r
- \`perf\`: 性能优化\r
- \`test\`: 测试相关\r
- \`chore\`: 构建/工具相关\r
\r
### 示例\r
\`\`\`bash\r
feat(service): 添加用户注册功能\r
\r
- 实现 KidService.register() 方法\r
- 添加参数验证逻辑\r
- 支持多家长绑定\r
\r
Closes #123\r
\`\`\`\r
\r
\`\`\`bash\r
fix(util): 修复 JSON 序列化异常处理\r
\r
- 在 JsonUtil 中添加安全序列化方法\r
- 完善异常日志记录\r
\r
Fixes #456\r
\`\`\`\r
\r
---\r
\r
## 代码审查清单\r
\r
### 提交代码前自查\r
\r
- [ ] 所有方法都有适当的注释\r
- [ ] 没有魔法值，使用了常量\r
- [ ] 方法长度不超过 50 行\r
- [ ] 类长度不超过 500 行\r
- [ ] 异常处理完善\r
- [ ] 日志使用参数化格式\r
- [ ] 命名符合规范\r
- [ ] 没有重复代码\r
- [ ] 代码格式化\r
- [ ] 通过单元测试（如果有）\r
\r
---\r
\r
## 工具推荐\r
\r
### 后端\r
- **IDE**: IntelliJ IDEA\r
- **代码格式化**: 使用 IDE 默认格式化配置\r
- **代码检查**: SonarLint、Alibaba Java Coding Guidelines 插件\r
\r
### 前端\r
- **IDE**: VSCode\r
- **代码格式化**: Prettier\r
- **代码检查**: ESLint + TypeScript ESLint\r
- **Git Hook**: Husky + lint-staged\r
\r
---\r
\r
## 参考资料\r
\r
- [阿里巴巴 Java 开发手册](https://github.com/alibaba/p3c)\r
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)\r
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)\r
- [TypeScript 官方文档](https://www.typescriptlang.org/docs/)\r
\r
---\r
\r
**最后更新**: 2026-03-06\r
**维护者**: KidsGame 开发团队\r
`;export{r as default};
//# sourceMappingURL=CODING_STANDARDS-CyK7PuXy.js.map
