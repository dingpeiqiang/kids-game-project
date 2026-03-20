#!/usr/bin/env node

/**
 * 游戏资源批量生成脚本
 * 
 * 功能:
 * 1. 生成贪吃蛇游戏的图片资源 (蛇头、蛇身、食物等)
 * 2. 生成飞机大战游戏的图片资源 (玩家飞机、敌机、子弹等)
 * 3. 生成主题系统的示例图片
 * 
 * 使用方法:
 * node generate-resources.js
 */

const fs = require('fs');
const path = require('path');

// 检查是否安装了 canvas 库
let Canvas;
try {
  Canvas = require('canvas');
} catch (e) {
  console.error('❌ 需要安装 canvas 库才能运行此脚本');
  console.error('请执行：npm install canvas');
  console.error('\n或者使用浏览器生成器:');
  console.error('打开 kids-game-frontend/dist/generate-snake-shooter-assets.html');
  process.exit(1);
}

const { createCanvas, loadImage } = Canvas;

// 输出目录配置
const OUTPUT_DIR = path.join(__dirname, '..', 'kids-game-frontend', 'public', 'images', 'games');
const SNAKE_DIR = path.join(OUTPUT_DIR, 'snake-shooter');
const PLANE_DIR = path.join(OUTPUT_DIR, 'plane-shooter');
const THEMES_DIR = path.join(OUTPUT_DIR, 'themes');

// 确保目录存在
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
    console.log(`✅ 创建目录：${dir}`);
  }
}

// 保存 Canvas 为 PNG
function saveCanvas(canvas, filename, dir) {
  const filePath = path.join(dir, filename);
  const buffer = canvas.toBuffer('image/png');
  fs.writeFileSync(filePath, buffer);
  console.log(`✅ 生成：${filePath}`);
}

// ========== 贪吃蛇资源生成 ==========
function generateSnakeResources() {
  console.log('\n🐍 正在生成贪吃蛇资源...\n');
  
  ensureDir(SNAKE_DIR);
  
  // 1. 蛇头 (橙色，开心的表情)
  const snakeHeadHappy = createCanvas(64, 64);
  const ctx1 = snakeHeadHappy.getContext('2d');
  
  // 圆形头部
  ctx1.fillStyle = '#FF9800';
  ctx1.beginPath();
  ctx1.arc(32, 32, 28, 0, Math.PI * 2);
  ctx1.fill();
  
  // 眼睛
  ctx1.fillStyle = 'white';
  ctx1.beginPath();
  ctx1.arc(22, 24, 8, 0, Math.PI * 2);
  ctx1.arc(42, 24, 8, 0, Math.PI * 2);
  ctx1.fill();
  
  ctx1.fillStyle = 'black';
  ctx1.beginPath();
  ctx1.arc(24, 24, 4, 0, Math.PI * 2);
  ctx1.arc(44, 24, 4, 0, Math.PI * 2);
  ctx1.fill();
  
  // 微笑的嘴巴
  ctx1.strokeStyle = 'black';
  ctx1.lineWidth = 3;
  ctx1.beginPath();
  ctx1.arc(32, 32, 16, 0.1 * Math.PI, 0.9 * Math.PI);
  ctx1.stroke();
  
  saveCanvas(snakeHeadHappy, 'snake_orange_happy.png', SNAKE_DIR);
  
  // 2. 蛇头 (酷酷的表情)
  const snakeHeadCool = createCanvas(64, 64);
  const ctx2 = snakeHeadCool.getContext('2d');
  
  ctx2.fillStyle = '#4CAF50';
  ctx2.beginPath();
  ctx2.arc(32, 32, 28, 0, Math.PI * 2);
  ctx2.fill();
  
  // 墨镜眼睛
  ctx2.fillStyle = '#333';
  ctx2.fillRect(14, 20, 16, 10);
  ctx2.fillRect(34, 20, 16, 10);
  ctx2.fillRect(25, 24, 14, 4);
  
  // 直线嘴巴
  ctx2.strokeStyle = 'black';
  ctx2.lineWidth = 3;
  ctx2.beginPath();
  ctx2.moveTo(24, 44);
  ctx2.lineTo(40, 44);
  ctx2.stroke();
  
  saveCanvas(snakeHeadCool, 'snake_orange_cool.png', SNAKE_DIR);
  
  // 3. 蛇身体节
  const snakeBody = createCanvas(64, 64);
  const ctx3 = snakeBody.getContext('2d');
  
  ctx3.fillStyle = '#FF9800';
  ctx3.beginPath();
  ctx3.arc(32, 32, 26, 0, Math.PI * 2);
  ctx3.fill();
  
  // 渐变效果
  const gradient = ctx3.createRadialGradient(20, 20, 5, 32, 32, 26);
  gradient.addColorStop(0, '#FFB74D');
  gradient.addColorStop(1, '#F57C00');
  ctx3.fillStyle = gradient;
  ctx3.fill();
  
  saveCanvas(snakeBody, 'snake_body_segment.png', SNAKE_DIR);
  
  // 4. 食物 - 苹果
  const foodApple = createCanvas(48, 48);
  const ctx4 = foodApple.getContext('2d');
  
  // 苹果主体
  ctx4.fillStyle = '#E53935';
  ctx4.beginPath();
  ctx4.arc(24, 26, 18, 0, Math.PI * 2);
  ctx4.fill();
  
  // 苹果梗
  ctx4.fillStyle = '#795548';
  ctx4.fillRect(22, 6, 4, 8);
  
  // 叶子
  ctx4.fillStyle = '#4CAF50';
  ctx4.beginPath();
  ctx4.ellipse(28, 8, 8, 4, Math.PI / 4, 0, Math.PI * 2);
  ctx4.fill();
  
  // 高光
  ctx4.fillStyle = 'rgba(255,255,255,0.4)';
  ctx4.beginPath();
  ctx4.arc(18, 20, 5, 0, Math.PI * 2);
  ctx4.fill();
  
  saveCanvas(foodApple, 'food_apple.png', SNAKE_DIR);
  
  // 5. 食物 - 草莓
  const foodStrawberry = createCanvas(48, 48);
  const ctx5 = foodStrawberry.getContext('2d');
  
  // 草莓主体
  ctx5.fillStyle = '#E91E63';
  ctx5.beginPath();
  ctx5.moveTo(24, 44);
  ctx5.bezierCurveTo(8, 36, 4, 20, 24, 12);
  ctx5.bezierCurveTo(44, 20, 44, 36, 24, 44);
  ctx5.fill();
  
  // 草莓籽
  ctx5.fillStyle = '#FFEB3B';
  for (let i = 0; i < 8; i++) {
    const x = 16 + Math.random() * 16;
    const y = 20 + Math.random() * 16;
    ctx5.beginPath();
    ctx5.arc(x, y, 1.5, 0, Math.PI * 2);
    ctx5.fill();
  }
  
  // 草莓叶子
  ctx5.fillStyle = '#4CAF50';
  ctx5.beginPath();
  ctx5.moveTo(24, 12);
  ctx5.lineTo(18, 4);
  ctx5.lineTo(30, 4);
  ctx5.closePath();
  ctx5.fill();
  
  saveCanvas(foodStrawberry, 'food_strawberry.png', SNAKE_DIR);
  
  // 6. 粒子特效
  const particle = createCanvas(32, 32);
  const ctx6 = particle.getContext('2d');
  
  // 发光效果
  const gradient2 = ctx6.createRadialGradient(16, 16, 0, 16, 16, 16);
  gradient2.addColorStop(0, 'rgba(255, 235, 59, 1)');
  gradient2.addColorStop(0.5, 'rgba(255, 193, 7, 0.6)');
  gradient2.addColorStop(1, 'rgba(255, 193, 7, 0)');
  
  ctx6.fillStyle = gradient2;
  ctx6.fillRect(0, 0, 32, 32);
  
  saveCanvas(particle, 'particle_sparkle.png', SNAKE_DIR);
  
  // 7. 背景图
  const bgCanvas = createCanvas(800, 600);
  const ctx7 = bgCanvas.getContext('2d');
  
  // 渐变背景
  const bgGradient = ctx7.createLinearGradient(0, 0, 0, 600);
  bgGradient.addColorStop(0, '#1a237e');
  bgGradient.addColorStop(1, '#311b92');
  ctx7.fillStyle = bgGradient;
  ctx7.fillRect(0, 0, 800, 600);
  
  // 网格线
  ctx7.strokeStyle = 'rgba(255, 255, 255, 0.1)';
  ctx7.lineWidth = 1;
  const gridSize = 40;
  for (let x = 0; x <= 800; x += gridSize) {
    ctx7.beginPath();
    ctx7.moveTo(x, 0);
    ctx7.lineTo(x, 600);
    ctx7.stroke();
  }
  for (let y = 0; y <= 600; y += gridSize) {
    ctx7.beginPath();
    ctx7.moveTo(0, y);
    ctx7.lineTo(800, y);
    ctx7.stroke();
  }
  
  saveCanvas(bgCanvas, 'background_grid.png', SNAKE_DIR);
  
  console.log('✅ 贪吃蛇资源生成完成!\n');
}

// ========== 飞机大战资源生成 ==========
function generatePlaneResources() {
  console.log('\n✈️  正在生成飞机大战资源...\n');
  
  ensureDir(PLANE_DIR);
  
  // 1. 玩家飞机
  const playerPlane = createCanvas(80, 80);
  const ctx1 = playerPlane.getContext('2d');
  
  // 机身
  ctx1.fillStyle = '#2196F3';
  ctx1.beginPath();
  ctx1.moveTo(40, 0);
  ctx1.lineTo(70, 70);
  ctx1.lineTo(40, 60);
  ctx1.lineTo(10, 70);
  ctx1.closePath();
  ctx1.fill();
  
  // 机翼
  ctx1.fillStyle = '#1976D2';
  ctx1.beginPath();
  ctx1.moveTo(40, 20);
  ctx1.lineTo(80, 70);
  ctx1.lineTo(40, 60);
  ctx1.lineTo(0, 70);
  ctx1.closePath();
  ctx1.fill();
  
  // 驾驶舱
  ctx1.fillStyle = '#64B5F6';
  ctx1.beginPath();
  ctx1.ellipse(40, 30, 8, 15, 0, 0, Math.PI * 2);
  ctx1.fill();
  
  saveCanvas(playerPlane, 'player_plane_blue.png', PLANE_DIR);
  
  // 2. 敌机 - 红色
  const enemyPlane = createCanvas(70, 70);
  const ctx2 = enemyPlane.getContext('2d');
  
  // 机身 (倒三角形)
  ctx2.fillStyle = '#F44336';
  ctx2.beginPath();
  ctx2.moveTo(35, 70);
  ctx2.lineTo(70, 10);
  ctx2.lineTo(35, 20);
  ctx2.lineTo(0, 10);
  ctx2.closePath();
  ctx2.fill();
  
  // 机翼
  ctx2.fillStyle = '#D32F2F';
  ctx2.beginPath();
  ctx2.moveTo(35, 30);
  ctx2.lineTo(60, 0);
  ctx2.lineTo(35, 10);
  ctx2.lineTo(10, 0);
  ctx2.closePath();
  ctx2.fill();
  
  saveCanvas(enemyPlane, 'enemy_plane_red.png', PLANE_DIR);
  
  // 3. 子弹 - 玩家
  const bulletPlayer = createCanvas(20, 40);
  const ctx3 = bulletPlayer.getContext('2d');
  
  // 子弹主体
  ctx3.fillStyle = '#FFEB3B';
  ctx3.beginPath();
  ctx3.ellipse(10, 20, 8, 18, 0, 0, Math.PI * 2);
  ctx3.fill();
  
  // 弹头
  ctx3.fillStyle = '#FFF';
  ctx3.beginPath();
  ctx3.arc(10, 8, 6, 0, Math.PI * 2);
  ctx3.fill();
  
  saveCanvas(bulletPlayer, 'bullet_player.png', PLANE_DIR);
  
  // 4. 子弹 - 敌人
  const bulletEnemy = createCanvas(20, 40);
  const ctx4 = bulletEnemy.getContext('2d');
  
  ctx4.fillStyle = '#F44336';
  ctx4.beginPath();
  ctx4.ellipse(10, 20, 8, 18, 0, 0, Math.PI * 2);
  ctx4.fill();
  
  ctx4.fillStyle = '#FFCDD2';
  ctx4.beginPath();
  ctx4.arc(10, 32, 6, 0, Math.PI * 2);
  ctx4.fill();
  
  saveCanvas(bulletEnemy, 'bullet_enemy.png', PLANE_DIR);
  
  // 5. 爆炸效果
  const explosion = createCanvas(100, 100);
  const ctx5 = explosion.getContext('2d');
  
  // 爆炸中心
  const gradient = ctx5.createRadialGradient(50, 50, 0, 50, 50, 50);
  gradient.addColorStop(0, '#FFF');
  gradient.addColorStop(0.2, '#FFEB3B');
  gradient.addColorStop(0.4, '#FF9800');
  gradient.addColorStop(0.6, '#F44336');
  gradient.addColorStop(1, 'rgba(244, 67, 54, 0)');
  
  ctx5.fillStyle = gradient;
  ctx5.fillRect(0, 0, 100, 100);
  
  saveCanvas(explosion, 'explosion_effect.png', PLANE_DIR);
  
  // 6. 背景星空
  const bgSpace = createCanvas(800, 600);
  const ctx6 = bgSpace.getContext('2d');
  
  // 深蓝渐变
  const bgGradient = ctx6.createLinearGradient(0, 0, 0, 600);
  bgGradient.addColorStop(0, '#0a0e27');
  bgGradient.addColorStop(1, '#1a237e');
  ctx6.fillStyle = bgGradient;
  ctx6.fillRect(0, 0, 800, 600);
  
  // 随机星星
  ctx6.fillStyle = '#FFF';
  for (let i = 0; i < 200; i++) {
    const x = Math.random() * 800;
    const y = Math.random() * 600;
    const size = Math.random() * 2;
    ctx6.globalAlpha = Math.random() * 0.8 + 0.2;
    ctx6.fillRect(x, y, size, size);
  }
  ctx6.globalAlpha = 1;
  
  saveCanvas(bgSpace, 'background_space.png', PLANE_DIR);
  
  console.log('✅ 飞机大战资源生成完成!\n');
}

// ========== 主题资源生成 ==========
function generateThemeResources() {
  console.log('\n🎨 正在生成主题资源...\n');
  
  ensureDir(THEMES_DIR);
  
  // 1. 粉彩主题背景
  const pastelBg = createCanvas(400, 300);
  const ctx1 = pastelBg.getContext('2d');
  
  const gradient1 = ctx1.createLinearGradient(0, 0, 400, 300);
  gradient1.addColorStop(0, '#FFB6C1');
  gradient1.addColorStop(0.5, '#FFEFD5');
  gradient1.addColorStop(1, '#E6E6FA');
  ctx1.fillStyle = gradient1;
  ctx1.fillRect(0, 0, 400, 300);
  
  // 装饰圆圈
  ctx1.fillStyle = 'rgba(255, 255, 255, 0.3)';
  for (let i = 0; i < 10; i++) {
    const x = Math.random() * 400;
    const y = Math.random() * 300;
    const r = Math.random() * 30 + 10;
    ctx1.beginPath();
    ctx1.arc(x, y, r, 0, Math.PI * 2);
    ctx1.fill();
  }
  
  saveCanvas(pastelBg, 'pastel_background.png', THEMES_DIR);
  
  // 2. 按钮素材 - 主色
  const buttonPrimary = createCanvas(200, 60);
  const ctx2 = buttonPrimary.getContext('2d');
  
  // 圆角矩形
  ctx2.fillStyle = '#FF6B9D';
  ctx2.beginPath();
  ctx2.roundRect(0, 0, 200, 60, 12);
  ctx2.fill();
  
  // 高光
  ctx2.fillStyle = 'rgba(255, 255, 255, 0.2)';
  ctx2.fillRect(0, 0, 200, 30);
  
  saveCanvas(buttonPrimary, 'button_primary.png', THEMES_DIR);
  
  // 3. 按钮素材 - 辅助色
  const buttonSecondary = createCanvas(200, 60);
  const ctx3 = buttonSecondary.getContext('2d');
  
  ctx3.fillStyle = '#4ECDC4';
  ctx3.beginPath();
  ctx3.roundRect(0, 0, 200, 60, 12);
  ctx3.fill();
  
  ctx3.fillStyle = 'rgba(255, 255, 255, 0.2)';
  ctx3.fillRect(0, 0, 200, 30);
  
  saveCanvas(buttonSecondary, 'button_secondary.png', THEMES_DIR);
  
  // 4. 图标占位符
  const iconPlaceholder = createCanvas(64, 64);
  const ctx4 = iconPlaceholder.getContext('2d');
  
  ctx4.fillStyle = '#DDD';
  ctx4.beginPath();
  ctx4.arc(32, 32, 30, 0, Math.PI * 2);
  ctx4.fill();
  
  ctx4.fillStyle = '#AAA';
  ctx4.font = 'bold 36px Arial';
  ctx4.textAlign = 'center';
  ctx4.textBaseline = 'middle';
  ctx4.fillText('?', 32, 32);
  
  saveCanvas(iconPlaceholder, 'icon_placeholder.png', THEMES_DIR);
  
  console.log('✅ 主题资源生成完成!\n');
}

// ========== 主函数 ==========
function main() {
  console.log('🎮 游戏资源批量生成器');
  console.log('=' .repeat(50));
  console.log(`输出目录：${OUTPUT_DIR}\n`);
  
  try {
    generateSnakeResources();
    generatePlaneResources();
    generateThemeResources();
    
    console.log('=' .repeat(50));
    console.log('✅ 所有资源生成完成! 🎉\n');
    console.log('生成的资源可以直接用于:');
    console.log('  - 贪吃蛇游戏主题');
    console.log('  - 飞机大战游戏主题');
    console.log('  - 应用主题系统\n');
    
  } catch (error) {
    console.error('❌ 生成过程出错:', error);
    process.exit(1);
  }
}

// 运行生成器
main();
