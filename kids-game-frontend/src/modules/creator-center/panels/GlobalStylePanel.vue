<template>
  <div class="global-style-panel">
    <el-card shadow="hover" class="style-card">
      <template #header>
        <span class="card-title">🎨 全局样式</span>
      </template>

      <div class="style-content">
        <!-- 颜色配置 -->
        <div class="style-section">
          <h3 class="section-title">🌈 颜色配置</h3>

          <div class="color-grid">
            <div class="color-item">
              <label>主色调</label>
              <el-color-picker v-model="globalStyle.primaryColor" show-alpha />
              <div class="color-preview" :style="{ background: globalStyle.primaryColor }"></div>
            </div>

            <div class="color-item">
              <label>辅助色</label>
              <el-color-picker v-model="globalStyle.secondaryColor" show-alpha />
              <div class="color-preview" :style="{ background: globalStyle.secondaryColor }"></div>
            </div>

            <div class="color-item">
              <label>背景色</label>
              <el-color-picker v-model="globalStyle.bgColor" show-alpha />
              <div class="color-preview" :style="{ background: globalStyle.bgColor }"></div>
            </div>

            <div class="color-item">
              <label>文字颜色</label>
              <el-color-picker v-model="globalStyle.textColor" show-alpha />
              <div class="color-preview" :style="{ background: globalStyle.textColor }"></div>
            </div>

            <div class="color-item">
              <label>边框颜色</label>
              <el-color-picker v-model="globalStyle.borderColor" show-alpha />
              <div class="color-preview" :style="{ background: globalStyle.borderColor }"></div>
            </div>
          </div>
        </div>

        <!-- 字体配置 -->
        <div class="style-section">
          <h3 class="section-title">🔤 字体配置</h3>

          <div class="font-config">
            <div class="form-item">
              <label>字体选择</label>
              <el-select v-model="globalStyle.fontFamily" placeholder="请选择字体">
                <el-option label="微软雅黑" value="Microsoft YaHei"></el-option>
                <el-option label="思源黑体" value="Source Han Sans CN"></el-option>
                <el-option label="阿里巴巴普惠体" value="Alibaba PuHuiTi"></el-option>
                <el-option label="苹方" value="PingFang SC"></el-option>
                <el-option label="宋体" value="SimSun"></el-option>
                <el-option label="黑体" value="SimHei"></el-option>
              </el-select>
            </div>

            <div class="form-item">
              <label>字体大小</label>
              <el-slider v-model="fontSize" :min="12" :max="32" :step="1" show-input />
              <div class="preview-text" :style="{ fontSize: fontSize + 'px' }">Aa 文字预览</div>
            </div>

            <div class="form-item">
              <label>字体粗细</label>
              <el-radio-group v-model="globalStyle.fontWeight">
                <el-radio label="normal">常规</el-radio>
                <el-radio label="bold">粗体</el-radio>
                <el-radio label="lighter">细体</el-radio>
              </el-radio-group>
            </div>
          </div>
        </div>

        <!-- 圆角和阴影 -->
        <div class="style-section">
          <h3 class="section-title">✨ 圆角和阴影</h3>

          <div class="form-item">
            <label>圆角大小</label>
            <el-slider v-model="globalStyle.borderRadius" :min="0" :max="20" :step="1" show-input />
            <div class="border-radius-preview" :style="{ borderRadius: globalStyle.borderRadius + 'px' }">
              圆角预览
            </div>
          </div>

          <div class="form-item">
            <label>阴影效果</label>
            <el-radio-group v-model="globalStyle.shadow">
              <el-radio label="none">无阴影</el-radio>
              <el-radio label="light">轻微阴影</el-radio>
              <el-radio label="heavy">明显阴影</el-radio>
            </el-radio-group>
          </div>

          <div class="form-item" v-if="globalStyle.shadow !== 'none'">
            <label>阴影颜色</label>
            <el-color-picker v-model="globalStyle.shadowColor" show-alpha />
          </div>
        </div>

        <!-- 预设色板 -->
        <div class="style-section">
          <h3 class="section-title">🎨 预设配色方案</h3>

          <div class="preset-colors">
            <div
              v-for="(preset, index) in colorPresets"
              :key="index"
              class="preset-card"
              @click="applyPreset(preset)"
            >
              <div class="preset-colors-preview">
                <div
                  v-for="(color, colorIndex) in [preset.primaryColor, preset.secondaryColor, preset.bgColor]"
                  :key="colorIndex"
                  class="preset-color"
                  :style="{ background: color }"
                ></div>
              </div>
              <div class="preset-name">{{ preset.name }}</div>
            </div>
          </div>
        </div>

        <!-- 样式预览 -->
        <div class="style-section">
          <h3 class="section-title">👁️ 样式预览</h3>

          <div class="preview-container">
            <div class="preview-card" :style="previewStyle">
              <div class="preview-header">
                <h3>标题</h3>
                <p>这是一段示例文本</p>
              </div>
              <div class="preview-content">
                <button class="preview-button">按钮</button>
                <div class="preview-input">输入框</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
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

// 全局样式数据
const globalStyle = ref<GTRSTheme['globalStyle']>({
  primaryColor: '#409eff',
  secondaryColor: '#67c23a',
  bgColor: '#ffffff',
  textColor: '#303133',
  borderColor: '#dcdfe6',
  fontFamily: 'Microsoft YaHei',
  fontSize: 14,
  fontWeight: 'normal',
  borderRadius: 8,
  shadow: 'light',
  shadowColor: 'rgba(0, 0, 0, 0.1)'
})

// 字体大小（单独处理）
const fontSize = ref(14)

// 预设配色方案
const colorPresets = [
  {
    name: '默认蓝',
    primaryColor: '#409eff',
    secondaryColor: '#67c23a',
    bgColor: '#ffffff'
  },
  {
    name: '活力橙',
    primaryColor: '#e6a23c',
    secondaryColor: '#f56c6c',
    bgColor: '#fff8f0'
  },
  {
    name: '清新绿',
    primaryColor: '#67c23a',
    secondaryColor: '#95d475',
    bgColor: '#f0fff4'
  },
  {
    name: '优雅紫',
    primaryColor: '#9c27b0',
    secondaryColor: '#ba68c8',
    bgColor: '#f3e5f5'
  },
  {
    name: '深邃黑',
    primaryColor: '#2c3e50',
    secondaryColor: '#34495e',
    bgColor: '#ecf0f1'
  },
  {
    name: '温暖红',
    primaryColor: '#f56c6c',
    secondaryColor: '#ff9900',
    bgColor: '#fef0f0'
  }
]

// ========== 计算属性 ==========

// 预览样式
const previewStyle = computed(() => ({
  backgroundColor: globalStyle.value.bgColor,
  color: globalStyle.value.textColor,
  fontFamily: globalStyle.value.fontFamily,
  fontSize: globalStyle.value.fontSize + 'px',
  fontWeight: globalStyle.value.fontWeight,
  borderRadius: globalStyle.value.borderRadius + 'px',
  boxShadow: getShadowValue(globalStyle.value.shadow)
}))

// ========== 方法 ==========

// 应用预设配色
const applyPreset = (preset: any) => {
  globalStyle.value.primaryColor = preset.primaryColor
  globalStyle.value.secondaryColor = preset.secondaryColor
  globalStyle.value.bgColor = preset.bgColor

  emit('update:modelValue', {
    ...props.modelValue,
    globalStyle: globalStyle.value
  })
  emit('update:isDirty', true)

  ElMessage.success(`已应用配色方案：${preset.name}`)
}

// 获取阴影值
const getShadowValue = (shadow: string) => {
  const color = globalStyle.value.shadowColor

  switch (shadow) {
    case 'none':
      return 'none'
    case 'light':
      return `0 2px 4px ${color}`
    case 'heavy':
      return `0 4px 12px ${color}`
    default:
      return 'none'
  }
}

// ========== 监听 ==========

// 监听全局样式变化
watch(
  () => globalStyle.value,
  (newValue) => {
    emit('update:modelValue', {
      ...props.modelValue,
      globalStyle: newValue
    })
  },
  { deep: true }
)

// 监听字体大小变化
watch(fontSize, (newValue) => {
  globalStyle.value.fontSize = newValue
})
</script>

<style scoped lang="scss">
.global-style-panel {
  max-width: 1000px;
  margin: 0 auto;
}

.style-card {
  .card-title {
    font-weight: bold;
    font-size: 16px;
  }
}

.style-section {
  margin-bottom: 30px;

  .section-title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 16px;
    color: #303133;
  }
}

.color-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.color-item {
  display: flex;
  flex-direction: column;
  gap: 8px;

  label {
    font-size: 14px;
    color: #606266;
    font-weight: 500;
  }

  .color-preview {
    width: 100%;
    height: 30px;
    border-radius: 4px;
    border: 1px solid #dcdfe6;
  }
}

.font-config {
  .form-item {
    margin-bottom: 20px;

    label {
      display: block;
      margin-bottom: 8px;
      font-size: 14px;
      color: #606266;
      font-weight: 500;
    }
  }

  .preview-text {
    margin-top: 10px;
    padding: 10px;
    background: #f5f7fa;
    border-radius: 4px;
  }
}

.form-item {
  label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    color: #606266;
    font-weight: 500;
  }
}

.border-radius-preview {
  margin-top: 10px;
  padding: 10px;
  background: #f5f7fa;
  text-align: center;
  transition: border-radius 0.3s;
}

.preset-colors {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 16px;
}

.preset-card {
  padding: 12px;
  background: #f5f7fa;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
}

.preset-colors-preview {
  display: flex;
  gap: 4px;
  margin-bottom: 8px;
}

.preset-color {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  border: 1px solid #dcdfe6;
}

.preset-name {
  font-size: 13px;
  color: #606266;
  text-align: center;
}

.preview-container {
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
}

.preview-card {
  padding: 20px;
  background: #fff;
  transition: all 0.3s;

  .preview-header {
    margin-bottom: 16px;

    h3 {
      margin: 0 0 8px 0;
      font-size: 18px;
    }

    p {
      margin: 0;
      opacity: 0.8;
    }
  }

  .preview-content {
    display: flex;
    gap: 12px;
  }

  .preview-button {
    padding: 8px 16px;
    background: v-bind('globalStyle.primaryColor');
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;
  }

  .preview-input {
    flex: 1;
    padding: 8px 12px;
    border: 1px solid;
    border-color: v-bind('globalStyle.borderColor');
    border-radius: 4px;
    background: #fff;
  }
}
</style>
