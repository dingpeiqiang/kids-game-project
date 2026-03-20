const r=`# 儿童游戏平台\r
\r
> 专业的儿童在线游戏平台，提供安全、健康的游戏体验\r
\r
## 项目简介\r
\r
本项目是一个面向儿童的游戏平台，包含完整的用户管理系统、游戏库、家长管控、疲劳度管理等核心功能。\r
\r
## 技术栈\r
\r
### 后端\r
- **框架**: Spring Boot 3.x\r
- **数据库**: MySQL 8.0\r
- **ORM**: MyBatis-Plus\r
- **缓存**: Redis\r
- **认证**: JWT + BCrypt\r
- **文档**: Knife4j (Swagger)\r
\r
### 前端\r
- **框架**: Vue 3 + TypeScript\r
- **构建工具**: Vite\r
- **UI 组件**: 自定义组件库\r
- **状态管理**: Pinia\r
- **HTTP 客户端**: Fetch API\r
\r
### 游戏引擎\r
- **引擎**: Phaser 3.80\r
- **语言**: TypeScript\r
\r
## 项目结构\r
\r
\`\`\`\r
kids-game-project/\r
├── kids-game-backend/        # 后端服务\r
│   ├── kids-game-common/     # 公共模块\r
│   ├── kids-game-dao/        # 数据访问层\r
│   ├── kids-game-service/    # 业务逻辑层\r
│   └── kids-game-web/        # Web 层\r
├── kids-game-frontend/       # 前端项目\r
│   ├── src/\r
│   │   ├── services/         # API 服务\r
│   │   ├── core/            # 核心功能\r
│   │   ├── modules/         # 业务模块\r
│   │   ├── docs/            # 📚 项目手册文档\r
│   │   └── components/      # 通用组件\r
│   └── assets/              # 静态资源\r
├── kids-game-frontend/       # 前端（Vue 3 + Phaser）\r
├── docs/                     # 📚 项目文档\r
└── README.md                 # 本文件\r
\`\`\`\r
\r
## 快速开始\r
\r
### 后端启动\r
\r
\`\`\`bash\r
# 1. 配置数据库（修改 application.yml）\r
# 2. 启动 Redis\r
# 3. 运行启动脚本\r
cd kids-game-backend\r
mvn spring-boot:run\r
\`\`\`\r
\r
### 前端启动\r
\r
\`\`\`bash\r
cd kids-game-frontend\r
npm install\r
npm run dev\r
\`\`\`\r
\r
### 游戏平台启动\r
\r
游戏模块基于 Phaser 3.80 引擎开发，集成在前端项目中。\r
\r
## 核心功能\r
\r
### 用户系统\r
- ✅ 儿童注册/登录\r
- ✅ 家长注册/登录\r
- ✅ 手机号验证码登录\r
- ✅ 密码加密存储\r
\r
**重要说明**：\r
- **儿童和家长都可以玩游戏**\r
- 用户类型（儿童/家长）的区别仅在于：\r
  - 家长可以约束其孩子的游戏行为（时长限制、游戏屏蔽、时段控制等）\r
  - 家长可以查看孩子的游戏记录和答题记录\r
  - 家长可以管理游戏授权（屏蔽/解锁游戏）\r
- 游戏会话、疲劳点、排行榜等功能对两种用户完全一致\r
- 系统根据注册时的角色类型自动识别用户类型\r
\r
### 游戏管理\r
- ✅ 游戏列表展示\r
- ✅ 游戏详情查看\r
- ✅ 按年级/分类筛选\r
- ✅ 游戏会话管理\r
\r
### 家长管控\r
- ✅ 游戏时长限制\r
- ✅ 游戏时段控制\r
- ✅ 游戏屏蔽功能\r
- ✅ 远程暂停/解锁\r
- ✅ 游戏记录查询\r
- ✅ 答题记录查询\r
\r
### 疲劳度系统\r
- ✅ 疲劳点消耗\r
- ✅ 答题获取疲劳点\r
- ✅ 每日疲劳点重置\r
- ✅ Redis 缓存优化\r
\r
## API 文档\r
\r
后端启动后访问: \`http://localhost:8080/doc.html\`\r
\r
## 编码规范\r
\r
本项目严格遵循 [CODING_STANDARDS.md](./CODING_STANDARDS.md) 中定义的编码规范。\r
\r
**主要规范**:\r
- 基于阿里巴巴 Java 开发手册\r
- 单个文件不超过 500 行\r
- 方法不超过 50 行\r
- 避免重复代码\r
- 使用常量替代魔法值\r
- 单一职责原则\r
\r
## 代码重构\r
\r
详见 [REFACTORING_GUIDE.md](./REFACTORING_GUIDE.md) 了解最近的代码重构工作。\r
\r
**重构亮点**:\r
- 提取 JsonUtil 工具类，统一 JSON 处理\r
- 创建 GameConstants 和 SystemConstants 常量类\r
- 前端服务模块化（kid-api、parent-api、game-api 等）\r
- 后端服务类提取私有方法，提高可读性\r
\r
## 开发指南\r
\r
### 后端开发\r
\r
1. 遵循包结构规范\r
2. 使用 DTO 进行数据传输\r
3. 统一异常处理\r
4. 完善日志记录\r
5. 编写单元测试\r
\r
### 前端开发\r
\r
1. 使用 TypeScript 类型定义\r
2. 组件化开发\r
3. 模块化 API 服务\r
4. 统一错误处理\r
5. 响应式设计\r
\r
### 提交代码\r
\r
遵循 Git 提交规范:\r
\r
\`\`\`bash\r
feat(module): 添加新功能\r
fix(module): 修复 Bug\r
docs(module): 更新文档\r
style(module): 代码格式调整\r
refactor(module): 重构代码\r
\`\`\`\r
\r
## 常见问题\r
\r
### Q: 后端启动失败？\r
A: 检查数据库配置和 Redis 是否启动\r
\r
### Q: 前端接口请求失败？\r
A: 检查 Vite 代理配置和后端服务是否正常运行\r
\r
### Q: 游戏黑屏？\r
A: 参考 [黑屏问题解决方案](https://github.com/your-repo/wiki/Black-Screen-Issue)\r
\r
## 贡献指南\r
\r
1. Fork 本项目\r
2. 创建特性分支 (\`git checkout -b feature/AmazingFeature\`)\r
3. 提交更改 (\`git commit -m 'feat: 添加新功能'\`)\r
4. 推送到分支 (\`git push origin feature/AmazingFeature\`)\r
5. 提交 Pull Request\r
\r
## 联系我们\r
\r
- 项目主页: [GitHub](https://github.com/your-repo)\r
- 问题反馈: [Issues](https://github.com/your-repo/issues)\r
- 邮箱: support@kidsgame.com\r
\r
## 许可证\r
\r
本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件\r
\r
---\r
\r
**最后更新**: 2026-03-06\r
**版本**: 1.0.0\r
**维护者**: KidsGame 开发团队\r
`;export{r as default};
//# sourceMappingURL=README-DlqKlsjx.js.map
