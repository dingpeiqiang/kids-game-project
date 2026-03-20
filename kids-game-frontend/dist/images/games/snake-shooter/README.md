# Snake Shooter 卡通素材使用指南

## 📁 生成的卡通素材

### 1. 炮台素材
- **文件名**: `turret.png`
- **尺寸**: 120x120px
- **特色**: 
  - 可爱的绿色圆形炮台
  - 带有笑脸表情和腮红
  - 立体阴影和高光效果
  - 包含底座和炮管

### 2. 蛇关节素材 (25个)
**5种颜色 × 5种表情**

#### 颜色变种
- `pink` - 粉色系 (F472B6)
- `purple` - 紫色系 (A78BFA)
- `blue` - 蓝色系 (60A5FA)
- `orange` - 橙色系 (FB923C)
- `yellow` - 黄色系 (FBBF24)

#### 表情变种
- `happy` - 开心表情 (^^)
- `surprised` - 惊讶表情 (OO)
- `cool` - 酷酷表情 (><)
- `angry` - 愤怒表情
- `shy` - 害羞表情 (_)

**命名格式**: `snake_{color}_{expression}.png`
- 例如: `snake_pink_happy.png`
- 例如: `snake_blue_angry.png`

**特色**:
- 60x60px 圆形关节
- 渐变色彩效果
- 可爱的卡通眼睛和嘴巴
- 高光和阴影立体效果
- 腮红装饰

### 3. 子弹素材
- **文件名**: `bullet.png`
- **尺寸**: 40x40px
- **特色**:
  - 金黄色五角星形状
  - 发光效果
  - 中心高亮点

### 4. 粒子特效素材 (3个)
- **文件名**: `particle_explosion.png` - 爆炸效果 (火焰色)
- **文件名**: `particle_sparkle.png` - 闪光效果 (白色十字闪光)
- **文件名**: `particle_smoke.png` - 烟雾效果 (灰色渐变)
- **尺寸**: 20x20px

### 5. 游戏封面
- **文件名**: `cover.jpg`
- **尺寸**: 400x200px
- **特色**:
  - 蓝天白云背景
  - 草地波浪装饰
  - 卡通炮台和蛇
  - 彩虹底部装饰
  - "打蛇解压"标题

---

## 🎮 在游戏中使用卡通素材

### 方案1: 直接替换 Phaser 绘制代码 (推荐)

#### 1.1 在 `SnakeShooterScene.ts` 中加载素材

在 `preload()` 方法中添加：

```typescript
async preload() {
  // 加载炮台
  this.load.image('turret', '/images/games/snake-shooter/turret.png');
  
  // 加载蛇关节 (加载所有颜色和表情)
  const snakeColors = ['pink', 'purple', 'blue', 'orange', 'yellow'];
  const expressions = ['happy', 'surprised', 'cool', 'angry', 'shy'];
  
  snakeColors.forEach(color => {
    expressions.forEach(exp => {
      const key = `snake_${color}_${exp}`;
      const path = `/images/games/snake-shooter/snake_${color}_${exp}.png`;
      this.load.image(key, path);
    });
  });
  
  // 加载子弹
  this.load.image('bullet', '/images/games/snake-shooter/bullet.png');
  
  // 加载粒子特效
  this.load.image('particle_explosion', '/images/games/snake-shooter/particle_explosion.png');
  this.load.image('particle_sparkle', '/images/games/snake-shooter/particle_sparkle.png');
  this.load.image('particle_smoke', '/images/games/snake-shooter/particle_smoke.png');
}
```

#### 1.2 替换炮台绘制代码

在 `createTurret()` 方法中：

```typescript
private createTurret(): void {
  const { width, height } = this.scale;
  this.turretY = height - 60;
  
  const turretX = width / 2;
  
  // 使用卡通炮台图片
  const turretSprite = this.add.image(turretX, this.turretY, 'turret');
  turretSprite.setDepth(50);
  
  // 保存炮台引用
  this.turret = {
    sprite: turretSprite,  // 改为 sprite
    body: turretSprite,    // 保持兼容
    barrel: turretSprite,  // 保持兼容
    angle: -Math.PI / 2,
    isDragging: false,
  };
}
```

#### 1.3 替换蛇关节绘制代码

在 `spawnSnake()` 方法中：

```typescript
private spawnSnake(level: number): void {
  // 清空现有蛇
  this.snakeJoints.forEach(joint => {
    if (joint.hpText) joint.hpText.destroy();
    if (joint.hpBar) joint.hpBar.destroy();
    if (joint.hpBarBg) joint.hpBarBg.destroy();
    joint.sprite.destroy();
  });
  this.snakeJoints = [];

  const jointCount = this.calculateJointCount(level);
  const jointHp = this.levelConfig.jointHp;
  
  // 随机选择颜色和表情
  const snakeColors = ['pink', 'purple', 'blue', 'orange', 'yellow'];
  const expressions = ['happy', 'surprised', 'cool', 'angry', 'shy'];
  
  const startX = 50;
  const startY = 100;
  const spacing = 30;

  for (let i = 0; i < jointCount; i++) {
    const x = startX + i * spacing;
    const y = startY;
    
    // 随机选择颜色和表情
    const color = snakeColors[Math.floor(Math.random() * snakeColors.length)];
    const exp = expressions[Math.floor(Math.random() * expressions.length)];
    const textureKey = `snake_${color}_${exp}`;
    
    // 使用卡通蛇关节图片
    const jointSprite = this.add.image(x, y, textureKey);
    jointSprite.setDepth(40);
    
    // 创建关节对象
    const joint: SnakeJoint = {
      sprite: jointSprite,  // 改为 sprite
      currentHp: jointHp,
      maxHp: jointHp,
      index: i,
      isBroken: false,
    };
    
    // 添加血量文本
    this.addHpTextToJoint(joint);
    
    // 添加动态血条
    this.addHpBarToJoint(joint, jointHp);
    
    this.snakeJoints.push(joint);
  }
}
```

#### 1.4 替换子弹绘制代码

在 `fireBullet()` 方法中：

```typescript
private fireBullet(): void {
  const { width, height } = this.scale;
  
  const fireX = this.turret.sprite.x;  // 改为 sprite.x
  const fireY = this.turret.sprite.y - 30;
  
  // 使用卡通子弹图片
  const bulletSprite = this.add.image(fireX, fireY, 'bullet');
  bulletSprite.setScale(0.8);  // 调整大小
  bulletSprite.setDepth(45);
  
  const direction = new Phaser.Math.Vector2(
    Math.cos(this.turret.angle),
    Math.sin(this.turret.angle)
  );
  
  const bullet: Bullet = {
    sprite: bulletSprite,  // 改为 sprite
    direction,
    speed: 300,
    damage: 2,
    isActive: true,
  };
  
  this.activeBullets.push(bullet);
}
```

#### 1.5 更新 `updateBullets()` 方法

```typescript
private updateBullets(delta: number): void {
  const deltaSeconds = delta / 1000;
  
  for (let i = this.activeBullets.length - 1; i >= 0; i--) {
    const bullet = this.activeBullets[i];
    
    if (!bullet.isActive) continue;
    
    // 更新位置 (使用 sprite.x, sprite.y)
    bullet.sprite.x += bullet.direction.x * bullet.speed * deltaSeconds;
    bullet.sprite.y += bullet.direction.y * bullet.speed * deltaSeconds;
    
    // 检查是否出界
    if (
      bullet.sprite.x < 0 ||
      bullet.sprite.x > this.scale.width ||
      bullet.sprite.y < 0 ||
      bullet.sprite.y > this.scale.height
    ) {
      this.removeBullet(i);
    }
  }
}
```

#### 1.6 更新 `updateSnake()` 方法

```typescript
private updateSnake(delta: number): void {
  const deltaSeconds = delta / 1000;
  
  this.wavePhase += this.snakeMoveSpeed * deltaSeconds * 0.01;
  
  this.snakeJoints.forEach((joint, index) => {
    if (joint.isBroken) return;
    
    const waveOffset = Math.sin(this.wavePhase + index * 0.2) * this.waveAmplitude;
    
    // 使用 sprite.x, sprite.y
    joint.sprite.x += this.snakeDirection * this.snakeMoveSpeed * deltaSeconds;
    joint.sprite.y = 100 + waveOffset;
    
    if (joint.sprite.x <= 20 || joint.sprite.x >= this.scale.width - 20) {
      this.snakeDirection *= -1;
    }
  });
}
```

#### 1.7 更新碰撞检测

```typescript
private checkCollisions(): void {
  for (let i = this.activeBullets.length - 1; i >= 0; i--) {
    const bullet = this.activeBullets[i];
    if (!bullet.isActive) continue;
    
    for (let j = 0; j < this.snakeJoints.length; j++) {
      const joint = this.snakeJoints[j];
      if (joint.isBroken) continue;
      
      // 简单的圆形碰撞检测
      const dx = bullet.sprite.x - joint.sprite.x;
      const dy = bullet.sprite.y - joint.sprite.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      if (distance < 25) {  // 调整碰撞半径
        this.hitJoint(joint, bullet.damage);
        this.particleSystem?.playHitEffect(joint.sprite.x, joint.sprite.y);
        this.removeBullet(i);
        break;
      }
    }
  }
  
  const headJoint = this.snakeJoints.find(j => !j.isBroken);
  if (headJoint) {
    const dx = headJoint.sprite.x - this.turret.sprite.x;  // 改为 sprite.x
    const dy = headJoint.sprite.y - this.turret.sprite.y;    // 改为 sprite.y
    const distance = Math.sqrt(dx * dx + dy * dy);
    
    if (distance < 50) {  // 调整碰撞半径
      this.handleGameOver();
    }
  }
}
```

---

### 方案2: 保留原有代码，仅添加素材作为装饰

如果想保留现有的 Phaser 绘制代码，可以将卡通素材作为装饰元素添加到场景中：

```typescript
async create() {
  // ... 原有代码 ...
  
  // 在炮台位置添加装饰性的卡通炮台
  const decorativeTurret = this.add.image(
    this.scale.width / 2, 
    this.scale.height - 60, 
    'turret'
  );
  decorativeTurret.setScale(0.5);  // 缩小作为装饰
  decorativeTurret.setAlpha(0.3);  // 半透明
  decorativeTurret.setDepth(5);
  
  // 在蛇的位置添加装饰性的卡通蛇
  this.snakeJoints.forEach((joint, index) => {
    if (index % 3 === 0) {  // 每3个关节添加一个装饰
      const color = ['pink', 'purple', 'blue', 'orange', 'yellow'][index % 5];
      const exp = ['happy', 'surprised', 'cool', 'angry', 'shy'][index % 5];
      
      const decorativeSnake = this.add.image(
        joint.sprite.x, 
        joint.sprite.y, 
        `snake_${color}_${exp}`
      );
      decorativeSnake.setScale(0.3);
      decorativeSnake.setAlpha(0.2);
      decorativeSnake.setDepth(3);
    }
  });
}
```

---

## 🎨 自定义素材

### 修改颜色

编辑 `generate-snake-shooter-cartoon-assets.js` 中的 `cartoonColors` 对象：

```javascript
const cartoonColors = {
    turret: {
        base: '#YOUR_COLOR',        // 改为你喜欢的颜色
        highlight: '#YOUR_HIGHLIGHT',
        shadow: '#YOUR_SHADOW',
        detail: '#YOUR_DETAIL'
    },
    // ... 其他颜色
};
```

### 修改表情

编辑 `cartoonExpressions` 对象添加新表情：

```javascript
const cartoonExpressions = {
    // ... 现有表情
    excited: { eyes: 'OO', mouth: 'D' },
    sleepy: { eyes: '- -', mouth: '_' }
};
```

### 重新生成素材

```bash
node generate-snake-shooter-cartoon-assets.js
```

---

## 📊 素材统计

| 类别 | 数量 | 文件名格式 |
|------|------|-----------|
| 炮台 | 1 | turret.png |
| 蛇关节 | 25 | snake_{color}_{expression}.png |
| 子弹 | 1 | bullet.png |
| 粒子特效 | 3 | particle_{type}.png |
| 游戏封面 | 1 | cover.jpg |
| **总计** | **31** | - |

---

## 🚀 快速开始

### 1. 使用方案1（推荐）替换所有图形

复制上述代码，逐步替换 `SnakeShooterScene.ts` 中的绘制方法。

### 2. 测试运行

```bash
cd kids-game-frontend
npm run dev
```

### 3. 查看效果

打开浏览器访问游戏页面，应该能看到卡通风格的蛇、炮台和子弹。

---

## 📝 注意事项

1. **路径问题**: 确保素材路径正确，从 `/images/games/snake-shooter/` 开始
2. **性能**: 如果游戏卡顿，可以减少同时加载的蛇关节图片数量
3. **尺寸调整**: 根据 Phaser 场景的实际尺寸，可能需要调整图片的 `setScale()`
4. **碰撞检测**: 使用图片后，可能需要调整碰撞半径
5. **血条位置**: 使用图片后，血条和血量文本的位置可能需要微调

---

## 🎯 优化建议

1. **预加载优化**: 可以只预加载当前关卡需要的蛇关节图片
2. **内存管理**: 如果游戏关卡很长，可以动态加载和卸载蛇关节图片
3. **动画效果**: 可以在图片加载完成后添加淡入、弹跳等动画效果
4. **关卡设计**: 
   - 低关卡使用单色、快乐表情的蛇
   - 高关卡使用多色、愤怒表情的蛇
   - 增加视觉变化和难度提示

---

## 💡 创意扩展

### 1. 关卡主题化

```typescript
// 每个关卡使用不同颜色的蛇
const levelColors = {
  1: 'pink',
  2: 'blue',
  3: 'purple',
  4: 'orange',
  5: 'yellow'
};

// 在 spawnSnake 中使用
const color = levelColors[level] || 'pink';
```

### 2. 生命值影响表情

```typescript
// 根据生命值改变蛇的表情
let getExpressionByHp = function(hpPercent: number) {
  if (hpPercent > 0.6) return 'happy';
  if (hpPercent > 0.3) return 'surprised';
  return 'angry';
};

// 在 hitJoint 中动态更换表情
const newExp = getExpressionByHp(joint.currentHp / joint.maxHp);
joint.sprite.setTexture(`snake_${color}_${newExp}`);
```

### 3. 粒子特效组合

```typescript
// 击中时播放组合特效
playHitEffect(x: number, y: number) {
  // 闪光
  this.add.image(x, y, 'particle_sparkle').setScale(2);
  
  // 烟雾
  for (let i = 0; i < 3; i++) {
    const smoke = this.add.image(
      x + (Math.random() - 0.5) * 20,
      y + (Math.random() - 0.5) * 20,
      'particle_smoke'
    );
    smoke.setAlpha(0.6);
  }
  
  // 爆炸
  this.add.image(x, y, 'particle_explosion').setScale(1.5);
}
```

---

## 📞 技术支持

如果遇到问题：
1. 检查浏览器控制台是否有加载错误
2. 确认文件路径是否正确
3. 检查 Phaser 版本兼容性
4. 查看网络请求是否成功加载图片

---

## 🎉 完成！

现在你的 Snake Shooter 游戏拥有了可爱的卡通风格素材！
