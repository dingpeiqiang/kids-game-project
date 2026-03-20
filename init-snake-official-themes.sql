-- =====================================================
-- 贪吃蛇官方主题初始化脚本
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
-- 创建主题-游戏关联关系
-- is_default 在 theme_game_relation 表中设置
-- =====================================================

-- 关联主题到贪吃蛇游戏
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

-- =====================================================
-- 验证查询
-- =====================================================

-- 查询所有贪吃蛇主题
SELECT 
  t.theme_id,
  t.theme_name,
  t.price,
  t.status,
  r.game_code,
  r.is_default
FROM theme_info t
INNER JOIN theme_game_relation r ON t.theme_id = r.theme_id
WHERE r.game_code = 'snake-vue3'
ORDER BY t.theme_id;
