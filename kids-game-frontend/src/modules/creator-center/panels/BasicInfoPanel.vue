<template>
  <div class="basic-info-panel">
    <el-card shadow="hover" class="info-card">
      <template #header>
        <span class="card-title">📋 基本信息</span>
      </template>

      <el-form ref="formRef" :model="formData" :rules="rules" label-width="120px" size="default">
        <!-- 主题ID -->
        <el-form-item label="主题ID" prop="themeId">
          <el-input
            v-model="formData.themeId"
            placeholder="英文+数字+下划线"
            :disabled="!isEditMode"
          />
          <div class="form-tip">系统自动生成，一般无需修改</div>
        </el-form-item>

        <!-- 游戏选择 -->
        <el-form-item label="适用游戏" prop="gameId">
          <el-select v-model="formData.gameId" placeholder="请选择游戏" @change="handleGameChange">
            <el-option
              v-for="game in gameList"
              :key="game.value"
              :label="game.label"
              :value="game.value"
            />
          </el-select>
        </el-form-item>

        <!-- 主题名称 -->
        <el-form-item label="主题名称" prop="themeName">
          <el-input
            v-model="formData.themeName"
            placeholder="请输入主题名称"
            maxlength="20"
            show-word-limit
          />
          <div class="form-tip">最多20字，支持中文</div>
        </el-form-item>

        <!-- 主题封面图 -->
        <el-form-item label="主题封面" prop="coverImage">
          <div class="cover-uploader">
            <el-upload
              class="avatar-uploader"
              :show-file-list="false"
              :before-upload="beforeCoverUpload"
              :auto-upload="false"
              @change="handleCoverChange"
            >
              <img v-if="formData.coverImage" :src="formData.coverImage" class="avatar" />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <div v-if="formData.coverImage" class="crop-actions">
              <el-button size="small" @click="openCropper">
                <el-icon><Crop /></el-icon>
                裁剪图片
              </el-button>
              <el-button size="small" type="danger" @click="removeCover">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </div>
            <div class="upload-tip">
              <div>建议尺寸：1920x1080</div>
              <div>支持格式：PNG、JPG、WEBP</div>
              <div>大小限制：≤5MB</div>
            </div>
          </div>

          <!-- 图片裁剪对话框 -->
          <ImageCropper
            v-model="cropperVisible"
            :image-url="tempImageUrl"
            :aspect-ratio="16 / 9"
            @confirm="handleCropConfirm"
          />
        </el-form-item>

        <!-- 主题标签 -->
        <el-form-item label="主题标签" prop="tags">
          <el-select
            v-model="formData.tags"
            multiple
            placeholder="选择标签（可多选）"
            style="width: 100%"
          >
            <el-option
              v-for="tag in tagList"
              :key="tag.value"
              :label="tag.label"
              :value="tag.value"
            />
          </el-select>
        </el-form-item>

        <!-- 主题描述 -->
        <el-form-item label="主题描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="4"
            placeholder="请输入主题描述"
            maxlength="200"
            show-word-limit
          />
          <div class="form-tip">最多200字</div>
        </el-form-item>

        <!-- 创作者信息 -->
        <el-form-item label="创作者">
          <div class="creator-info">
            <el-avatar :size="40" :src="userStore.userInfo?.avatar" />
            <div class="creator-details">
              <div class="creator-name">{{ userStore.userInfo?.nickname }}</div>
              <div class="creator-id">ID: {{ userStore.userInfo?.id }}</div>
            </div>
          </div>
        </el-form-item>

        <!-- 联系方式 -->
        <el-form-item label="联系方式">
          <el-input v-model="formData.contact" placeholder="选填，便于用户联系" />
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 新手引导 -->
    <el-collapse v-if="!hasSeenGuide" class="guide-collapse">
      <el-collapse-item title="💡 新手引导：如何创建第一个主题" name="guide">
        <div class="guide-content">
          <h4>📝 步骤1：填写基本信息</h4>
          <p>先填写主题名称、选择适用游戏、上传封面图</p>

          <h4>🎨 步骤2：设计全局样式</h4>
          <p>设置主题的主色调、辅助色、字体等全局样式</p>

          <h4>🖼️ 步骤3：上传图片资源</h4>
          <p>上传游戏需要的所有图片，支持实时预览和批量上传</p>

          <h4>🔊 步骤4：上传音频资源</h4>
          <p>上传游戏背景音乐和音效，支持在线试听</p>

          <h4>👁️ 步骤5：预览和发布</h4>
          <p>预览主题效果，检查完整性，发布到市场</p>

          <el-button type="primary" @click="dismissGuide">我知道了</el-button>
        </div>
      </el-collapse-item>
    </el-collapse>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Crop, Delete } from '@element-plus/icons-vue'
import { useUserStore } from '@/core/store/user.store'
import type { GTRSTheme } from '@/utils/gtrs-validator'
import ImageCropper from './ImageCropper.vue'

interface Props {
  modelValue: GTRSTheme
  isDirty: boolean
}

interface Emits {
  (e: 'update:modelValue', value: GTRSTheme): void
  (e: 'update:isDirty', value: boolean): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const userStore = useUserStore()

// 表单数据
const formData = ref<GTRSTheme['themeInfo']>({
  themeId: '',
  gameId: '',
  themeName: '',
  coverImage: '',
  tags: [],
  description: '',
  author: userStore.userInfo?.nickname || '',
  contact: ''
})

// 表单引用
const formRef = ref()

// 是否为编辑模式
const isEditMode = ref(false)

// 是否已看过引导
const hasSeenGuide = ref(false)

// 游戏列表
const gameList = [
  { label: '贪吃蛇', value: 'game_snake_v3' },
  { label: '植物大战僵尸', value: 'game_pvz_v1' },
  { label: '飞行射击', value: 'game_shooter_v1' }
]

// 标签列表
const tagList = [
  { label: '可爱', value: 'cute' },
  { label: '复古', value: 'retro' },
  { label: '科幻', value: 'scifi' },
  { label: '卡通', value: 'cartoon' },
  { label: '写实', value: 'realistic' },
  { label: '梦幻', value: 'dreamy' },
  { label: '简约', value: 'minimalist' }
]

// 表单验证规则
const rules = {
  themeId: [
    { required: true, message: '请输入主题ID', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '主题ID只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  gameId: [
    { required: true, message: '请选择适用游戏', trigger: 'change' }
  ],
  themeName: [
    { required: true, message: '请输入主题名称', trigger: 'blur' },
    { min: 2, max: 20, message: '主题名称长度为2-20个字符', trigger: 'blur' }
  ],
  coverImage: [
    { required: true, message: '请上传主题封面', trigger: 'change' }
  ],
  description: [
    { required: true, message: '请输入主题描述', trigger: 'blur' },
    { max: 200, message: '描述最多200字', trigger: 'blur' }
  ]
}

// ========== 方法 ==========

// 封面上传前校验
const beforeCoverUpload = (file: File) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件！')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过5MB！')
    return false
  }

  return true
}

// 封面选择变化
const handleCoverChange = (file: any) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    tempImageUrl.value = e.target?.result as string
    cropperVisible.value = true
  }
  reader.readAsDataURL(file.raw)
}

// 打开裁剪器
const cropperVisible = ref(false)
const tempImageUrl = ref('')

const openCropper = () => {
  if (formData.value.coverImage) {
    tempImageUrl.value = formData.value.coverImage
    cropperVisible.value = true
  }
}

// 裁剪确认
const handleCropConfirm = (blob: Blob, dataUrl: string) => {
  formData.value.coverImage = dataUrl
  emit('update:modelValue', {
    ...props.modelValue,
    themeInfo: formData.value
  })
}

// 删除封面
const removeCover = () => {
  formData.value.coverImage = ''
  emit('update:modelValue', {
    ...props.modelValue,
    themeInfo: formData.value
  })
}

// 封面上传成功（保留备用）
const handleCoverSuccess = (response: any) => {
  // 现在使用裁剪功能，这个函数暂时不使用
  ElMessage.success('封面上传成功')
}

// 游戏选择变化
const handleGameChange = (gameId: string) => {
  // 自动生成主题ID
  const gameName = gameId.replace('game_', '').replace('_v1', '').replace('_v3', '')
  formData.value.themeId = `theme_${gameName}_${Date.now()}`
  isEditMode.value = false
}

// 关闭引导
const dismissGuide = () => {
  hasSeenGuide.value = true
  localStorage.setItem('gtrs_guide_seen', 'true')
}

// ========== 初始化 ==========

// 从本地存储读取是否看过引导
hasSeenGuide.value = localStorage.getItem('gtrs_guide_seen') === 'true'

// ========== 监听 ==========

// 监听外部传入的值（初始化）
watch(
  () => props.modelValue.themeInfo,
  (newValue) => {
    if (newValue && JSON.stringify(newValue) !== JSON.stringify(formData.value)) {
      formData.value = { ...newValue }
    }
  },
  { deep: true, immediate: true }
)

// 监听表单数据变化
watch(
  () => formData.value,
  (newValue) => {
    // 避免循环更新：只有当值真正变化时才 emit
    if (JSON.stringify(newValue) !== JSON.stringify(props.modelValue.themeInfo)) {
      emit('update:modelValue', {
        ...props.modelValue,
        themeInfo: newValue
      })
    }
  },
  { deep: true }
)
</script>

<style scoped lang="scss">
.basic-info-panel {
  max-width: 900px;
  margin: 0 auto;
}

.info-card {
  .card-title {
    font-weight: bold;
    font-size: 16px;
  }
}

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.cover-uploader {
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.avatar-uploader {
  :deep(.el-upload) {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: all 0.3s;

    &:hover {
      border-color: #409eff;
    }
  }

  :deep(.el-upload-list__item) {
    border-radius: 6px;
  }
}

.avatar {
  width: 200px;
  height: 112.5px;
  display: block;
  object-fit: cover;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 200px;
  height: 112.5px;
  line-height: 112.5px;
  text-align: center;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  line-height: 1.6;
}

.crop-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 10px;
}

.creator-info {
  display: flex;
  align-items: center;
  gap: 12px;

  .creator-details {
    .creator-name {
      font-weight: bold;
      font-size: 14px;
      color: #303133;
    }

    .creator-id {
      font-size: 12px;
      color: #909399;
      margin-top: 2px;
    }
  }
}

.guide-collapse {
  margin-top: 20px;

  :deep(.el-collapse-item__header) {
    background: #f0f9ff;
    color: #409eff;
    font-weight: bold;
  }
}

.guide-content {
  padding: 10px 0;

  h4 {
    margin: 15px 0 8px 0;
    color: #303133;
    font-size: 14px;
  }

  p {
    color: #606266;
    font-size: 13px;
    margin: 0 0 10px 0;
  }
}
</style>
