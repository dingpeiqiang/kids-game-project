-- 删除飞机大战和染色体游戏
-- 这两个游戏已从项目中移除

-- 删除飞机大战
DELETE FROM t_game WHERE game_code = 'PLANE_SHOOTER';

-- 删除染色体游戏
DELETE FROM t_game WHERE game_code = 'CHROMOSOME';

-- 删除相关的排行榜数据（如果有）
DELETE FROM t_game_ranking WHERE game_code = 'PLANE_SHOOTER';
DELETE FROM t_game_ranking WHERE game_code = 'CHROMOSOME';

-- 验证删除结果
SELECT '删除后剩余的游戏:' AS info;
SELECT game_id, game_code, game_name, category, game_url, status
FROM t_game
ORDER BY sort_order;

SELECT '只保留以下1个实际可运行的游戏:' AS info;
SELECT game_id, game_code, game_name, category, game_url, status
FROM t_game
WHERE game_code = 'SNAKE_VUE3'
ORDER BY sort_order;
