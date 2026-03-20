<template>
  <div class="image-resource-panel">
    <el-card shadow="hover" class="resource-card">
      <template #header>
        <div class="card-header">
          <span class="card-title">🖼️ 图片资源</span>
          <el-button type="primary" size="small" @click="showUploadDialog">
            <el-icon><Plus /></el-icon>
            上传图片
          </el-button>
        </div>
      </template>

      <!-- 分类标签 -->
      <el-tabs v-model="activeCategory" type="border-card">
        <el-tab-pane label="登录页" name="login">
          <ImageList
            v-model="images.login"
            category="login"
            @update:model-value="updateImages"
          />
        </el-tab-pane>

        <el-tab-pane label="场景" name="scene">
          <ImageList
            v-model="images.scene"
            category="scene"
            @update:model-value="updateImages"
          />
        </el-tab-pane>

        <el-tab-pane label="UI元素" name="ui">
          <ImageList
            v-model="images.ui"
            category="ui"
            @update:model-value="updateImages"
          />
        </el-tab-pane>

        <el-tab-pane label="图标" name="icon">
          <ImageList
            v-model="images.icon"
            category="icon"
            @update:model-value="updateImages"
          />
        </el-tab-pane>

        <el-tab-pane label="特效" name="effect">
          <ImageList
            v-model="images.effect"
            category="effect"
            @update:model-value="updateImages"
          />
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 上传对话框 -->
    <el-dialog v-model="uploadDialogVisible" title="上传图片" width="600px">
      <el-upload
        ref="uploadRef"
        class="image-uploader"
        drag
        multiple
        :auto-upload="false"
        :on-change="handleFileChange"
        :on-remove="handleRemove"
        :file-list="fileList"
      >
        <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
        <div class="el-upload__text">
          将图片拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持格式：PNG、JPG、GIF、WEBP | 大小：≤5MB
          </div>
        </template>
      </el-upload>

      <template #footer>
        <el-button @click="uploadDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleUpload" :loading="uploading">
          开始上传
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, UploadFilled } from '@element-plus/icons-vue'
import ImageList from './ImageList.vue'
import Compressor from 'compressorjs'
import type { GTRSTheme } from '@/utils/gtrs-validator'

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

// 当前分类
const activeCategory = ref<'login' | 'scene' | 'ui' | 'icon' | 'effect'>('login')

// 图片数据
const images = ref<GTRSTheme['resources']['images']>({
  login: {},
  scene: {},
  ui: {},
  icon: {},
  effect: {}
})

// 上传对话框
const uploadDialogVisible = ref(false)
const uploading = ref(false)
const fileList = ref<any[]>([])
const uploadRef = ref()

// ========== 方法 ==========

// 显示上传对话框
const showUploadDialog = () => {
  uploadDialogVisible.value = true
  fileList.value = []
}

// 文件选择变化
const handleFileChange = (file: any) => {
  const isImage = file.raw.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件！')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过5MB！')
    return false
  }
}

// 移除文件
const handleRemove = (file: any) => {
  const index = fileList.value.findIndex(item => item.uid === file.uid)
  if (index > -1) {
    fileList.value.splice(index, 1)
  }
}

// 上传图片
const handleUpload = async () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请选择要上传的图片')
    return
  }

  uploading.value = true
  try {
    const category = activeCategory.value
    const categoryImages = images.value[category]

    for (const file of fileList.value) {
      // 压缩图片
      const compressedFile = await new Promise<Blob>((resolve) => {
        new Compressor(file.raw, {
          quality: 0.8,
          maxWidth: 1920,
          maxHeight: 1080,
          success(result) {
            resolve(result)
          },
          error(err) {
            console.error('图片压缩失败：', err)
            resolve(file.raw)
          }
        })
      })

      // 读取文件为 Base64
      const base64 = await new Promise<string>((resolve) => {
        const reader = new FileReader()
        reader.readAsDataURL(compressedFile as File)
        reader.onload = (e: any) => resolve(e.target.result)
      })

      // 生成唯一Key
      const key = `${category}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
      const alias = file.name.replace(/\.[^/.]+$/, '')

      // 添加到图片列表
      categoryImages[key] = {
        key,
        alias,
        src: base64,
        alt: alias
      }
    }

    emit('update:modelValue', {
      ...props.modelValue,
      resources: {
        ...props.modelValue.resources,
        images: images.value
      }
    })
    emit('update:isDirty', true)

    uploadDialogVisible.value = false
    ElMessage.success(`成功上传 ${fileList.value.length} 张图片`)
  } catch (error) {
    ElMessage.error('上传失败：' + (error as Error).message)
  } finally {
    uploading.value = false
  }
}

// 更新图片列表
const updateImages = (value: any) => {
  images.value[activeCategory.value] = value

  emit('update:modelValue', {
    ...props.modelValue,
    resources: {
      ...props.modelValue.resources,
      images: images.value
    }
  })
  emit('update:isDirty', true)
}

// ========== 监听 ==========

// 监听外部传入的值
watch(
  () => props.modelValue.resources?.images,
  (newValue) => {
    if (newValue) {
      images.value = { ...newValue }
    }
  },
  { deep: true, immediate: true }
)
</script>

<style scoped lang="scss">
.image-resource-panel {
  max-width: 1200px;
  margin: 0 auto;
}

.resource-card {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .card-title {
      font-weight: bold;
      font-size: 16px;
    }
  }
}

.image-uploader {
  :deep(.el-upload-dragger) {
    width: 100%;
    padding: 40px;
  }
}

.el-icon--upload {
  font-size: 67px;
  color: #c0c4cc;
  margin-bottom: 16px;
}

.el-upload__text {
  color: #606266;
  font-size: 14px;

  em {
    color: #409eff;
    font-style: normal;
  }
}

.el-upload__tip {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
  line-height: 1.6;
}
</style>
