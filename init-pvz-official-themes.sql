-- =====================================================
-- 植物大战僵尸官方主题初始化脚本
-- =====================================================

-- 1. 插入植物大战僵尸官方主题：阳光活力（默认主题）
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

-- 2. 插入植物大战僵尸官方主题：月夜幽深
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

-- 3. 插入植物大战僵尸官方主题：卡通萌系
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
-- 创建主题-游戏关联关系
-- is_default 在 theme_game_relation 表中设置
-- =====================================================

-- 关联主题到植物大战僵尸游戏
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
-- 验证查询
-- =====================================================

-- 查询所有植物大战僵尸主题
SELECT 
  t.theme_id,
  t.theme_name,
  t.price,
  t.status,
  r.game_code,
  r.is_default
FROM theme_info t
INNER JOIN theme_game_relation r ON t.theme_id = r.theme_id
WHERE r.game_code = 'plants-vs-zombie'
ORDER BY t.theme_id;
