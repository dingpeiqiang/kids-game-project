-- 修复游戏代码不一致问题
-- 问题：贪吃蛇的gameCode在前端是'snake-vue3'，在数据库是'SNAKE_VUE3'，导致主题查询不到

-- 1. 更新贪吃蛇游戏的gameCode为小写
UPDATE t_game
SET game_code = 'snake-vue3'
WHERE game_code = 'SNAKE_VUE3';

-- 2. 添加植物大战僵尸游戏
INSERT INTO t_game (
    game_code,
    game_name,
    category,
    grade,
    icon_url,
    cover_url,
    description,
    game_url,
    module_path,
    status,
    sort_order,
    consume_points_per_minute,
    create_time,
    update_time
) VALUES (
    'plants-vs-zombie',
    '植物大战僵尸',
    'STRATEGY',
    '三年级',
    '/images/games/pvz/pvz-icon.png',
    '',
    '经典的植物大战僵尸游戏，种植各种植物抵御僵尸进攻！',
    'http://localhost:3004',
    NULL,
    1,
    2,
    1,
    UNIX_TIMESTAMP() * 1000,
    UNIX_TIMESTAMP() * 1000
) ON DUPLICATE KEY UPDATE
    game_name = VALUES(game_name),
    category = VALUES(category),
    description = VALUES(description),
    game_url = VALUES(game_url),
    update_time = VALUES(update_time);

-- 3. 更新主题游戏关联表中的gameCode
UPDATE theme_game_relation tgr
INNER JOIN t_game g ON tgr.game_id = g.game_id
SET tgr.game_code = g.game_code
WHERE tgr.game_code IN ('SNAKE_VUE3', 'PLANTS_VS_ZOMBIE');

-- 4. 验证修复结果
SELECT
    '=== 游戏列表 ===' as info;

SELECT
    game_id,
    game_code,
    game_name,
    game_url,
    status
FROM t_game
WHERE game_code IN ('snake-vue3', 'plants-vs-zombie')
ORDER BY sort_order;

SELECT
    '=== 主题列表 ===' as info;

SELECT
    theme_id,
    theme_name,
    applicable_scope,
    status,
    description
FROM theme_info
WHERE theme_name LIKE '%贪吃蛇%'
   OR theme_name LIKE '%植物%'
ORDER BY theme_id;

SELECT
    '=== 主题-游戏关联关系 ===' as info;

SELECT
    ti.theme_id,
    ti.theme_name,
    tgr.game_id,
    tgr.game_code,
    g.game_name,
    tgr.is_default
FROM theme_info ti
INNER JOIN theme_game_relation tgr ON ti.theme_id = tgr.theme_id
INNER JOIN t_game g ON tgr.game_id = g.game_id
WHERE tgr.game_code IN ('snake-vue3', 'plants-vs-zombie')
ORDER BY ti.theme_id, g.game_id;
