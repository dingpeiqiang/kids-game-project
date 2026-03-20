<template>
  <el-dialog
    v-model="visible"
    title="裁剪图片"
    width="800px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="image-cropper">
      <!-- 裁剪区域 -->
      <div class="cropper-container">
        <vue-cropper
          ref="cropperRef"
          :src="imageUrl"
          :aspect-ratio="aspectRatio"
          :auto-crop="true"
          :auto-crop-width="cropWidth"
          :auto-crop-height="cropHeight"
          :background="true"
          :view-mode="1"
          :min-container-width="600"
          :min-container-height="400"
          :background-color="'#f5f5f5'"
          @crop="handleCrop"
        />
      </div>

      <!-- 预览区域 -->
      <div class="preview-container">
        <div class="preview-box">
          <div class="preview-title">裁剪预览</div>
          <div class="preview-image-wrapper">
            <img :src="previewUrl" class="preview-image" />
          </div>
          <div class="preview-info">
            <div class="info-item">
              <span class="label">宽度:</span>
              <span class="value">{{ cropWidth }}px</span>
            </div>
            <div class="info-item">
              <span class="label">高度:</span>
              <span class="value">{{ cropHeight }}px</span>
            </div>
          </div>
        </div>

        <!-- 裁剪设置 -->
        <div class="crop-settings">
          <div class="setting-title">裁剪设置</div>

          <!-- 宽高比 -->
          <div class="setting-item">
            <label class="setting-label">宽高比</label>
            <el-radio-group v-model="aspectRatioMode" @change="handleAspectRatioChange">
              <el-radio label="free">自由</el-radio>
              <el-radio label="16:9">16:9</el-radio>
              <el-radio label="4:3">4:3</el-radio>
              <el-radio label="1:1">1:1</el-radio>
            </el-radio-group>
          </div>

          <!-- 旋转 -->
          <div class="setting-item">
            <label class="setting-label">旋转</label>
            <div class="rotate-controls">
              <el-button size="small" @click="rotate(-90)">
                <el-icon><RefreshLeft /></el-icon>
                向左旋转
              </el-button>
              <el-button size="small" @click="rotate(90)">
                <el-icon><RefreshRight /></el-icon>
                向右旋转
              </el-button>
            </div>
          </div>

          <!-- 缩放 -->
          <div class="setting-item">
            <label class="setting-label">缩放</label>
            <el-slider
              v-model="scale"
              :min="0.1"
              :max="3"
              :step="0.1"
              @input="handleScaleChange"
            />
          </div>

          <!-- 重置 -->
          <div class="setting-item">
            <el-button @click="handleReset">重置</el-button>
          </div>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleConfirm" :loading="cropping">
          确认裁剪
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { RefreshLeft, RefreshRight } from '@element-plus/icons-vue'
import { VueCropper } from 'vue-cropperjs'
import 'vue-cropperjs/dist/vue-cropperjs.css'

interface Props {
  modelValue: boolean
  imageUrl: string
  aspectRatio?: number
  defaultWidth?: number
  defaultHeight?: number
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm', blob: Blob, dataUrl: string): void
}

const props = withDefaults(defineProps<Props>(), {
  aspectRatio: NaN,
  defaultWidth: 800,
  defaultHeight: 450
})

const emit = defineEmits<Emits>()

// 状态
const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const cropperRef = ref()
const cropping = ref(false)
const previewUrl = ref('')
const aspectRatioMode = ref('16:9')
const scale = ref(1)
const cropWidth = ref(props.defaultWidth)
const cropHeight = ref(props.defaultHeight)

// 计算宽高比
const aspectRatio = computed(() => {
  switch (aspectRatioMode.value) {
    case '16:9':
      return 16 / 9
    case '4:3':
      return 4 / 3
    case '1:1':
      return 1
    case 'free':
    default:
      return NaN
  }
})

// 监听宽高比变化
watch(aspectRatio, (newRatio) => {
  if (cropperRef.value) {
    cropperRef.value.setAspectRatio(newRatio)
  }
})

// 裁剪回调
const handleCrop = (event: any) => {
  previewUrl.value = event.detail.canvas.toDataURL('image/jpeg', 0.8)
}

// 宽高比变化
const handleAspectRatioChange = () => {
  if (cropperRef.value) {
    cropperRef.value.setAspectRatio(aspectRatio.value)
  }
}

// 旋转
const rotate = (degrees: number) => {
  if (cropperRef.value) {
    cropperRef.value.rotate(degrees)
  }
}

// 缩放变化
const handleScaleChange = (value: number) => {
  if (cropperRef.value) {
    cropperRef.value.zoomTo(value)
  }
}

// 重置
const handleReset = () => {
  if (cropperRef.value) {
    cropperRef.value.reset()
    scale.value = 1
  }
}

// 确认裁剪
const handleConfirm = async () => {
  if (!cropperRef.value) {
    ElMessage.error('裁剪器未初始化')
    return
  }

  try {
    cropping.value = true

    // 获取裁剪后的 canvas
    const canvas = cropperRef.value.getCroppedCanvas({
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high',
      maxWidth: 1920,
      maxHeight: 1080
    })

    // 转换为 blob
    canvas.toBlob((blob: Blob | null) => {
      if (blob) {
        const dataUrl = canvas.toDataURL('image/jpeg', 0.8)
        emit('confirm', blob, dataUrl)
        ElMessage.success('裁剪成功')
        handleClose()
      } else {
        ElMessage.error('裁剪失败')
      }
      cropping.value = false
    }, 'image/jpeg', 0.8)
  } catch (error) {
    ElMessage.error('裁剪失败：' + (error as Error).message)
    cropping.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
  handleReset()
}
</script>

<style scoped lang="scss">
.image-cropper {
  display: flex;
  gap: 20px;
}

.cropper-container {
  flex: 1;
  height: 400px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}

.preview-container {
  width: 280px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.preview-box {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 15px;
  background: #f5f5f5;
}

.preview-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 10px;
}

.preview-image-wrapper {
  width: 100%;
  height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  border-radius: 4px;
  overflow: hidden;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.preview-info {
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #dcdfe6;
}

.info-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;

  .label {
    font-size: 12px;
    color: #909399;
  }

  .value {
    font-size: 12px;
    font-weight: 500;
    color: #303133;
  }
}

.crop-settings {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 15px;
  background: #f5f5f5;
}

.setting-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 15px;
}

.setting-item {
  margin-bottom: 20px;

  &:last-child {
    margin-bottom: 0;
  }
}

.setting-label {
  display: block;
  font-size: 13px;
  color: #606266;
  margin-bottom: 8px;
}

.rotate-controls {
  display: flex;
  gap: 10px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
