const n=`# 飞机大战和染色体游戏清理报告\r
\r
## 清理日期\r
2026年3月14日\r
\r
## 清理内容\r
\r
### 1. 删除的游戏目录\r
- ✅ \`kids-game-house/chromosome/\` - 超级染色体游戏目录\r
- ✅ \`kids-game-house/plane-shooter/\` - 飞机大战游戏目录\r
- ✅ \`kids-game-frontend/src/modules/game/games/chromosome/\` - 前端染色体游戏代码\r
- ✅ \`kids-game-frontend/src/modules/game/games/plane-shooter/\` - 前端飞机大战游戏代码\r
\r
### 2. 删除的脚本和配置文件\r
- ✅ \`kids-game-frontend/verify-plane-shooter.ps1\` - 飞机大战验证脚本\r
- ✅ \`kids-game-frontend/diagnose-imports.bat\` - 导入诊断脚本\r
- ✅ \`kids-game-frontend/add-plane-shooter-to-game-list.json\` - 游戏列表配置\r
- ✅ \`kids-game-backend/register-plane-shooter.ps1\` - 注册脚本\r
- ✅ \`kids-game-backend/register-plane-shooter.bat\` - 注册批处理\r
- ✅ \`kids-game-backend/init-plane-shooter.sql\` - 飞机大战初始化SQL\r
- ✅ \`kids-game-backend/init-chromosome.sql\` - 染色体初始化SQL\r
- ✅ \`kids-game-house/start-unified-system.bat\` - 统一系统启动脚本\r
\r
### 3. 更新的配置文件\r
\r
#### 游戏模式注册表\r
- ✅ \`kids-game-frontend/src/modules/game/core/config/GameModeRegistry.ts\`\r
  - 删除了 \`plane-shooter\` 游戏配置\r
  - 保留了 \`snake-vue3\` 游戏配置\r
\r
#### 批处理脚本\r
- ✅ \`kids-game-house/start-all-games.bat\` - 只保留贪吃蛇启动\r
- ✅ \`kids-game-house/build-all-games.bat\` - 只保留贪吃蛇构建\r
- ✅ \`kids-game-house/install-dependencies.bat\` - 只保留贪吃蛇依赖安装\r
- ✅ \`kids-game-house/diagnose.bat\` - 移除染色体和飞机大战检查\r
- ✅ \`kids-game-backend/quick-fix-games.bat\` - 更新验证查询\r
\r
#### SQL脚本\r
- ✅ \`kids-game-backend/cleanup-games.sql\` - 更新只保留贪吃蛇\r
- ✅ \`kids-game-backend/init-real-games.sql\` - 移除染色体和飞机大战插入语句\r
- ✅ \`kids-game-backend/update-game-urls-unified.sql\` - 移除对应游戏URL更新\r
- ✅ \`kids-game-backend/cleanup-plane-chromosome.sql\` - 新建删除这两个游戏的SQL脚本\r
\r
#### HTML文件\r
- ✅ \`kids-game-house/test-games.html\` - 移除染色体和飞机大战测试iframe\r
\r
#### 文档文件\r
- ✅ \`kids-game-house/README.md\` - 更新目录结构和游戏列表\r
- ✅ \`kids-game-house/QUICK_START.md\` - 更新快速启动指南\r
- ✅ \`kids-game-house/TEST_GUIDE.md\` - 更新测试指南\r
- ✅ \`kids-game-project/PROGRESS_SUMMARY.md\` - 更新试点游戏建议\r
\r
## 数据库清理\r
\r
### 需要执行的SQL\r
运行以下命令删除数据库中的游戏数据：\r
\`\`\`bash\r
cd kids-game-backend\r
mysql -u root -p kids_game < cleanup-plane-chromosome.sql\r
\`\`\`\r
\r
### SQL内容\r
该脚本将删除：\r
- \`t_game\` 表中的 \`CHROMOSOME\` 游戏\r
- \`t_game\` 表中的 \`PLANE_SHOOTER\` 游戏\r
- \`t_game_ranking\` 表中相关的排行榜数据\r
\r
## 保留的游戏\r
\r
### 贪吃蛇大冒险（snake-vue3）\r
- 游戏代码：\`SNAKE_VUE3\`\r
- 端口：3003\r
- 分类：PUZZLE（益智）\r
- 年级：一年级\r
- 状态：正常\r
\r
## 清理后的游戏列表\r
\r
项目现在只保留一个游戏：\r
1. **贪吃蛇大冒险** - 经典贪吃蛇游戏，支持多种难度和稀有食物\r
\r
## 后续操作\r
\r
1. **执行数据库清理**\r
   \`\`\`bash\r
   mysql -u root -p kids_game < kids-game-backend/cleanup-plane-chromosome.sql\r
   \`\`\`\r
\r
2. **重新编译后端**（如果需要）\r
   \`\`\`bash\r
   cd kids-game-backend\r
   mvn clean install -DskipTests\r
   \`\`\`\r
\r
3. **重启后端服务**\r
   \r
4. **验证前端游戏列表**\r
   - 确保只显示贪吃蛇游戏\r
   - 测试游戏可正常运行\r
\r
## 注意事项\r
\r
- 染色体和飞机大战的所有代码和配置已完全删除\r
- 数据库中的相关记录需要手动清理\r
- 前端和后端的缓存可能需要清除\r
- 如果使用了CDN或静态服务器，需要同步删除对应文件\r
\r
## 清理验证\r
\r
清理后，可以通过以下方式验证：\r
\r
1. **检查游戏目录**\r
   \`\`\`bash\r
   ls kids-game-house/\r
   # 应该只看到 snake-vue3 目录\r
   \`\`\`\r
\r
2. **检查游戏配置**\r
   \`\`\`bash\r
   mysql -u root -p kids_game -e "SELECT game_code, game_name FROM t_game;"\r
   # 应该只看到 SNAKE_VUE3 游戏\r
   \`\`\`\r
\r
3. **检查前端游戏列表**\r
   - 访问前端应用\r
   - 查看游戏列表页面\r
   - 确认只显示贪吃蛇游戏\r
`;export{n as default};
//# sourceMappingURL=CLEANUP_PLANE_CHROMOSOME-isXly_3_.js.map
