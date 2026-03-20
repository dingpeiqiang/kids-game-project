-- 初始化贪吃蛇和植物大战僵尸的主题数据
-- 确保这两个游戏有可用的主题

-- 1. 贪吃蛇专属主题
INSERT INTO theme_info (
    author_id,
    theme_name,
    applicable_scope,
    author_name,
    price,
    status,
    download_count,
    total_revenue,
    thumbnail_url,
    description,
    config_json,
    created_at,
    updated_at
) VALUES
(
    1,
    '贪吃蛇 - 清新绿',
    'specific',
    '系统',
    100,
    'on_sale',
    0,
    0,
    '/images/themes/snake/green/thumbnail.png',
    '专为贪吃蛇设计的清新绿色主题，让游戏体验更加舒适。',
    JSON_OBJECT(
        'version', '1.0',
        'colorScheme', 'green',
        'colors', JSON_OBJECT(
            'primary', '#42b983',
            'secondary', '#35495e',
            'background', '#f0f9f0',
            'snakeHead', '#42b983',
            'snakeBody', '#50c878',
            'food', '#ff6b6b'
        )
    ),
    NOW(),
    NOW()
),
(
    1,
    '贪吃蛇 - 经典复古',
    'specific',
    '系统',
    0,
    'on_sale',
    0,
    0,
    '/images/themes/snake/classic/thumbnail.png',
    '经典复古风格的贪吃蛇主题，黑白配色，简单纯粹。',
    JSON_OBJECT(
        'version', '1.0',
        'colorScheme', 'classic',
        'colors', JSON_OBJECT(
            'primary', '#000000',
            'secondary', '#ffffff',
            'background', '#1a1a1a',
            'snakeHead', '#ffffff',
            'snakeBody', '#cccccc',
            'food', '#ffffff'
        )
    ),
    NOW(),
    NOW()
)
ON DUPLICATE KEY UPDATE
    theme_name = VALUES(theme_name),
    description = VALUES(description),
    updated_at = NOW();

-- 2. 植物大战僵尸专属主题
INSERT INTO theme_info (
    author_id,
    theme_name,
    applicable_scope,
    author_name,
    price,
    status,
    download_count,
    total_revenue,
    thumbnail_url,
    description,
    config_json,
    created_at,
    updated_at
) VALUES
(
    1,
    '植物大战僵尸 - 阳光活力',
    'specific',
    '系统',
    150,
    'on_sale',
    0,
    0,
    '/images/themes/pvz/sunshine/thumbnail.png',
    '充满阳光活力的植物大战僵尸专属主题，色彩明快。',
    JSON_OBJECT(
        'version', '1.0',
        'colorScheme', 'sunshine',
        'colors', JSON_OBJECT(
            'primary', '#f7dc6f',
            'secondary', '#2ecc71',
            'background', '#fef9e7',
            'plant', '#2ecc71',
            'zombie', '#922b21',
            'sun', '#f4d03f'
        )
    ),
    NOW(),
    NOW()
),
(
    1,
    '植物大战僵尸 - 月夜幽深',
    'specific',
    '系统',
    120,
    'on_sale',
    0,
    0,
    '/images/themes/pvz/moonlight/thumbnail.png',
    '神秘的月夜风格主题，幽深而富有挑战性。',
    JSON_OBJECT(
        'version', '1.0',
        'colorScheme', 'moonlight',
        'colors', JSON_OBJECT(
            'primary', '#5b2c6f',
            'secondary', '#283747',
            'background', '#1c2833',
            'plant', '#8e44ad',
            'zombie', '#566573',
            'moon', '#d4e6f1'
        )
    ),
    NOW(),
    NOW()
)
ON DUPLICATE KEY UPDATE
    theme_name = VALUES(theme_name),
    description = VALUES(description),
    updated_at = NOW();

-- 3. 为这些主题建立游戏关联
-- 删除旧的关联（仅针对这两个游戏）
DELETE FROM theme_game_relation
WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');

-- 插入新的关联关系
INSERT INTO theme_game_relation (
    theme_id,
    game_id,
    game_code,
    is_default,
    create_time,
    update_time
)
SELECT
    ti.theme_id,
    g.game_id,
    g.game_code,
    CASE
        WHEN ti.theme_name LIKE '%经典%' OR ti.theme_name LIKE '%默认%' THEN 1
        ELSE 0
    END as is_default,
    UNIX_TIMESTAMP(NOW()) * 1000 as create_time,
    UNIX_TIMESTAMP(NOW()) * 1000 as update_time
FROM theme_info ti
CROSS JOIN t_game g
WHERE g.game_code IN ('snake-vue3', 'plants-vs-zombie')
AND (ti.theme_name LIKE '%贪吃蛇%' OR ti.theme_name LIKE '%植物%')
AND NOT EXISTS (
    SELECT 1 FROM theme_game_relation tgr
    WHERE tgr.game_id = g.game_id
    AND tgr.theme_id = ti.theme_id
);

-- 4. 验证插入结果
SELECT
    '=== 游戏列表 ===' as info;

SELECT
    game_id,
    game_code,
    game_name,
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
    price,
    description
FROM theme_info
WHERE theme_name LIKE '%贪吃蛇%' OR theme_name LIKE '%植物%'
ORDER BY theme_id;

SELECT
    '=== 主题-游戏关联关系 ===' as info;

SELECT
    ti.theme_id,
    ti.theme_name,
    tgr.game_id,
    tgr.game_code,
    g.game_name,
    tgr.is_default,
    CASE tgr.is_default
        WHEN 1 THEN '✓ 默认主题'
        ELSE '○ 普通主题'
    END as default_status
FROM theme_info ti
INNER JOIN theme_game_relation tgr ON ti.theme_id = tgr.theme_id
INNER JOIN t_game g ON tgr.game_id = g.game_id
WHERE tgr.game_code IN ('snake-vue3', 'plants-vs-zombie')
ORDER BY ti.theme_id, g.game_id;

SELECT
    '=== 统计信息 ===' as info;

SELECT
    '贪吃蛇主题数' as item,
    COUNT(*) as value
FROM theme_game_relation tgr
INNER JOIN theme_info ti ON tgr.theme_id = ti.theme_id
WHERE tgr.game_code = 'snake-vue3'
UNION ALL
SELECT
    '植物大战僵尸主题数',
    COUNT(*)
FROM theme_game_relation tgr
INNER JOIN theme_info ti ON tgr.theme_id = ti.theme_id
WHERE tgr.game_code = 'plants-vs-zombie';
