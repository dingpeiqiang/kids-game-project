package com.kidgame.service.schedule;

import com.kidgame.dao.entity.Kid;
import com.kidgame.dao.mapper.KidMapper;
import com.kidgame.service.KidService;
import com.kidgame.service.StatsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 疲劳点定时任务
 */
@Slf4j
@Component
public class FatiguePointScheduler {

    @Autowired
    private KidMapper kidMapper;

    @Autowired
    private StatsService statsService;

    @Autowired
    private KidService kidService;

    @Value("${kidgame.fatigue.initial-points:10}")
    private Integer initialPoints;

    /**
     * 每日零点重置所有儿童的疲劳点
     * 执行时间: 每天 00:00:01
     */
    @Scheduled(cron = "1 0 0 * * ?")
    public void resetDailyFatiguePoints() {
        log.info("开始每日疲劳点重置任务, 时间: {}", LocalDateTime.now());

        try {
            List<Kid> allKids = kidMapper.selectList(null);
            int resetCount = 0;

            for (Kid kid : allKids) {
                try {
                    // 使用 kidService 重置疲劳点（会从 UserProfile 中读取和更新）
                    kidService.resetDailyFatiguePoints(kid.getKidId());
                    resetCount++;

                    if (log.isDebugEnabled()) {
                        log.debug("重置儿童疲劳点: KidId={}", kid.getKidId());
                    }
                } catch (Exception e) {
                    log.error("重置儿童疲劳点失败: KidId={}", kid.getKidId(), e);
                }
            }

            log.info("每日疲劳点重置完成, 共重置 {} 个儿童", resetCount);
        } catch (Exception e) {
            log.error("每日疲劳点重置失败", e);
        }
    }

    /**
     * 每分钟检查在线儿童的疲劳点
     * 执行时间: 每分钟执行一次
     */
    @Scheduled(fixedRate = 60000)
    public void checkFatiguePoints() {
        log.debug("开始检查儿童疲劳点, 时间: {}", LocalDateTime.now());

        try {
            List<Kid> allKids = kidMapper.selectList(null);

            for (Kid kid : allKids) {
                try {
                    // 通过 kidService 获取完整数据（包含从 UserProfile 读取的疲劳点）
                    Kid kidWithDetails = kidService.getById(kid.getKidId());
                    if (kidWithDetails.getFatiguePoints() != null && kidWithDetails.getFatiguePoints() <= 0) {
                        log.warn("儿童疲劳点不足: KidId={}, Points={}", kid.getKidId(), kidWithDetails.getFatiguePoints());

                        // TODO: 通过 WebSocket 推送消息到前端, 提示疲劳点不足
                        // WebSocketSessionManager.sendMessage(kid.getKidId(),
                        //     new WebSocketMessage("FATIGUE_POINTS_LOW", "疲劳点不足，请答题获取"));
                    }
                } catch (Exception e) {
                    log.error("检查儿童疲劳点失败: KidId={}", kid.getKidId(), e);
                }
            }
        } catch (Exception e) {
            log.error("检查儿童疲劳点失败", e);
        }
    }
}
