<template>
  <div class="audio-resource-panel">
    <el-card shadow="hover" class="resource-card">
      <template #header>
        <div class="card-header">
          <span class="card-title">🔊 音频资源</span>
          <div class="header-actions">
            <el-button size="small" @click="stopAllAudio">
              <el-icon><VideoPause /></el-icon>
              停止所有
            </el-button>
            <el-button type="primary" size="small" @click="showUploadDialog">
              <el-icon><Plus /></el-icon>
              上传音频
            </el-button>
          </div>
        </div>
      </template>

      <!-- 分类标签 -->
      <el-tabs v-model="activeCategory" type="border-card">
        <el-tab-pane label="背景音乐" name="bgm">
          <AudioList
            v-model="audios.bgm"
            category="bgm"
            @update:model-value="updateAudios"
          />
        </el-tab-pane>

        <el-tab-pane label="音效" name="effect">
          <AudioList
            v-model="audios.effect"
            category="effect"
            @update:model-value="updateAudios"
          />
        </el-tab-pane>

        <el-tab-pane label="语音" name="voice">
          <AudioList
            v-model="audios.voice"
            category="voice"
            @update:model-value="updateAudios"
          />
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 上传对话框 -->
    <el-dialog v-model="uploadDialogVisible" title="上传音频" width="600px">
      <el-upload
        ref="uploadRef"
        class="audio-uploader"
        drag
        multiple
        :auto-upload="false"
        :on-change="handleFileChange"
        :on-remove="handleRemove"
        :file-list="fileList"
      >
        <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
        <div class="el-upload__text">
          将音频拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持格式：MP3、WAV、OGG | 大小：≤10MB
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
import { ref, onUnmounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, UploadFilled, VideoPause } from '@element-plus/icons-vue'
import AudioList from './AudioList.vue'
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
const activeCategory = ref<'bgm' | 'effect' | 'voice'>('bgm')

// 音频数据
const audios = ref<GTRSTheme['resources']['audio']>({
  bgm: {},
  effect: {},
  voice: {}
})

// 上传对话框
const uploadDialogVisible = ref(false)
const uploading = ref(false)
const fileList = ref<any[]>([])
const uploadRef = ref()

// 当前播放的音频
const currentPlayingAudio = ref<HTMLAudioElement | null>(null)

// ========== 方法 ==========

// 显示上传对话框
const showUploadDialog = () => {
  uploadDialogVisible.value = true
  fileList.value = []
}

// 文件选择变化
const handleFileChange = (file: any) => {
  const isAudio = file.raw.type.startsWith('audio/')
  const isLt10M = file.size / 1024 / 1024 < 10

  if (!isAudio) {
    ElMessage.error('只能上传音频文件！')
    return false
  }
  if (!isLt10M) {
    ElMessage.error('音频大小不能超过10MB！')
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

// 上传音频
const handleUpload = async () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请选择要上传的音频')
    return
  }

  uploading.value = true
  try {
    const category = activeCategory.value
    const categoryAudios = audios.value[category]

    for (const file of fileList.value) {
      // 读取文件为 Base64
      const base64 = await new Promise<string>((resolve, reject) => {
        const reader = new FileReader()
        reader.readAsDataURL(file.raw)
        reader.onload = (e: any) => resolve(e.target.result)
        reader.onerror = reject
      })

      // 获取音频时长
      const duration = await new Promise<number>((resolve) => {
        const audio = new Audio(base64)
        audio.onloadedmetadata = () => {
          resolve(audio.duration)
        }
      })

      // 生成唯一Key
      const key = `${category}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
      const alias = file.name.replace(/\.[^/.]+$/, '')

      // 添加到音频列表
      categoryAudios[key] = {
        key,
        alias,
        src: base64,
        volume: 0.5,
        duration: Math.round(duration)
      }
    }

    emit('update:modelValue', {
      ...props.modelValue,
      resources: {
        ...props.modelValue.resources,
        audio: audios.value
      }
    })
    emit('update:isDirty', true)

    uploadDialogVisible.value = false
    ElMessage.success(`成功上传 ${fileList.value.length} 个音频`)
  } catch (error) {
    ElMessage.error('上传失败：' + (error as Error).message)
  } finally {
    uploading.value = false
  }
}

// 停止所有音频
const stopAllAudio = () => {
  if (currentPlayingAudio.value) {
    currentPlayingAudio.value.pause()
    currentPlayingAudio.value = null
  }
  ElMessage.success('已停止所有音频')
}

// 更新音频列表
const updateAudios = (value: any) => {
  audios.value[activeCategory.value] = value

  emit('update:modelValue', {
    ...props.modelValue,
    resources: {
      ...props.modelValue.resources,
      audio: audios.value
    }
  })
  emit('update:isDirty', true)
}

// ========== 生命周期 ==========

onUnmounted(() => {
  // 组件卸载时停止音频
  if (currentPlayingAudio.value) {
    currentPlayingAudio.value.pause()
  }
})

// ========== 监听 ==========

// 监听外部传入的值
watch(
  () => props.modelValue.resources?.audio,
  (newValue) => {
    if (newValue) {
      audios.value = { ...newValue }
    }
  },
  { deep: true, immediate: true }
)
</script>

<style scoped lang="scss">
.audio-resource-panel {
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

    .header-actions {
      display: flex;
      gap: 8px;
    }
  }
}

.audio-uploader {
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
