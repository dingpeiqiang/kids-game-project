<template>
  <div class="theme-diy-page">
    <!-- 顶部导航栏 -->
    <BaseHeader
      variant="kids"
      :showThemeSwitcher="false"
      :showBack="true"
      :username="username"
      :avatar="userAvatar"
      :user-role="userRole"
      @back="handleBack"
    >
      <template #left>
        <button class="back-btn" @click="handleBack" title="返回创作者中心">
          <span class="back-icon">←</span>
          <span class="back-text">返回创作者中心</span>
        </button>
      </template>
      <template #center>
        <h1 class="page-title">
          <span class="title-icon">✨</span>
          <span>主题创作</span>
        </h1>
      </template>
    </BaseHeader>

    <!-- 主内容区域 -->
    <main class="diy-content">
      <!-- ⭐ 数据加载完成后显示内容 -->
      <template v-if="themeTemplate">
        <!-- 步骤指示器 -->
      <div class="create-steps">
        <div
          v-for="(step, index) in createSteps"
          :key="step.id"
          :class="['create-step', { active: currentStep === step.id, completed: isStepCompleted(step.id) }]"
        >
          <div class="step-number">{{ index + 1 }}</div>
          <div class="step-info">
            <h4 class="step-title">{{ step.title }}</h4>
            <p class="step-description">{{ step.description }}</p>
          </div>
        </div>
      </div>

      <!-- 步骤内容 -->
      <div class="step-content-wrapper">
        <!-- 基本信息 -->
        <div v-if="currentStep === 'info'" class="step-content info-step">
          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">🏷️</span>
              主题名称 <span class="required">*</span>
            </label>
            <input
              v-model="themeData.name"
              type="text"
              placeholder="输入主题名称"
              class="form-input"
              maxlength="50"
            />
            <div class="form-hint">{{ themeData.name.length }}/50 字符</div>
          </div>

          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">👤</span>
              作者名称 <span class="required">*</span>
            </label>
            <input
              v-model="themeData.author"
              type="text"
              placeholder="输入作者名称"
              class="form-input"
              maxlength="30"
            />
          </div>

          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">📝</span>
              主题描述
            </label>
            <textarea
              v-model="themeData.description"
              placeholder="描述你的主题特点..."
              class="form-textarea"
              rows="4"
              maxlength="200"
            ></textarea>
            <div class="form-hint">{{ themeData.description.length }}/200 字符</div>
          </div>

          <div class="form-group">
            <label class="form-label">
              <span class="label-icon">💰</span>
              定价（趣乐币）
            </label>
            <input
              v-model.number="themeData.price"
              type="number"
              min="0"
              max="9999"
              class="form-input"
              placeholder="0 表示免费"
            />
            <div class="form-hint">
              <span v-if="themeData.price === 0">✓ 免费主题</span>
              <span v-else>付费主题：{{ themeData.price }} 趣乐币</span>
            </div>
          </div>
        </div>

        <!-- 样式配置 -->
        <div v-else-if="currentStep === 'styles'" class="step-content styles-step">
          <div class="style-editor">
            <!-- 实时预览 -->
            <div class="style-preview-section">
              <h3 class="preview-title">🎨 实时预览</h3>
              <div class="preview-container" :style="previewContainerStyle">
                <div class="preview-card" :style="previewCardStyle">
                  <h4 class="preview-heading" :style="{ color: themeStyles.color_text }">
                    {{ themeData.name || '主题预览' }}
                  </h4>
                  <p class="preview-text" :style="{ color: themeStyles.color_text_secondary }">
                    这是一个主题预览示例
                  </p>
                  <button class="preview-btn primary" :style="primaryBtnStyle">
                    主要按钮
                  </button>
                  <button class="preview-btn secondary" :style="secondaryBtnStyle">
                    次要按钮
                  </button>
                </div>
              </div>
            </div>

            <!-- 颜色配置 -->
            <div class="style-controls">
              <div class="style-section">
                <h3 class="section-title">
                  <span class="title-icon">🎨</span>
                  颜色配置
                </h3>
                <div class="color-grid">
                  <div v-for="colorKey in colorKeys" :key="colorKey" class="color-field">
                    <label class="color-label">{{ formatLabel(colorKey) }}</label>
                    <div class="color-input-wrapper">
                      <input
                        v-model="themeStyles[colorKey]"
                        type="color"
                        class="color-picker"
                      />
                      <input
                        v-model="themeStyles[colorKey]"
                        type="text"
                        class="color-text-input"
                        placeholder="#000000"
                      />
                    </div>
                  </div>
                </div>
              </div>

              <!-- 尺寸配置 -->
              <div class="style-section">
                <h3 class="section-title">
                  <span class="title-icon">📐</span>
                  尺寸配置
                </h3>
                <div class="size-grid">
                  <div v-for="sizeKey in sizeKeys" :key="sizeKey" class="size-field">
                    <label class="size-label">{{ formatLabel(sizeKey) }}</label>
                    <input
                      v-model="themeStyles[sizeKey]"
                      type="text"
                      class="size-input"
                      placeholder="8px"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 资源上传 -->
        <div v-else-if="currentStep === 'assets'" class="step-content assets-step">
          <!-- 游戏主题信息提示 -->
          <div v-if="gameCode && currentGameConfig" class="game-info-banner">
            <span class="game-info-icon">🎮</span>
            <span class="game-info-text">游戏主题：{{ currentGameConfig.gameName }}</span>
          </div>

          <!-- 未指定游戏（应用主题） -->
          <div v-else-if="!gameCode" class="error-banner">
            <span class="error-icon">❌</span>
            <span class="error-text">错误：缺少游戏代码 (gameCode)，请从创作者中心选择游戏后进入</span>
          </div>

          <!-- 游戏不支持的情况 -->
          <div v-else-if="currentGameConfig && !currentGameConfig.supportsCustomTheme" class="warning-banner">
            <span class="warning-icon">⚠️</span>
            <span class="warning-text">游戏 {{ gameCode }} 不支持自定义主题，请返回选择其他游戏</span>
          </div>

          <div class="assets-grid" v-if="themeTemplate">
            <!-- 图片资源 -->
            <div class="asset-section">
              <h3 class="section-title">
                <span class="title-icon">🖼️</span>
                图片资源 ({{ imageAssetKeys.length }})
              </h3>
              <div class="asset-list">
                <div v-for="imgKey in imageAssetKeys" :key="imgKey" class="asset-item">
                  <div class="asset-preview-box">
                    <img
                      v-if="themeAssets[imgKey]"
                      :src="themeAssets[imgKey]"
                      class="asset-preview-img"
                    />
                    <div v-else class="asset-placeholder">
                      <span class="placeholder-icon">🖼️</span>
                    </div>
                  </div>
                  <div class="asset-info">
                    <span class="asset-name">
                      {{ getImageAssetConfig(imgKey)?.label || formatLabel(imgKey) }}
                      <span v-if="getImageAssetConfig(imgKey)?.required" class="required-mark">*</span>
                    </span>
                    <span class="asset-size-hint">
                      建议尺寸：{{ getAssetSizeHint(imgKey) }}
                    </span>
                    <p v-if="getImageAssetConfig(imgKey)?.description" class="asset-description">
                      {{ getImageAssetConfig(imgKey)?.description }}
                    </p>
                  </div>
                  <div class="asset-actions">
                    <label class="btn-upload">
                      <input
                        type="file"
                        accept="image/*"
                        @change="(e) => handleAssetUpload(imgKey, e)"
                        class="hidden-input"
                      />
                      <span>上传</span>
                    </label>
                    <button
                      v-if="themeAssets[imgKey]"
                      class="btn-remove"
                      @click="removeAsset(imgKey)"
                    >
                      删除
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 音效资源 -->
            <div class="asset-section">
              <h3 class="section-title">
                <span class="title-icon">🎵</span>
                音效资源 ({{ audioAssetKeys.length }})
              </h3>
              <div class="asset-list">
                <div v-for="audioKey in audioAssetKeys" :key="audioKey" class="asset-item">
                  <div class="asset-preview-box audio">
                    <span class="audio-icon">🎵</span>
                  </div>
                  <div class="asset-info">
                    <span class="asset-name">
                      {{ getAudioAssetConfig(audioKey)?.label || formatLabel(audioKey) }}
                      <span v-if="getAudioAssetConfig(audioKey)?.required" class="required-mark">*</span>
                    </span>
                    <span v-if="getAudioAssetConfig(audioKey)" class="asset-size-hint">
                      建议时长：{{ getAudioAssetConfig(audioKey)?.specs?.duration || '自定义' }}
                    </span>
                    <p v-if="getAudioAssetConfig(audioKey)?.description" class="asset-description">
                      {{ getAudioAssetConfig(audioKey)?.description }}
                    </p>
                    <span v-if="themeAssets[audioKey]" class="asset-status">已上传</span>
                  </div>
                  <div class="asset-actions">
                    <label class="btn-upload">
                      <input
                        type="file"
                        accept="audio/*"
                        @change="(e) => handleAssetUpload(audioKey, e)"
                        class="hidden-input"
                      />
                      <span>上传</span>
                    </label>
                    <button
                      v-if="themeAssets[audioKey]"
                      class="btn-play"
                      @click="playAudio(audioKey)"
                    >
                      试听
                    </button>
                    <button
                      v-if="themeAssets[audioKey]"
                      class="btn-remove"
                      @click="removeAsset(audioKey)"
                    >
                      删除
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 发布设置 -->
        <div v-else-if="currentStep === 'publish'" class="step-content publish-step">
          <div class="publish-preview">
            <h3 class="section-title">📦 发布预览</h3>

            <div class="preview-theme-card">
              <div class="preview-thumbnail" :style="previewThumbnailStyle">
                <span class="preview-icon">✨</span>
              </div>
              <div class="preview-details">
                <h4 class="preview-name">{{ themeData.name || '未命名主题' }}</h4>
                <p class="preview-author">作者：{{ themeData.author || '未知' }}</p>
                <p class="preview-desc">{{ themeData.description || '暂无描述' }}</p>
                <div class="preview-meta">
                  <span class="preview-price">
                    {{ themeData.price > 0 ? `${themeData.price} 趣乐币` : '免费' }}
                  </span>
                  <span class="preview-base-theme">基于：{{ baseThemeName || '默认主题' }}</span>
                </div>
              </div>
            </div>

            <div class="publish-options">
              <div class="option-group">
                <label class="option-checkbox">
                  <input
                    v-model="publishConfig.saveLocally"
                    type="checkbox"
                  />
                  <span class="checkmark"></span>
                  <span class="option-text">保存到本地</span>
                </label>
                <p class="option-desc">保存主题到本地库，方便后续编辑</p>
              </div>

              <div class="option-group">
                <label class="option-checkbox">
                  <input
                    v-model="publishConfig.publishToStore"
                    type="checkbox"
                  />
                  <span class="checkmark"></span>
                  <span class="option-text">发布到商店</span>
                </label>
                <p class="option-desc">将主题发布到主题商店，其他用户可以购买或下载</p>
              </div>

              <div v-if="publishConfig.publishToStore" class="option-group">
                <label class="option-label">发布状态</label>
                <select v-model="publishConfig.status" class="form-input">
                  <option value="draft">保存为草稿</option>
                  <option value="on_sale">立即上架销售</option>
                </select>
              </div>
            </div>

            <div class="publish-summary">
              <div class="summary-item">
                <span class="summary-label">颜色配置：</span>
                <span class="summary-value">{{ Object.keys(themeStyles).filter(k => k.includes('color')).length }} 项</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">资源文件：</span>
                <span class="summary-value">{{ Object.keys(themeAssets).length }} 个</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 底部导航 -->
      <div class="step-navigation">
        <button
          v-if="currentStep !== 'info'"
          class="btn-nav btn-prev"
          @click="prevStep"
        >
          <span class="nav-icon">←</span>
          上一步
        </button>

        <div class="nav-spacer"></div>

        <button
          v-if="currentStep !== 'publish'"
          class="btn-nav btn-next"
          @click="nextStep"
          :disabled="!canProceed"
        >
          下一步
          <span class="nav-icon">→</span>
        </button>

        <button
          v-if="currentStep === 'publish'"
          class="btn-nav btn-publish"
          @click="handlePublish"
          :disabled="!canPublish || isPublishing"
        >
          <span v-if="isPublishing" class="loading-spinner"></span>
          <span v-else>{{ publishConfig.publishToStore ? '发布主题' : '保存主题' }}</span>
        </button>
      </div>
      </template>
      
      <!-- ⭐ 加载状态提示 -->
      <div v-else class="loading-container">
        <div class="loading-spinner">
          <span class="loading-icon">⏳</span>
          <p class="loading-text">正在加载主题配置...</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import BaseHeader from '@/components/layout/BaseHeader.vue';
import { useUserStore } from '@/core/store';
import { themeManager } from '@/core/theme/ThemeManager';
import type { DiyThemeData } from '@/core/theme/ThemeManager';
import { 
  loadGameThemeTemplate, 
  convertTemplateToDIYFormat, 
  type ThemeTemplate,
  type ResourceConfig,
  validateResource,
  getSupportedGames
} from '@/utils/themeTemplateLoader';
import { dialog, useConfirm } from '@/composables/useDialog';
import { themeApi } from '@/services';

// 游戏配置接口
interface GameAssetConfig {
  gameCode: string;
  gameName: string;
  [key: string]: any;
}

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

// 获取用户信息
const username = computed(() => userStore.parentUsername || '用户');
const userRole = computed(() => '家长');
const userAvatar = computed(() => userStore.parentAvatar || '👨‍👩‍👧');

// 从路由参数获取（只接受 themeId，其他都从数据库加载）
const themeId = ref<number>(Number(route.query.themeId)); // ⭐ 唯一必需参数
const gameId = ref<number | undefined>(); // 游戏 ID（数据库关联用）
const gameCode = ref<string>(''); // 游戏代码（资源加载用）
const baseThemeKey = ref<string>('default');
const baseThemeName = ref<string>('');
const themeTemplate = ref<ThemeTemplate | null>(null);
const templateLoading = ref(false);

// 获取游戏配置
const currentGameConfig = ref<GameAssetConfig | null>(null);

// 检查游戏是否支持
const isGameValid = computed(() => {
  if (!themeId.value) return false;
  // 有主题 ID 就认为有效
  return true;
});

// 步骤配置
const createSteps = [
  { id: 'info', title: '基本信息', description: '设置主题名称和基本信息' },
  { id: 'styles', title: '样式配置', description: '配置主题颜色和样式' },
  { id: 'assets', title: '资源上传', description: '上传图片和音效资源' },
  { id: 'publish', title: '发布设置', description: '确认信息并发布' },
];

const currentStep = ref('info');
const isPublishing = ref(false);

// 主题数据 - ⭐ 初始值为空，在 onMounted 中从原主题复制
const themeData = reactive({
  name: '',
  author: '',
  description: '',
  price: 0,
  baseThemeKey: baseThemeKey.value,
});

// 样式配置 - ⭐ 初始值为默认模板，在 onMounted 中从原主题复制覆盖
const themeStyles = reactive<Record<string, string>>({
  color_primary: '#4ECDC4',
  color_secondary: '#45B7D1',
  color_background: '#FFFFFF',
  color_text: '#333333',
  color_text_secondary: '#666666',
  color_border: '#E0E0E0',
  color_card_bg: '#F5F5F5',
  border_radius_btn: '8px',
  border_radius_card: '12px',
});

// 资源文件 - ⭐ 初始为空，在 onMounted 中从原主题复制
const themeAssets = reactive<Record<string, string>>({});

// 发布配置
const publishConfig = reactive({
  saveLocally: true,
  publishToStore: false,
  status: 'draft' as 'draft' | 'on_sale',
});

// 资源键
const colorKeys = computed(() =>
  Object.keys(themeStyles).filter(k => k.startsWith('color_'))
);

const sizeKeys = computed(() =>
  Object.keys(themeStyles).filter(k => k.includes('radius'))
);

// 根据游戏资源模板获取资源键
const imageAssetKeys = computed(() => {
  // ⭐ 必须确保 themeTemplate 已正确初始化
  if (!themeTemplate.value?.resources?.images) {
    console.error('[ThemeDIY] ❌ 主题模板未正确初始化或没有资源配置');
    throw new Error('主题模板资源配置缺失，请确保主题数据已正确加载');
  }
  return Object.keys(themeTemplate.value.resources.images);
});

const audioAssetKeys = computed(() => {
  // ⭐ 必须确保 themeTemplate 已正确初始化
  if (!themeTemplate.value?.resources?.audio) {
    console.error('[ThemeDIY] ❌ 主题模板未正确初始化或没有音频配置');
    throw new Error('主题模板音频配置缺失，请确保主题数据已正确加载');
  }
  return Object.keys(themeTemplate.value.resources.audio);
});

// 获取图片资源配置
const getImageAssetConfig = (key: string): ResourceConfig | null => {
  if (!themeTemplate.value?.resources?.images) {
    return null;
  }
  return themeTemplate.value.resources.images[key] || null;
};

// 获取音频资源配置
const getAudioAssetConfig = (key: string): ResourceConfig | null => {
  if (!themeTemplate.value?.resources?.audio) {
    return null;
  }
  return themeTemplate.value.resources.audio[key] || null;
};

// 游戏资源模板（从后端 API 加载）
async function getGameAssetConfig(code: string): Promise<GameAssetConfig | null> {
  if (!code) return null;
  
  try {
    // ⭐ 使用统一 API 服务
    const { gameApi } = await import('@/services');
    const result = await gameApi.getThemeTemplate(code);
    
    if (result) {
      return {
        gameCode: code,
        gameName: (result as any).gameName || code,
        template: result
      };
    }
    
    return { gameCode: code, gameName: code };
  } catch (error) {
    console.error(`[ThemeDIY] 无法加载游戏 ${code} 的模板:`, error);
    await dialog.error(`无法加载游戏模板：${error instanceof Error ? error.message : '未知错误'}`, { title: '加载失败' });
    return null;
  }
}

// 检查游戏是否支持（有模板即支持）
function isGameSupported(code: string): boolean {
  // 这个函数会在加载模板后被调用
  return !!code && !!currentGameConfig.value;
}

// 预览样式
const previewContainerStyle = computed(() => ({
  backgroundColor: themeStyles.color_background,
}));

const previewCardStyle = computed(() => ({
  backgroundColor: themeStyles.color_card_bg,
  borderRadius: themeStyles.border_radius_card,
}));

const primaryBtnStyle = computed(() => ({
  backgroundColor: themeStyles.color_primary,
  borderRadius: themeStyles.border_radius_btn,
}));

const secondaryBtnStyle = computed(() => ({
  backgroundColor: themeStyles.color_secondary,
  borderRadius: themeStyles.border_radius_btn,
}));

const previewThumbnailStyle = computed(() => ({
  background: `linear-gradient(135deg, ${themeStyles.color_primary} 0%, ${themeStyles.color_secondary} 100%)`,
}));

// 表单验证
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 'info':
      return themeData.name.trim() !== '' && themeData.author.trim() !== '';
    case 'styles':
      return true;
    case 'assets':
      return true;
    default:
      return true;
  }
});

const canPublish = computed(() => {
  return themeData.name.trim() !== '' &&
         themeData.author.trim() !== '' &&
         (publishConfig.saveLocally || publishConfig.publishToStore);
});

// 步骤完成状态
function isStepCompleted(stepId: string): boolean {
  const steps = createSteps.map(s => s.id);
  const currentIndex = steps.indexOf(currentStep.value);
  const stepIndex = steps.indexOf(stepId);
  return stepIndex < currentIndex;
}

// 格式化标签
function formatLabel(key: string): string {
  return key
    .replace(/_/g, ' ')
    .replace(/\b\w/g, l => l.toUpperCase());
}

// 获取资源尺寸提示
function getAssetSizeHint(key: string): string {
  // 优先从模板获取
  const imageConfig = getImageAssetConfig(key);
  if (imageConfig?.specs?.width && imageConfig?.specs?.height) {
    return `${imageConfig.specs.width}x${imageConfig.specs.height}`;
  }
  
  // 回退到默认值
  const hints: Record<string, string> = {
    bg_image: '1920x1080',
    logo_image: '256x256',
    icon_image: '64x64',
    snakeHead: '64x64',
    snakeBody: '64x64',
    snakeTail: '64x64',
    food: '32x32',
    background: '800x600',
    grid: '64x64',
    player: '64x64',
    enemy: '64x64',
    projectile: '32x32',
    sun: '48x48',
    ground: '800x400'
  };
  return hints[key] || '自定义';
}

// 处理资源上传
async function handleAssetUpload(key: string, event: Event): Promise<void> {
  const input = event.target as HTMLInputElement;
  const file = input.files?.[0];
  if (!file) return;

  // 验证资源是否符合模板要求
  const config = getImageAssetConfig(key) || getAudioAssetConfig(key);
  if (config) {
    const validation = validateResource(key, file, config);
    if (!validation.valid) {
      await dialog.error(validation.error || '资源验证失败');
      input.value = '';
      return;
    }
    if (validation.warning) {
      console.warn(`[ThemeDIY] ${validation.warning}`);
    }
  }

  const reader = new FileReader();
  reader.onload = (e) => {
    const result = e.target?.result as string;
    themeAssets[key] = result;
  };
  reader.readAsDataURL(file);
}

// 删除资源
function removeAsset(key: string): void {
  delete themeAssets[key];
}

// 播放音频
function playAudio(key: string): void {
  const src = themeAssets[key];
  if (!src) return;

  const audio = new Audio(src);
  audio.play();
}

// 上一步
function prevStep(): void {
  const steps = createSteps.map(s => s.id);
  const currentIndex = steps.indexOf(currentStep.value);
  if (currentIndex > 0) {
    currentStep.value = steps[currentIndex - 1];
  }
}

// 下一步
function nextStep(): void {
  if (!canProceed.value) return;

  const steps = createSteps.map(s => s.id);
  const currentIndex = steps.indexOf(currentStep.value);
  if (currentIndex < steps.length - 1) {
    currentStep.value = steps[currentIndex + 1];
  }
}

// 返回
async function handleBack(): Promise<void> {
  if (currentStep.value !== 'info') {
    const confirmed = await useConfirm({ message: '确定要返回吗？当前步骤的内容将不会保存。', title: '确认返回' });
    if (confirmed) router.back();
  } else {
    router.back();
  }
}

// 发布主题
async function handlePublish(): Promise<void> {
  if (!canPublish.value || isPublishing.value) return;

  isPublishing.value = true;

  try {
    const themeDataToSave: DiyThemeData = {
      baseThemeKey: themeData.baseThemeKey,
      name: themeData.name,
      author: themeData.author,
      description: themeData.description,
      assetOverrides: { ...themeAssets },
      styleOverrides: { ...themeStyles },
      createdAt: Date.now(),
      updatedAt: Date.now(),
    };

    if (publishConfig.saveLocally) {
      await themeManager.addLocalDiyTheme(themeDataToSave);
      console.log('[ThemeDIYPage] Theme saved locally');
    }

    if (publishConfig.publishToStore) {
      // ⭐ 直接构建 GTRS 格式的配置，绕过 ThemeManager 的旧格式
      const gtrsConfig = buildGTRSConfig();
      await themeApi.upload({
        name: themeData.name,
        author: themeData.author,
        price: themeData.price,
        description: themeData.description,
        config: gtrsConfig
      });
    }

    await dialog.success('主题发布成功！');
    router.push('/creator-center');
  } catch (error) {
    console.error('[ThemeDIYPage] Publish failed:', error);
    await dialog.error('发布失败，请重试');
  } finally {
    isPublishing.value = false;
  }
}

/**
 * ⭐ 构建 GTRS 格式的主题配置，自动生成 providedResources 字段
 */
function buildGTRSConfig(): any {
  // 从原始主题模板获取 GTRS 结构
  const originalTemplate = themeTemplate.value;

  if (!originalTemplate || !originalTemplate.resources) {
    throw new Error('主题模板不存在或缺少 resources 字段');
  }

  // 构建 GTRS 配置
  const gtrsConfig = {
    specMeta: {
      specName: 'GTRS',
      specVersion: '1.0.0',
      compatibleVersion: '1.0.0'
    },
    themeInfo: {
      themeId: `diy_${Date.now()}`,
      gameId: gameId.value ? gameId.value.toString() : 'game_snake_v3',
      themeName: themeData.name,
      isDefault: false,
      author: themeData.author,
      description: themeData.description
    },
    globalStyle: {
      ...themeStyles
    },
    resources: {
      images: {
        login: {},
        scene: {},
        ui: {},
        icon: {},
        effect: {}
      },
      audio: {
        bgm: {},
        effect: {},
        voice: {}
      },
      video: {}
    }
  };

  // 收集实际提供的资源
  const providedImages: any = {
    login: [],
    scene: [],
    ui: [],
    icon: [],
    effect: []
  };
  const providedAudio: any = {
    bgm: [],
    effect: [],
    voice: []
  };

  // 处理图片资源
  for (const [key, value] of Object.entries(themeAssets)) {
    // 判断是图片还是音频
    if (typeof value === 'string' && (value.endsWith('.png') || value.endsWith('.jpg') || value.endsWith('.webp'))) {
      // 图片资源
      let category: string;
      if (key.startsWith('bg_') || key.includes('snake') || key.includes('food') || key.includes('obstacle')) {
        category = 'scene';
        providedImages.scene.push(key);
        gtrsConfig.resources.images.scene[key] = {
          src: value,
          type: value.endsWith('.png') ? 'png' : value.endsWith('.jpg') ? 'jpg' : 'webp',
          alias: key
        };
      } else if (key.startsWith('ui_') || key.includes('button') || key.includes('panel')) {
        category = 'ui';
        providedImages.ui.push(key);
        gtrsConfig.resources.images.ui[key] = {
          src: value,
          type: value.endsWith('.png') ? 'png' : value.endsWith('.jpg') ? 'jpg' : 'webp',
          alias: key
        };
      } else if (key.startsWith('icon_')) {
        category = 'icon';
        providedImages.icon.push(key);
        gtrsConfig.resources.images.icon[key] = {
          src: value,
          type: value.endsWith('.png') ? 'png' : value.endsWith('.jpg') ? 'jpg' : 'webp',
          alias: key
        };
      } else {
        category = 'effect';
        providedImages.effect.push(key);
        gtrsConfig.resources.images.effect[key] = {
          src: value,
          type: value.endsWith('.png') ? 'png' : value.endsWith('.jpg') ? 'jpg' : 'webp',
          alias: key
        };
      }
    } else if (typeof value === 'string' && (value.endsWith('.mp3') || value.endsWith('.ogg') || value.endsWith('.wav'))) {
      // 音频资源
      let category: string;
      if (key.startsWith('bgm_')) {
        category = 'bgm';
        providedAudio.bgm.push(key);
        gtrsConfig.resources.audio.bgm[key] = {
          src: value,
          type: value.endsWith('.mp3') ? 'mp3' : value.endsWith('.ogg') ? 'ogg' : 'wav',
          volume: 0.7,
          alias: key
        };
      } else if (key.startsWith('sfx_') || key.startsWith('effect_')) {
        category = 'effect';
        providedAudio.effect.push(key);
        gtrsConfig.resources.audio.effect[key] = {
          src: value,
          type: value.endsWith('.mp3') ? 'mp3' : value.endsWith('.ogg') ? 'ogg' : 'wav',
          volume: 0.8,
          alias: key
        };
      } else {
        category = 'voice';
        providedAudio.voice.push(key);
        gtrsConfig.resources.audio.voice[key] = {
          src: value,
          type: value.endsWith('.mp3') ? 'mp3' : value.endsWith('.ogg') ? 'ogg' : 'wav',
          volume: 0.9,
          alias: key
        };
      }
    }
  }

  // ⭐ 自动生成 providedResources 字段
  gtrsConfig.themeInfo.providedResources = {
    images: providedImages,
    audio: providedAudio
  };

  console.log('[ThemeDIYPage] 生成的 GTRS 配置:', gtrsConfig);
  console.log('[ThemeDIYPage] providedResources:', gtrsConfig.themeInfo.providedResources);

  return gtrsConfig;
}

// 初始化
onMounted(async () => {
  // ⭐ 验证 themeId（必需参数）
  if (!themeId.value) {
    throw new Error('[ThemeDIY] 缺少主题 ID 参数');
  }

  templateLoading.value = true;
  try {
    // 1. 加载主题详情（包含 gameId 和 gameCode）
    const theme = await themeApi.getDetail(themeId.value.toString());
    
    console.log('[ThemeDIY] 原始主题数据:', theme);
    
    // ⭐ 明确分工：gameId 用于数据库操作，gameCode 用于资源加载
    gameId.value = theme.gameId;           // 数据库关联备用
    gameCode.value = theme.gameCode || ''; // 资源加载必需
    baseThemeKey.value = theme.key || 'default';
    baseThemeName.value = theme.name || theme.themeName || ''; // ✅ 兼容 themeName 字段
    
    // ⭐ 验证：gameCode 是资源加载的必需条件
    if (!gameCode.value) {
      const errorMsg = `主题未关联游戏（缺少 gameCode）\n主题 ID: ${themeId.value}\n主题名称：${baseThemeName.value}`;
      console.error('[ThemeDIY]', errorMsg);
      throw new Error(errorMsg);
    }
    
    // ⭐ 验证：主题必须包含 configJson
    if (!theme.configJson) {
      const errorMsg = `主题配置不存在\n主题 ID: ${themeId.value}\n请确保主题已正确配置资源模板`;
      console.error('[ThemeDIY]', errorMsg);
      throw new Error(errorMsg);
    }
    
    // ============================================
    // ⭐⭐⭐ 步骤 1：基本信息 - 从原主题复制 ⭐⭐⭐
    // ============================================
    themeData.name = `${theme.themeName || baseThemeName.value} - DIY 版`;
    themeData.author = theme.authorName || userStore.parentUsername || '';
    themeData.description = theme.description || `基于"${baseThemeName.value}"的个性化定制`;
    themeData.price = theme.price || 0;
    themeData.baseThemeKey = baseThemeKey.value;
    
    console.log('[ThemeDIY] ✅ 步骤 1 已复制:', {
      name: themeData.name,
      author: themeData.author,
      description: themeData.description,
      price: themeData.price
    });
    
    // ============================================
    // ⭐⭐⭐ 步骤 2：样式配置 - 从 config_json 复制 ⭐⭐⭐
    // ============================================
    if (theme.configJson) {
      // ⭐ 适配旧结构：configJson.default.styles.colors
      const defaultConfig = theme.configJson.default || theme.configJson;
      
      // 从 styles.colors 中提取颜色值
      if (defaultConfig.styles?.colors) {
        // 将 { primary: '#xxx', secondary: '#xxx' } 转换为 { color_primary: '#xxx', ... }
        const colorsMap: Record<string, string> = {
          primary: 'color_primary',
          secondary: 'color_secondary',
          background: 'color_background',
          surface: 'color_card_bg',
          text: 'color_text',
          accent: 'color_border'
        };
        
        Object.entries(defaultConfig.styles.colors).forEach(([key, value]) => {
          const mappedKey = colorsMap[key];
          if (mappedKey && value) {
            themeStyles[mappedKey] = value as string;
          }
        });
        
        console.log('[ThemeDIY] ✅ 步骤 2 样式已复制:', themeStyles);
      } else {
        console.warn('[ThemeDIY] ⚠️ 原主题没有样式配置，使用默认');
      }
    }
    
    // ============================================
    // ⭐⭐⭐ 步骤 3：资源上传 - 从 config_json 复制 ⭐⭐⭐
    // ============================================
    if (theme.configJson) {
      // ⭐ 重要：将 configJson 转换为 ThemeTemplate 格式
      // configJson 结构：{ default: { assets: {...}, audio: {...} } }
      // ThemeTemplate 结构：{ resources: { images: {...}, audio: {...} } }
      
      const defaultConfig = theme.configJson.default || theme.configJson;
      
      // 构建主题模板
      themeTemplate.value = {
        version: defaultConfig.version || '1.0.0',
        gameCode: gameCode.value,
        gameName: currentGameConfig.value?.gameName || '',
        gameVersion: '1.0.0',
        resources: {
          // ⭐ 将 assets 转换为 images
          images: defaultConfig.assets || {},
          // 音频保持原名
          audio: defaultConfig.audio || {},
          // 颜色和配置（如果有）
          colors: defaultConfig.styles?.colors || {},
          configs: {}
        },
        metadata: {
          author: defaultConfig.author,
          createdAt: defaultConfig.createdAt,
          updatedAt: defaultConfig.updatedAt
        }
      };
      
      console.log('[ThemeDIY] ✅ 主题模板已转换:', themeTemplate.value);
      
      // 复制图片资源
      if (themeTemplate.value.resources.images) {
        Object.assign(themeAssets, themeTemplate.value.resources.images);
        console.log('[ThemeDIY] ✅ 图片资源已复制:', 
          Object.keys(themeTemplate.value.resources.images).length, '个');
      }
      // 复制音频资源
      if (themeTemplate.value.resources.audio) {
        Object.assign(themeAssets, themeTemplate.value.resources.audio);
        console.log('[ThemeDIY] ✅ 音频资源已复制:', 
          Object.keys(themeTemplate.value.resources.audio).length, '个');
      }
    } else {
      console.warn('[ThemeDIY] ⚠️ 原主题没有资源配置');
    }
    
    // ⭐ 直接使用主题的 configJson 作为模板（用于后续资源验证）
    themeTemplate.value = theme.configJson;
    console.log('[ThemeDIY] ✅ 主题模板已加载:', {
      templateVersion: theme.configJson.version,
      gameCode: theme.configJson.gameCode,
      resourcesCount: Object.keys(theme.configJson.resources || {}).length
    });
    
    // 3. 加载主题的完整配置（资源和样式）- 用于编辑已有主题
    await loadExistingTheme(themeId.value);
    
  } catch (error) {
    console.error('[ThemeDIY] 初始化失败:', error);
    await dialog.error(`加载失败：${error instanceof Error ? error.message : '未知错误'}`);
    router.push('/creator-center');
  } finally {
    templateLoading.value = false;
  }
});

// 加载已有主题的配置
async function loadExistingTheme(themeId: number) {
  try {
    // 使用 download 接口获取主题完整配置
    const result = await themeApi.download(themeId.toString());
    
    if (result && result.config) {
      const theme = result.config;
      
      // 填充基本信息
      themeData.name = `${theme.name || baseThemeName.value} - DIY 版`;
      themeData.author = userStore.parentUsername || '';
      themeData.description = theme.description || `基于"${baseThemeName.value}"的个性化主题`;
      themeData.price = 0;
      
      console.log('[ThemeDIY] 主题配置加载成功');
    }
  } catch (error) {
    console.warn('[ThemeDIY] 加载主题配置失败，可能是新主题:', error);
    // 新主题不需要加载已有配置
  }
}
</script>

<style scoped>
.theme-diy-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  display: flex;
  flex-direction: column;
}

/* 返回按钮 */
.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid rgba(78, 205, 196, 0.3);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.back-btn:hover {
  background: white;
  border-color: #4ECDC4;
  transform: translateX(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.2);
}

.back-icon {
  font-size: 20px;
  color: #4ECDC4;
  font-weight: bold;
}

.back-text {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

/* 页面标题 */
.page-title {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #333;
}

.title-icon {
  font-size: 28px;
}

/* 主内容区 */
.diy-content {
  flex: 1;
  padding: 24px;
  max-width: 1000px;
  margin: 0 auto;
  width: 100%;
}

/* 步骤指示器 */
.create-steps {
  display: flex;
  justify-content: center;
  gap: 40px;
  padding: 32px;
  background: white;
  border-radius: 16px;
  margin-bottom: 24px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  position: relative;
}

.create-steps::before {
  content: '';
  position: absolute;
  top: 52px;
  left: 20%;
  right: 20%;
  height: 2px;
  background: #e0e0e0;
  z-index: 0;
}

.create-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  z-index: 1;
}

.step-number {
  width: 40px;
  height: 40px;
  background: #f0f0f0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
  color: #999;
  margin-bottom: 12px;
  transition: all 0.3s;
  border: 2px solid #e0e0e0;
}

.create-step.active .step-number {
  background: #4ECDC4;
  color: white;
  border-color: #4ECDC4;
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
}

.create-step.completed .step-number {
  background: #42b983;
  color: white;
  border-color: #42b983;
}

.step-info {
  text-align: center;
}

.step-title {
  margin: 0 0 4px 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.step-description {
  margin: 0;
  font-size: 12px;
  color: #888;
  max-width: 120px;
}

/* 步骤内容 */
.step-content-wrapper {
  margin-bottom: 24px;
}

.step-content {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

/* 表单样式 */
.form-group {
  margin-bottom: 24px;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.label-icon {
  font-size: 16px;
}

.required {
  color: #ff6b6b;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.2s;
  background: #fafafa;
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #4ECDC4;
  background: white;
  box-shadow: 0 0 0 4px rgba(78, 205, 196, 0.1);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.form-hint {
  margin-top: 8px;
  font-size: 12px;
  color: #888;
}

/* 游戏信息横幅 */
.game-info-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.game-info-icon {
  font-size: 24px;
}

.game-info-text {
  font-size: 16px;
  font-weight: 600;
}

/* 警告横幅 */
.warning-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: #fff3cd;
  color: #856404;
  border: 1px solid #ffc107;
  border-radius: 12px;
  margin-bottom: 24px;
}

.warning-icon {
  font-size: 24px;
}

.warning-text {
  font-size: 14px;
  font-weight: 500;
}

/* 错误横幅 */
.error-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: #f8d7da;
  color: #721c24;
  border: 2px solid #dc3545;
  border-radius: 12px;
  margin-bottom: 24px;
}

.error-icon {
  font-size: 24px;
}

.error-text {
  font-size: 14px;
  font-weight: 600;
}

/* 信息横幅（应用主题） */
.info-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: linear-gradient(135deg, #4ECDC4 0%, #45B7D1 100%);
  color: white;
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
}

.info-icon {
  font-size: 24px;
}

.info-text {
  font-size: 16px;
  font-weight: 600;
}

/* 样式编辑器 */
.style-editor {
  display: grid;
  grid-template-columns: 350px 1fr;
  gap: 32px;
}

.style-preview-section {
  background: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
}

.preview-title {
  margin: 0 0 16px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.preview-container {
  padding: 20px;
  border-radius: 8px;
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-card {
  padding: 24px;
  text-align: center;
  width: 100%;
  max-width: 280px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.preview-heading {
  margin: 0 0 12px 0;
  font-size: 20px;
  font-weight: 700;
}

.preview-text {
  margin: 0 0 20px 0;
  font-size: 14px;
}

.preview-btn {
  margin: 8px;
  padding: 10px 20px;
  border: none;
  color: white;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: transform 0.2s;
}

.preview-btn:hover {
  transform: scale(1.05);
}

/* 颜色和尺寸配置 */
.style-controls {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.style-section {
  background: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 0 0 20px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.color-grid,
.size-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 16px;
}

.color-field,
.size-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.color-label,
.size-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
}

.color-input-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
}

.color-picker {
  width: 48px;
  height: 36px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: transparent;
  padding: 0;
}

.color-text-input,
.size-input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 13px;
  font-family: monospace;
  background: white;
}

.color-text-input:focus,
.size-input:focus {
  outline: none;
  border-color: #4ECDC4;
}

/* 资源上传 */
.assets-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 32px;
}

.asset-section {
  background: #f9f9f9;
  border-radius: 12px;
  padding: 20px;
}

.asset-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.asset-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: white;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.asset-preview-box {
  width: 64px;
  height: 64px;
  border-radius: 8px;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.asset-preview-box.audio {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.asset-preview-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.asset-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-icon {
  font-size: 28px;
  opacity: 0.5;
}

.audio-icon {
  font-size: 28px;
}

.asset-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.asset-name {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  display: flex;
  align-items: center;
  gap: 4px;
}

.required-mark {
  color: #ff6b6b;
  font-size: 12px;
}

.asset-size-hint,
.asset-status {
  font-size: 12px;
  color: #888;
}

.asset-description {
  margin: 4px 0 0 0;
  font-size: 12px;
  color: #666;
  line-height: 1.4;
}

.asset-actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}

.btn-upload,
.btn-play,
.btn-remove {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-upload {
  background: #4ECDC4;
  color: white;
}

.btn-play {
  background: #45B7D1;
  color: white;
}

.btn-remove {
  background: #ff6b6b;
  color: white;
}

.btn-upload:hover,
.btn-play:hover,
.btn-remove:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.hidden-input {
  display: none;
}

/* 发布设置 */
.publish-preview {
  max-width: 800px;
  margin: 0 auto;
}

.preview-theme-card {
  display: flex;
  gap: 24px;
  padding: 24px;
  background: #f9f9f9;
  border-radius: 12px;
  margin-bottom: 32px;
}

.preview-thumbnail {
  width: 120px;
  height: 120px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.preview-icon {
  font-size: 48px;
}

.preview-details {
  flex: 1;
}

.preview-name {
  margin: 0 0 8px 0;
  font-size: 20px;
  font-weight: 700;
  color: #333;
}

.preview-author {
  margin: 0 0 8px 0;
  font-size: 14px;
  color: #666;
}

.preview-desc {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: #888;
  line-height: 1.5;
}

.preview-meta {
  display: flex;
  gap: 16px;
  font-size: 13px;
}

.preview-price {
  font-weight: 600;
  color: #4ECDC4;
}

.preview-base-theme {
  color: #888;
  font-size: 13px;
}

/* 发布选项 */
.publish-options {
  margin-bottom: 32px;
}

.option-group {
  margin-bottom: 20px;
}

.option-checkbox {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.option-checkbox input {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.option-text {
  font-size: 15px;
  font-weight: 500;
  color: #333;
}

.option-desc {
  margin: 8px 0 0 32px;
  font-size: 13px;
  color: #888;
}

.option-label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

/* 发布摘要 */
.publish-summary {
  padding: 20px;
  background: #f9f9f9;
  border-radius: 8px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid #e0e0e0;
}

.summary-item:last-child {
  border-bottom: none;
}

.summary-label {
  font-size: 14px;
  color: #666;
}

.summary-value {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

/* 底部导航 */
.step-navigation {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.nav-spacer {
  flex: 1;
}

.btn-nav {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 32px;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-nav:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-prev {
  background: #f0f0f0;
  color: #666;
}

.btn-prev:hover:not(:disabled) {
  background: #e0e0e0;
}

.btn-next {
  background: linear-gradient(135deg, #4ECDC4 0%, #45B7D1 100%);
  color: white;
}

.btn-next:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(78, 205, 196, 0.3);
}

.btn-publish {
  background: linear-gradient(135deg, #FF6B9D 0%, #FF8E53 100%);
  color: white;
  min-width: 140px;
  justify-content: center;
}

.btn-publish:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 107, 157, 0.3);
}

.nav-icon {
  font-size: 18px;
}

/* 加载动画 */
.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .style-editor {
    grid-template-columns: 1fr;
  }

  .assets-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .diy-content {
    padding: 16px;
  }

  .create-steps {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
    padding: 20px;
  }

  .create-steps::before {
    display: none;
  }

  .create-step {
    flex-direction: row;
    text-align: left;
  }

  .step-info {
    text-align: left;
  }

  .step-description {
    max-width: none;
  }

  .step-content {
    padding: 20px;
  }

  .preview-theme-card {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .preview-thumbnail {
    width: 100px;
    height: 100px;
  }

  .preview-meta {
    justify-content: center;
  }

  .color-grid,
  .size-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .back-btn span:not(.back-icon) {
    display: none;
  }

  .asset-item {
    flex-direction: column;
    align-items: flex-start;
  }

  .asset-actions {
    width: 100%;
  }

  .btn-upload,
  .btn-play,
  .btn-remove {
    flex: 1;
    text-align: center;
  }

  .btn-nav {
    padding: 10px 20px;
    font-size: 14px;
  }
}
</style>