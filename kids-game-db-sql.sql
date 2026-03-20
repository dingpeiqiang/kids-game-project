-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: 106.54.7.205    Database: kidgame
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `creator_earnings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creator_earnings` (
  `earnings_id` bigint NOT NULL AUTO_INCREMENT COMMENT '收益记录 ID',
  `creator_id` bigint NOT NULL COMMENT '创作者 ID',
  `theme_id` bigint NOT NULL COMMENT '主题 ID',
  `amount` int NOT NULL COMMENT '金额',
  `status` varchar(20) DEFAULT 'pending' COMMENT '状态：pending/withdrawn',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `withdrawn_at` datetime DEFAULT NULL COMMENT '提现时间',
  PRIMARY KEY (`earnings_id`),
  KEY `idx_creator_id` (`creator_id`),
  KEY `idx_theme_id` (`theme_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='创作者收益表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_answer_record`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_answer_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '儿童用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `user_answer` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint DEFAULT NULL COMMENT '是否正确：0-错误，1-正确',
  `get_points` int DEFAULT '0' COMMENT '获得疲劳点',
  `answer_time` int DEFAULT '0' COMMENT '答题时间（秒）',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`record_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答题记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_blocked_game`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_blocked_game` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `kid_id` bigint NOT NULL COMMENT '儿童用户ID',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_kid_game` (`kid_id`,`game_id`,`deleted`),
  KEY `idx_kid_id` (`kid_id`),
  KEY `idx_game_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='屏蔽游戏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_daily_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_daily_stats` (
  `stat_id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `total_users` int DEFAULT '0' COMMENT '总用户数',
  `active_users` int DEFAULT '0' COMMENT '活跃用户数',
  `new_users` int DEFAULT '0' COMMENT '新增用户数',
  `total_game_duration` bigint DEFAULT '0' COMMENT '总游戏时长（秒）',
  `total_game_count` int DEFAULT '0' COMMENT '总游戏次数',
  `total_answer_count` int DEFAULT '0' COMMENT '总答题数',
  `correct_answer_count` int DEFAULT '0' COMMENT '答对数量',
  `total_fatigue_points` int DEFAULT '0' COMMENT '发放疲劳点总数',
  `total_consumed_points` int DEFAULT '0' COMMENT '消耗疲劳点总数',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`stat_id`),
  UNIQUE KEY `uk_stat_date` (`stat_date`,`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='每日统计表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_fatigue_points_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_fatigue_points_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NOT NULL COMMENT '儿童用户ID',
  `change_type` tinyint DEFAULT NULL COMMENT '变化类型：1-游戏消耗，2-答题获得，3-每日重置',
  `change_points` int DEFAULT NULL COMMENT '变化点数（正数增加，负数减少）',
  `current_points` int DEFAULT NULL COMMENT '变化后点数',
  `related_id` bigint DEFAULT NULL COMMENT '关联ID（如游戏会话ID、题目ID等）',
  `related_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联类型：GAME_SESSION-游戏会话，QUESTION-题目',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_change_type` (`change_type`)
) ENGINE=InnoDB AUTO_INCREMENT=500 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='疲劳点日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game` (
  `game_id` bigint NOT NULL AUTO_INCREMENT COMMENT '游戏ID',
  `game_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏编码',
  `game_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏分类：MATH-数学，LANGUAGE-语言，SCIENCE-科学，ART-艺术',
  `grade` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '适龄阶段',
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏图标URL',
  `cover_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏封面URL',
  `resource_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏资源CDN地址',
  `game_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏访问地址URL（独立部署时使用）',
  `game_secret` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游戏密钥（用于签名验证）',
  `game_config` json DEFAULT NULL COMMENT '游戏配置（透传给游戏的JSON配置）',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '游戏描述',
  `module_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '前端模块路径',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `consume_points_per_minute` int DEFAULT '1' COMMENT '每分钟消耗疲劳点数',
  `online_count` int DEFAULT '0' COMMENT '在线人数',
  `total_play_count` bigint DEFAULT '0' COMMENT '总游戏次数',
  `total_play_duration` bigint DEFAULT '0' COMMENT '总游戏时长（秒）',
  `average_rating` decimal(3,2) DEFAULT '0.00' COMMENT '平均评分',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`game_id`),
  UNIQUE KEY `game_code` (`game_code`),
  KEY `idx_category` (`category`),
  KEY `idx_grade` (`grade`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=667 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT,
  `game_id` bigint NOT NULL,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)),
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)),
  `deleted` tinyint DEFAULT '0',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_game_key` (`game_id`,`config_key`,`deleted`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_lock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_lock` (
  `lock_id` bigint NOT NULL AUTO_INCREMENT COMMENT '锁定ID',
  `game_id` bigint DEFAULT NULL COMMENT '游戏ID',
  `kid_id` bigint NOT NULL COMMENT '儿童ID',
  `reason` varchar(255) DEFAULT NULL COMMENT '锁定原因',
  `locked` int DEFAULT '1' COMMENT '是否锁定',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`lock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏锁定表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_mode_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_mode_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置 ID',
  `game_id` bigint NOT NULL COMMENT '游戏 ID',
  `mode_type` varchar(50) NOT NULL COMMENT '模式类型 (single_player/local_battle/team/online_battle)',
  `mode_name` varchar(100) DEFAULT NULL COMMENT '模式名称',
  `enabled` tinyint DEFAULT '1' COMMENT '是否启用 (0-禁用，1-启用)',
  `config_json` text COMMENT '模式配置 (JSON 格式)',
  `sort_order` int DEFAULT '0' COMMENT '排序权重',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_mode` (`game_id`,`mode_type`),
  KEY `idx_game_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏模式配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_permission` (
  `permission_id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（儿童）',
  `user_type` tinyint NOT NULL DEFAULT '0' COMMENT '用户类型：0-儿童，1-家长，2-管理员',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `resource_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GAME' COMMENT '资源类型：GAME-游戏，MODULE-模块，FEATURE-功能',
  `permission_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限类型：ALLOW-允许，BLOCK-屏蔽，LIMIT_TIME-限时，LIMIT_COUNT-限次',
  `time_limit_minutes` int DEFAULT NULL COMMENT '时间限制（分钟）',
  `count_limit` int DEFAULT NULL COMMENT '次数限制',
  `permission_params` json DEFAULT NULL COMMENT '限制参数（JSON）',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `uk_user_resource` (`user_id`,`user_type`,`resource_type`,`game_id`,`permission_type`,`deleted`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_permission_type` (`permission_type`),
  KEY `idx_user_type` (`user_type`),
  KEY `idx_resource_type` (`resource_type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_permission_backup_20240308`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_permission_backup_20240308` (
  `permission_id` bigint NOT NULL DEFAULT '0' COMMENT '权限ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（儿童）',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `permission_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限类型：ALLOW-允许，BLOCK-屏蔽，LIMIT_TIME-限时，LIMIT_COUNT-限次',
  `time_limit_minutes` int DEFAULT NULL COMMENT '时间限制（分钟）',
  `count_limit` int DEFAULT NULL COMMENT '次数限制',
  `permission_params` json DEFAULT NULL COMMENT '限制参数（JSON）',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_record`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '儿童用户ID',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `session_id` bigint DEFAULT NULL COMMENT '会话ID',
  `duration` bigint DEFAULT '0' COMMENT '游戏时长（秒）',
  `score` int DEFAULT '0' COMMENT '游戏分数',
  `consume_points` int DEFAULT '0' COMMENT '消耗疲劳点',
  `play_date` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '游玩日期（YYYY-MM-DD）',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`record_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_play_date` (`play_date`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_session`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_session` (
  `session_id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '儿童用户ID',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `session_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会话令牌（用于游戏验证）',
  `status` tinyint DEFAULT '1' COMMENT '会话状态：0-已结束，1-进行中，2-已暂停',
  `start_time` bigint DEFAULT NULL COMMENT '开始时间（毫秒时间戳）',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间（毫秒时间戳）',
  `duration` bigint DEFAULT '0' COMMENT '游玩时长（秒）',
  `score` int DEFAULT '0' COMMENT '获得分数',
  `consume_points` int DEFAULT '0' COMMENT '消耗疲劳点',
  `game_data` json DEFAULT NULL COMMENT '游戏数据（JSON）',
  `device_info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备信息',
  `client_version` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客户端版本',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `session_token` (`session_token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_session_token` (`session_token`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_tag`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_tag` (
  `tag_id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `tag_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'CATEGORY' COMMENT '标签类型：CATEGORY-分类，FEATURE-特性，RECOMMEND-推荐',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uk_tag_name_type` (`tag_name`,`tag_type`,`deleted`),
  KEY `idx_tag_type` (`tag_type`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_game_tag_relation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_game_tag_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_id` bigint NOT NULL COMMENT '游戏ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_tag` (`game_id`,`tag_id`,`deleted`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_kid`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_kid` (
  `kid_id` bigint NOT NULL AUTO_INCREMENT COMMENT '儿童ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '加密密码',
  `nickname` varchar(50) DEFAULT '小玩家' COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `grade` varchar(20) DEFAULT '1' COMMENT '学龄',
  `parent_id` bigint DEFAULT NULL COMMENT '绑定家长ID',
  `fatigue_points` int DEFAULT '10' COMMENT '当前疲劳点数',
  `device_id` varchar(100) DEFAULT NULL COMMENT '设备ID',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`kid_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='儿童用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_leaderboard_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_leaderboard_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置 ID',
  `game_id` bigint NOT NULL COMMENT '游戏 ID',
  `dimension_code` varchar(50) NOT NULL COMMENT '维度代码：SCORE/HIGHEST_LEVEL/DURATION/ACCURACY 等',
  `dimension_name` varchar(100) NOT NULL COMMENT '维度名称：如"最高分"/"最高关卡"/"最长时长"/"正确率"',
  `sort_order` varchar(10) NOT NULL DEFAULT 'DESC' COMMENT '排序方式：ASC-升序，DESC-降序',
  `data_type` varchar(20) NOT NULL DEFAULT 'INT' COMMENT '数据类型：INT/LONG/DECIMAL',
  `icon` varchar(50) DEFAULT NULL COMMENT '维度图标',
  `description` varchar(255) DEFAULT NULL COMMENT '维度描述',
  `is_enabled` int DEFAULT '1' COMMENT '是否启用：0-否，1-是',
  `display_order` int DEFAULT '0' COMMENT '显示顺序',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_game_dimension` (`game_id`,`dimension_code`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_enabled` (`is_enabled`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏排行榜配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_leaderboard_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_leaderboard_data` (
  `data_id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据 ID',
  `game_id` bigint NOT NULL COMMENT '游戏 ID',
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '头像 URL',
  `dimension_code` varchar(50) NOT NULL COMMENT '维度代码',
  `dimension_value` bigint NOT NULL COMMENT '维度值（统一用 BIGINT 存储，不同类型在应用层转换）',
  `decimal_value` decimal(10,2) DEFAULT '0.00' COMMENT '小数值（用于百分比等精度要求高的场景）',
  `rank_date` varchar(20) DEFAULT NULL COMMENT '排行日期（YYYY-MM-DD，用于日榜）',
  `rank_month` varchar(7) DEFAULT NULL COMMENT '排行月份（YYYY-MM，用于月榜）',
  `rank_year` varchar(4) DEFAULT NULL COMMENT '排行年份（YYYY，用于年榜）',
  `rank_type` varchar(20) DEFAULT 'ALL' COMMENT '排行类型：ALL-总榜，DAILY-日榜，MONTHLY-月榜，YEARLY-年榜',
  `extra_data` json DEFAULT NULL COMMENT '额外数据（用于存储通关时间、使用角色等扩展信息）',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`data_id`),
  UNIQUE KEY `uk_game_user_dimension_rank` (`game_id`,`user_id`,`dimension_code`,`rank_type`,`rank_date`,`rank_month`,`rank_year`),
  KEY `idx_game_dimension` (`game_id`,`dimension_code`),
  KEY `idx_game_dimension_value` (`game_id`,`dimension_code`,`dimension_value`),
  KEY `idx_user` (`user_id`),
  KEY `idx_rank_type` (`rank_type`),
  KEY `idx_rank_date` (`rank_date`),
  KEY `idx_rank_month` (`rank_month`),
  KEY `idx_rank_year` (`rank_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='游戏排行榜数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_leaderboard_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_leaderboard_dimension` (
  `dimension_id` bigint NOT NULL AUTO_INCREMENT,
  `game_id` bigint NOT NULL,
  `dimension_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dimension_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int DEFAULT '0',
  `data_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'INT',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)),
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)),
  `deleted` tinyint DEFAULT '0',
  PRIMARY KEY (`dimension_id`),
  UNIQUE KEY `uk_game_dimension` (`game_id`,`dimension_code`,`deleted`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_dimension_code` (`dimension_code`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_notification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_notification` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '接收者用户ID',
  `user_type` tinyint NOT NULL COMMENT '用户类型：0-儿童, 1-家长',
  `type` varchar(50) NOT NULL COMMENT '通知类型',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0-待处理, 1-已接受, 2-已拒绝, 3-已过期',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '通知状态：0-未读, 1-已读',
  `related_id` bigint DEFAULT NULL COMMENT '关联的数据ID',
  `sender_id` bigint DEFAULT NULL COMMENT '发送者ID',
  `sender_type` tinyint DEFAULT NULL COMMENT '发送者类型：0-儿童, 1-家长',
  `extra_data` json DEFAULT NULL COMMENT '扩展数据（JSON格式）',
  `create_time` bigint NOT NULL COMMENT '创建时间',
  `update_time` bigint NOT NULL COMMENT '更新时间',
  `expire_time` bigint DEFAULT NULL COMMENT '过期时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除, 1-已删除',
  PRIMARY KEY (`notification_id`),
  KEY `idx_user` (`user_id`,`user_type`),
  KEY `idx_status` (`status`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_parent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_parent` (
  `parent_id` bigint NOT NULL AUTO_INCREMENT COMMENT '家长ID',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `password` varchar(255) NOT NULL COMMENT '加密密码',
  `nickname` varchar(50) DEFAULT '家长' COMMENT '昵称',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `is_verified` int DEFAULT '0' COMMENT '实名认证状态',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`parent_id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='家长用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_parent_limit`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_parent_limit` (
  `limit_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `parent_id` bigint DEFAULT NULL COMMENT '家长ID',
  `kid_id` bigint NOT NULL COMMENT '儿童ID',
  `daily_duration` int DEFAULT '60' COMMENT '每日时长上限（分钟）',
  `single_duration` int DEFAULT '30' COMMENT '单次时长上限（分钟）',
  `allowed_time_start` varchar(10) DEFAULT '06:00' COMMENT '允许游戏开始时间',
  `allowed_time_end` varchar(10) DEFAULT '22:00' COMMENT '允许游戏结束时间',
  `answer_get_points` int DEFAULT '1' COMMENT '答对1题获得的疲劳点数',
  `daily_answer_limit` int DEFAULT '10' COMMENT '每日答题赚点上限',
  `blocked_games` text COMMENT '屏蔽的游戏ID列表（JSON数组）',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间',
  `deleted` int DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`limit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='家长管控规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_permission` (
  `permission_id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `permission_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限编码',
  `permission_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `permission_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'API' COMMENT '权限类型：MENU-菜单，BUTTON-按钮，API-接口',
  `parent_id` bigint DEFAULT '0' COMMENT '父权限ID',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路径/URL',
  `component` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件名称',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图标',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_code` (`permission_code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_permission_type` (`permission_type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_question`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_question` (
  `question_id` bigint NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `subject_id` bigint DEFAULT NULL COMMENT '学科ID',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目内容',
  `options` json DEFAULT NULL COMMENT '选项（JSON数组）',
  `correct_answer` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '正确答案',
  `analysis` text COLLATE utf8mb4_unicode_ci COMMENT '答案解析',
  `grade` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '适龄阶段',
  `type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'choice' COMMENT '题型：choice-选择，fill-填空，judgment-判断',
  `difficulty` tinyint DEFAULT '1' COMMENT '难度：1-5',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`question_id`),
  KEY `idx_subject_id` (`subject_id`),
  KEY `idx_grade` (`grade`),
  KEY `idx_type` (`type`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=862 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='题目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色编码',
  `role_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色描述',
  `role_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'CUSTOM' COMMENT '角色类型：SYSTEM-系统，CUSTOM-自定义',
  `data_scope` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'SELF' COMMENT '数据权限范围：ALL-全部，DEPT-部门，SELF-个人',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_code` (`role_code`),
  KEY `idx_status` (`status`),
  KEY `idx_role_type` (`role_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_role_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_role_permission` (
  `role_permission_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色权限ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`role_permission_id`),
  UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`,`deleted`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_subject`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_subject` (
  `subject_id` bigint NOT NULL AUTO_INCREMENT COMMENT '学科ID',
  `subject_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学科编码',
  `subject_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学科名称',
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '学科图标',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '学科描述',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`subject_id`),
  UNIQUE KEY `subject_code` (`subject_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学科表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_system_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_system_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` text COLLATE utf8mb4_unicode_ci COMMENT '配置值',
  `config_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'STRING' COMMENT '配置类型：STRING-字符串，INT-整数，JSON-JSON对象',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置描述',
  `config_group` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置分组 (fatigue/game/answer/system)',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `config_key` (`config_key`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_type` tinyint NOT NULL COMMENT '用户类型：0-儿童，1-家长，2-管理员',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '加密密码',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '昵称',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-正常，2-锁定',
  `fatigue_points` int DEFAULT '10' COMMENT '疲劳点数（所有用户类型通用）',
  `daily_answer_points` int DEFAULT '0' COMMENT '每日答题获得的疲劳点数',
  `fatigue_update_time` bigint DEFAULT NULL COMMENT '疲劳点最后更新时间（毫秒时间戳）',
  `account_expire_time` bigint DEFAULT NULL COMMENT '账号过期时间（毫秒时间戳）',
  `password_expire_time` bigint DEFAULT NULL COMMENT '密码过期时间（毫秒时间戳）',
  `last_login_time` bigint DEFAULT NULL COMMENT '最后登录时间（毫秒时间戳）',
  `last_login_ip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最后登录IP',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_username_type` (`username`,`user_type`),
  KEY `idx_user_type` (`user_type`),
  KEY `idx_status` (`status`),
  KEY `idx_fatigue_update_time` (`fatigue_update_time`),
  KEY `idx_fatigue_points` (`fatigue_points`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_user_control_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user_control_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `user_id` bigint NOT NULL COMMENT '儿童用户ID',
  `daily_time_limit_minutes` int DEFAULT NULL COMMENT '每日总时长限制（分钟）',
  `fatigue_point_minutes` int DEFAULT NULL COMMENT '疲劳点阈值（分钟）',
  `rest_duration_minutes` int DEFAULT NULL COMMENT '强制休息时长（分钟）',
  `fatigue_control_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'SOFT' COMMENT '疲劳控制模式：SOFT-软模式，HARD-硬模式，OFF-关闭',
  `allowed_start_time` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '允许开始时间 HH:mm:ss',
  `allowed_end_time` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '允许结束时间 HH:mm:ss',
  `daily_duration` int DEFAULT '60' COMMENT '每日时长上限（分钟，保留字段）',
  `single_duration` int DEFAULT '30' COMMENT '单次时长上限（分钟，保留字段）',
  `allowed_time_start` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '06:00' COMMENT '允许游戏开始时间（保留字段）',
  `allowed_time_end` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '22:00' COMMENT '允许游戏结束时间（保留字段）',
  `answer_get_points` int DEFAULT '1' COMMENT '答对1题获得的疲劳点数',
  `daily_answer_limit` int DEFAULT '10' COMMENT '每日答题赚点上限',
  `blocked_games` text COLLATE utf8mb4_unicode_ci COMMENT '屏蔽的游戏ID列表（JSON数组）',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_user_id` (`user_id`,`deleted`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户管控配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_user_profile`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user_profile` (
  `profile_id` bigint NOT NULL AUTO_INCREMENT COMMENT '扩展ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `profile_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '扩展类型：KID_INFO-儿童信息，PARENT_INFO-家长信息',
  `ext_info_json` json DEFAULT NULL COMMENT '扩展信息（JSON）',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `uk_user_type` (`user_id`,`profile_type`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户扩展信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_user_relation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user_relation` (
  `relation_id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系ID',
  `relation_type` tinyint NOT NULL COMMENT '关系类型：1-家长儿童，2-管理员儿童，3-兄弟姐妹',
  `user_a` bigint NOT NULL COMMENT '用户A（家长/管理员）',
  `user_b` bigint NOT NULL COMMENT '用户B（儿童）',
  `role_type` tinyint NOT NULL COMMENT '角色：1-父亲，2-母亲，3-监护人，4-辅导员',
  `is_primary` tinyint DEFAULT '0' COMMENT '是否主要监护人：0-否，1-是',
  `permission_level` tinyint DEFAULT '3' COMMENT '权限级别：1-仅查看，2-部分控制，3-完全控制',
  `status` tinyint DEFAULT '1' COMMENT '关系状态：0-待确认，1-已建立，2-已取消',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `update_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '更新时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `uk_user_a_b` (`user_a`,`user_b`,`relation_type`,`deleted`),
  KEY `idx_user_a` (`user_a`),
  KEY `idx_user_b` (`user_b`),
  KEY `idx_relation_type` (`relation_type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_user_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user_role` (
  `user_role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户角色ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` bigint DEFAULT ((unix_timestamp(now()) * 1000)) COMMENT '创建时间（毫秒时间戳）',
  `deleted` tinyint DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`user_role_id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`,`deleted`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theme_assets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_assets` (
  `asset_id` bigint NOT NULL AUTO_INCREMENT COMMENT '资产 ID',
  `theme_id` bigint NOT NULL COMMENT '主题 ID',
  `asset_key` varchar(100) NOT NULL COMMENT '资源键（如：bg_main）',
  `asset_type` varchar(20) NOT NULL COMMENT '资源类型：image/audio/font/other',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` int DEFAULT '0' COMMENT '文件大小（字节）',
  `file_hash` varchar(64) DEFAULT NULL COMMENT '文件哈希（用于去重）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`asset_id`),
  KEY `idx_theme_id` (`theme_id`),
  KEY `idx_asset_key` (`asset_key`),
  CONSTRAINT `fk_theme_assets_theme` FOREIGN KEY (`theme_id`) REFERENCES `theme_info` (`theme_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主题资源文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theme_game_relation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_game_relation` (
  `relation_id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系 ID',
  `theme_id` bigint NOT NULL COMMENT '主题 ID',
  `game_id` bigint NOT NULL COMMENT '游戏 ID',
  `game_code` varchar(50) NOT NULL COMMENT '游戏代码',
  `is_default` tinyint DEFAULT '0' COMMENT '是否为该游戏的默认主题：0-否，1-是',
  `sort_order` int DEFAULT '0' COMMENT '排序权重',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `uk_theme_game` (`theme_id`,`game_id`) COMMENT '同一主题对同一游戏只能有一条关系',
  KEY `idx_game_id` (`game_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_is_default` (`is_default`),
  CONSTRAINT `fk_theme_game_theme` FOREIGN KEY (`theme_id`) REFERENCES `theme_info` (`theme_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主题 - 游戏关系表（多对多）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theme_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_info` (
  `theme_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主题 ID',
  `author_id` bigint NOT NULL COMMENT '作者 ID',
  `owner_type` varchar(20) NOT NULL DEFAULT 'APPLICATION' COMMENT '所有者类型：GAME-游戏，APPLICATION-应用',
  `owner_id` bigint DEFAULT NULL COMMENT '所有者 ID(游戏 ID 或应用 ID)',
  `theme_name` varchar(100) NOT NULL COMMENT '主题名称',
  `author_name` varchar(50) DEFAULT NULL COMMENT '作者名称',
  `price` int DEFAULT '0' COMMENT '价格（游戏币）',
  `status` varchar(20) DEFAULT 'pending' COMMENT '状态：on_sale/offline/pending',
  `download_count` int DEFAULT '0' COMMENT '下载次数',
  `total_revenue` int DEFAULT '0' COMMENT '总收益',
  `thumbnail_url` varchar(500) DEFAULT NULL COMMENT '缩略图 URL',
  `description` text COMMENT '描述',
  `config_json` json NOT NULL COMMENT '主题配置（包含资源/样式）',
  `is_default` tinyint DEFAULT '0' COMMENT '是否为默认主题：0-否，1-是',
  `applicable_scope` varchar(50) DEFAULT 'all' COMMENT '适用范围：all-全游戏/specific-指定游戏',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`theme_id`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_status` (`status`),
  KEY `idx_applicable_scope` (`applicable_scope`),
  KEY `idx_owner_type` (`owner_type`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_is_default` (`is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主题信息表（独立）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theme_purchase`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme_purchase` (
  `purchase_id` bigint NOT NULL AUTO_INCREMENT COMMENT '购买记录 ID',
  `theme_id` bigint NOT NULL COMMENT '主题 ID',
  `buyer_id` bigint NOT NULL COMMENT '购买者 ID',
  `price_paid` int NOT NULL COMMENT '支付价格',
  `purchase_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间',
  `is_refunded` tinyint DEFAULT '0' COMMENT '是否已退款：0-否，1-是',
  PRIMARY KEY (`purchase_id`),
  UNIQUE KEY `uk_theme_buyer` (`theme_id`,`buyer_id`),
  KEY `idx_theme_id` (`theme_id`),
  KEY `idx_buyer_id` (`buyer_id`),
  KEY `idx_purchase_time` (`purchase_time`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主题购买记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'kidgame'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-18  9:41:14
