-- =====================================================
-- 游戏主题初始化脚本（贪吃蛇 + 植物大战僵尸）
-- 执行方式：mysql -h 106.54.7.205 -u kidsgame -p kidgame < init-game-themes.sql
-- =====================================================

-- =====================================================
-- 第一部分：确认游戏存在
-- =====================================================
-- 先检查 t_game 表中是否有这两款游戏
SELECT game_id, game_code, game_name FROM t_game 
WHERE game_code IN ('snake-vue3', 'plants-vs-zombie');

-- 如果不存在，需要先插入游戏（根据实际情况调整）
-- INSERT INTO t_game (game_name, game_code, ...) VALUES ('贪吃蛇大冒险', 'snake-vue3', ...);
-- INSERT INTO t_game (game_name, game_code, ...) VALUES ('植物大战僵尸', 'plants-vs-zombie', ...);

-- =====================================================
-- 第二部分：贪吃蛇主题
-- =====================================================

-- 1. 插入贪吃蛇官方主题：清新绿（默认主题）
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '贪吃蛇 - 清新绿',
  0,
  '/themes/snake/snake-default-thumb.png',
  '贪吃蛇官方默认主题，清新的绿色风格，适合所有年龄段',
  '{
    "themeName": "贪吃蛇 - 清新绿",
    "resources": {
      "images": {
        "snakeHead": "/games/snake-vue3/themes/default/images/snakeHead.png",
        "snakeBody": "/games/snake-vue3/themes/default/images/snakeBody.png",
        "snakeTail": "/games/snake-vue3/themes/default/images/snakeTail.png",
        "food": "/games/snake-vue3/themes/default/images/food.png",
        "gameBg": "/games/snake-vue3/themes/default/images/gameBg.png"
      },
      "colors": {
        "snakeHeadColor": "#00ff00",
        "snakeBodyColor": "#42b983",
        "foodColor": "#ff0000",
        "bgColor": "#0a0a1a"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- 2. 插入贪吃蛇官方主题：经典复古
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '贪吃蛇 - 经典复古',
  50,
  '/themes/snake/snake-retro-thumb.png',
  '经典的复古像素风格，重现80年代街机游戏的怀旧感觉',
  '{
    "themeName": "贪吃蛇 - 经典复古",
    "resources": {
      "images": {
        "snakeHead": "/games/snake-vue3/themes/retro/images/snakeHead.png",
        "snakeBody": "/games/snake-vue3/themes/retro/images/snakeBody.png",
        "snakeTail": "/games/snake-vue3/themes/retro/images/snakeTail.png",
        "food": "/games/snake-vue3/themes/retro/images/food.png",
        "gameBg": "/games/snake-vue3/themes/retro/images/gameBg.png"
      },
      "colors": {
        "snakeHeadColor": "#32cd32",
        "snakeBodyColor": "#228b22",
        "foodColor": "#ffff00",
        "bgColor": "#000000"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- 3. 插入贪吃蛇官方主题：活力橙
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '贪吃蛇 - 活力橙',
  100,
  '/themes/snake/snake-orange-thumb.png',
  '充满活力的橙色主题，给你不一样的游戏体验',
  '{
    "themeName": "贪吃蛇 - 活力橙",
    "resources": {
      "images": {
        "snakeHead": "/games/snake-vue3/themes/orange/images/snakeHead.png",
        "snakeBody": "/games/snake-vue3/themes/orange/images/snakeBody.png",
        "snakeTail": "/games/snake-vue3/themes/orange/images/snakeTail.png",
        "food": "/games/snake-vue3/themes/orange/images/food.png",
        "gameBg": "/games/snake-vue3/themes/orange/images/gameBg.png"
      },
      "colors": {
        "snakeHeadColor": "#ff6600",
        "snakeBodyColor": "#ff9933",
        "foodColor": "#00ffff",
        "bgColor": "#1a1a2e"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- =====================================================
-- 第三部分：植物大战僵尸主题
-- =====================================================

-- 4. 插入植物大战僵尸官方主题：阳光活力（默认主题）
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '植物大战僵尸 - 阳光活力',
  0,
  '/themes/pvz/pvz-default-thumb.png',
  '植物大战僵尸官方默认主题，充满活力的阳光风格',
  '{
    "themeName": "植物大战僵尸 - 阳光活力",
    "resources": {
      "images": {
        "plant_peashooter": "/games/plants-vs-zombie/themes/default/images/plant_peashooter.png",
        "plant_sunflower": "/games/plants-vs-zombie/themes/default/images/plant_sunflower.png",
        "plant_wallnut": "/games/plants-vs-zombie/themes/default/images/plant_wallnut.png",
        "zombie_normal": "/games/plants-vs-zombie/themes/default/images/zombie_normal.png",
        "zombie_conehead": "/games/plants-vs-zombie/themes/default/images/zombie_conehead.png",
        "sun": "/games/plants-vs-zombie/themes/default/images/sun.png",
        "pea": "/games/plants-vs-zombie/themes/default/images/pea.png",
        "gameBg": "/games/plants-vs-zombie/themes/default/images/gameBg.png",
        "plant_slot": "/games/plants-vs-zombie/themes/default/images/plant_slot.png"
      },
      "colors": {
        "plantPrimaryColor": "#4caf50",
        "zombiePrimaryColor": "#757575",
        "sunColor": "#ffeb3b"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- 5. 插入植物大战僵尸官方主题：月夜幽深
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '植物大战僵尸 - 月夜幽深',
  120,
  '/themes/pvz/pvz-moon-thumb.png',
  '神秘的月夜风格，在月光下守护你的花园',
  '{
    "themeName": "植物大战僵尸 - 月夜幽深",
    "resources": {
      "images": {
        "plant_peashooter": "/games/plants-vs-zombie/themes/moon/images/plant_peashooter.png",
        "plant_sunflower": "/games/plants-vs-zombie/themes/moon/images/plant_sunflower.png",
        "plant_wallnut": "/games/plants-vs-zombie/themes/moon/images/plant_wallnut.png",
        "zombie_normal": "/games/plants-vs-zombie/themes/moon/images/zombie_normal.png",
        "zombie_conehead": "/games/plants-vs-zombie/themes/moon/images/zombie_conehead.png",
        "sun": "/games/plants-vs-zombie/themes/moon/images/sun.png",
        "pea": "/games/plants-vs-zombie/themes/moon/images/pea.png",
        "gameBg": "/games/plants-vs-zombie/themes/moon/images/gameBg.png",
        "plant_slot": "/games/plants-vs-zombie/themes/moon/images/plant_slot.png"
      },
      "colors": {
        "plantPrimaryColor": "#673ab7",
        "zombiePrimaryColor": "#424242",
        "sunColor": "#cddc39"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- 6. 插入植物大战僵尸官方主题：卡通萌系
INSERT INTO theme_info (
  author_id,
  author_name,
  theme_name,
  price,
  thumbnail_url,
  description,
  config_json,
  status,
  applicable_scope,
  download_count,
  total_revenue,
  created_at,
  updated_at
) VALUES (
  0,
  '官方团队',
  '植物大战僵尸 - 卡通萌系',
  150,
  '/themes/pvz/pvz-cute-thumb.png',
  '可爱的卡通风格，植物和僵尸都变得萌萌哒',
  '{
    "themeName": "植物大战僵尸 - 卡通萌系",
    "resources": {
      "images": {
        "plant_peashooter": "/games/plants-vs-zombie/themes/cute/images/plant_peashooter.png",
        "plant_sunflower": "/games/plants-vs-zombie/themes/cute/images/plant_sunflower.png",
        "plant_wallnut": "/games/plants-vs-zombie/themes/cute/images/plant_wallnut.png",
        "zombie_normal": "/games/plants-vs-zombie/themes/cute/images/zombie_normal.png",
        "zombie_conehead": "/games/plants-vs-zombie/themes/cute/images/zombie_conehead.png",
        "sun": "/games/plants-vs-zombie/themes/cute/images/sun.png",
        "pea": "/games/plants-vs-zombie/themes/cute/images/pea.png",
        "gameBg": "/games/plants-vs-zombie/themes/cute/images/gameBg.png",
        "plant_slot": "/games/plants-vs-zombie/themes/cute/images/plant_slot.png"
      },
      "colors": {
        "plantPrimaryColor": "#e91e63",
        "zombiePrimaryColor": "#9e9e9e",
        "sunColor": "#ff9800"
      }
    }
  }',
  'on_sale',
  'specific',
  0,
  0,
  NOW(),
  NOW()
);

-- =====================================================
-- 第四部分：创建主题-游戏关联关系
-- is_default 在 theme_game_relation 表中设置
-- =====================================================

-- 贪吃蛇主题关联
-- 清新绿设为默认主题（is_default = true）
INSERT INTO theme_game_relation (theme_id, game_id, game_code, is_default, created_at)
SELECT 
  t.theme_id,
  g.game_id,
  g.game_code,
  CASE WHEN t.theme_name = '贪吃蛇 - 清新绿' THEN true ELSE false END,
  NOW()
FROM theme_info t
CROSS JOIN t_game g
WHERE t.theme_name LIKE '贪吃蛇%' 
  AND g.game_code = 'snake-vue3';

-- 植物大战僵尸主题关联
-- 阳光活力设为默认主题（is_default = true）
INSERT INTO theme_game_relation (theme_id, game_id, game_code, is_default, created_at)
SELECT 
  t.theme_id,
  g.game_id,
  g.game_code,
  CASE WHEN t.theme_name = '植物大战僵尸 - 阳光活力' THEN true ELSE false END,
  NOW()
FROM theme_info t
CROSS JOIN t_game g
WHERE t.theme_name LIKE '植物大战僵尸%' 
  AND g.game_code = 'plants-vs-zombie';

-- =====================================================
-- 第五部分：验证查询
-- =====================================================

-- 查询贪吃蛇主题
SELECT 
  t.theme_id,
  t.theme_name,
  t.price,
  t.status,
  r.game_code,
  r.is_default
FROM theme_info t
INNER JOIN theme_game_relation r ON t.theme_id = r.theme_id
WHERE r.game_code = 'snake-vue3';

-- 查询植物大战僵尸主题
SELECT 
  t.theme_id,
  t.theme_name,
  t.price,
  t.status,
  r.game_code,
  r.is_default
FROM theme_info t
INNER JOIN theme_game_relation r ON t.theme_id = r.theme_id
WHERE r.game_code = 'plants-vs-zombie';

-- =====================================================
-- 完成提示
-- =====================================================
-- 执行此脚本后，创作者中心应该能查询到贪吃蛇和植物大战僵尸的主题
-- 如果游戏不存在，需要先在 t_game 表中添加游戏记录
