-- =====================================================
-- 游戏平台解耦 - 数据库迁移脚本
-- =====================================================
-- 执行时间: 2026-03-13
-- 描述: 为支持游戏独立部署，扩展 t_game 和 t_game_session 表
-- =====================================================

-- 1. 扩展 t_game 表（支持独立部署的游戏）
ALTER TABLE t_game
ADD COLUMN game_url VARCHAR(500) NULL COMMENT '游戏访问地址URL（独立部署时使用）' AFTER resource_url;

ALTER TABLE t_game
ADD COLUMN game_secret VARCHAR(100) NULL COMMENT '游戏密钥（用于签名验证）' AFTER game_url;

ALTER TABLE t_game
ADD COLUMN game_config JSON NULL COMMENT '游戏配置（透传给游戏的JSON配置）' AFTER game_secret;

-- 2. 扩展 t_game_session 表（添加会话令牌）
ALTER TABLE t_game_session
ADD COLUMN session_token VARCHAR(100) NULL UNIQUE COMMENT '会话令牌（用于游戏验证）' AFTER game_id;

-- 3. 为 session_token 添加索引
ALTER TABLE t_game_session
ADD INDEX idx_session_token (session_token);

-- 4. 更新现有游戏数据（可选：为现有游戏设置示例配置）
UPDATE t_game
SET game_config = '{"difficulty":"medium","language":"zh-CN"}'
WHERE game_config IS NULL;

-- =====================================================
-- 数据字典
-- =====================================================

-- t_game.game_url: 游戏的独立部署地址
--   - 示例: https://games.example.com/snake
--   - 为空时：使用嵌入式游戏模式（module_path）
--   - 有值时：通过 iframe 加载外部游戏

-- t_game.game_secret: 游戏签名密钥（可选）
--   - 用于验证游戏请求的合法性
--   - 防止作弊和未授权访问

-- t_game.game_config: 游戏配置（JSON格式）
--   - 透传给游戏的配置参数
--   - 游戏可以根据配置调整难度、主题等
--   - 示例: {"difficulty":"medium","language":"zh-CN","theme":"light"}

-- t_game_session.session_token: 会话令牌
--   - 用于标识游戏会话的唯一标识
--   - 游戏通过 URL 参数接收：?session_id={session_token}
--   - 游戏提交结果时携带此令牌进行验证

-- =====================================================
-- 示例数据
-- =====================================================

-- 示例：注册一个独立部署的贪吃蛇游戏
INSERT INTO t_game (
    game_code, game_name, category, grade,
    icon_url, description, game_url, game_secret,
    game_config, status, consume_points_per_minute,
    create_time, update_time
) VALUES (
    'SNAKE_STANDALONE',
    '贪吃蛇（独立版）',
    'PUZZLE',
    '一年级',
    '/images/games/snake-icon.png',
    '经典贪吃蛇游戏，独立部署版本',
    'https://games.example.com/snake',
    'snake_secret_123456',
    '{"difficulty":"medium","gridSize":20,"initialSpeed":150}',
    1,
    1,
    UNIX_TIMESTAMP(NOW()) * 1000,
    UNIX_TIMESTAMP(NOW()) * 1000
) ON DUPLICATE KEY UPDATE
    game_url = 'https://games.example.com/snake',
    game_secret = 'snake_secret_123456',
    game_config = '{"difficulty":"medium","gridSize":20,"initialSpeed":150}';

-- =====================================================
-- 回滚脚本（如需回滚，执行以下语句）
-- =====================================================
-- ALTER TABLE t_game DROP COLUMN game_url;
-- ALTER TABLE t_game DROP COLUMN game_secret;
-- ALTER TABLE t_game DROP COLUMN game_config;
-- ALTER TABLE t_game_session DROP COLUMN session_token;
-- ALTER TABLE t_game_session DROP INDEX idx_session_token;
