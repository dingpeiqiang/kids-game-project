<template>
  <div class="gtrs-theme-creator">
    <!-- 顶部工具栏 -->
    <div class="creator-header">
      <div class="header-left">
        <span class="title">🎨 GTRS 主题编辑器</span>
        <el-tag v-if="isDirty" type="warning" size="small">未保存</el-tag>
      </div>
      <div class="header-right">
        <el-button @click="showDraftManager">
          <el-icon><FolderOpened /></el-icon>
          草稿管理
        </el-button>
        <el-button @click="saveDraft" :loading="saving">
          <el-icon><Document /></el-icon>
          保存草稿
        </el-button>
        <el-button type="primary" @click="publishTheme" :loading="publishing">
          <el-icon><Promotion /></el-icon>
          发布主题
        </el-button>
      </div>

      <!-- 草稿管理对话框 -->
      <DraftManager
        v-model="draftManagerVisible"
        @restore="handleDraftRestore"
      />
    </div>

    <!-- 主体内容 -->
    <div class="creator-body">
      <!-- 左侧导航 -->
      <div class="left-navigation">
        <div
          v-for="tab in tabs"
          :key="tab.key"
          class="nav-item"
          :class="{ active: currentTab === tab.key }"
          @click="switchTab(tab.key)"
        >
          <span class="nav-icon">{{ tab.icon }}</span>
          <span class="nav-label">{{ tab.label }}</span>
        </div>
      </div>

      <!-- 主编辑区 -->
      <div class="main-editor">
        <!-- 基本信息面板 -->
        <BasicInfoPanel
          v-if="currentTab === 'basic'"
          v-model="themeData"
          :is-dirty="isDirty"
          @update:is-dirty="isDirty = $event"
        />

        <!-- 全局样式面板 -->
        <GlobalStylePanel
          v-if="currentTab === 'style'"
          v-model="themeData"
          :is-dirty="isDirty"
          @update:is-dirty="isDirty = $event"
        />

        <!-- 图片资源面板 -->
        <ImageResourcePanel
          v-if="currentTab === 'image'"
          v-model="themeData"
          :is-dirty="isDirty"
          @update:is-dirty="isDirty = $event"
        />

        <!-- 音频资源面板 -->
        <AudioResourcePanel
          v-if="currentTab === 'audio'"
          v-model="themeData"
          :is-dirty="isDirty"
          @update:is-dirty="isDirty = $event"
        />

        <!-- 实时预览面板 -->
        <PreviewPanel
          v-if="currentTab === 'preview'"
          :theme-data="themeData"
        />

        <!-- 发布面板 -->
        <PublishPanel
          v-if="currentTab === 'publish'"
          :theme-data="themeData"
          @publish="handlePublish"
        />
      </div>
    </div>

    <!-- 工具栏 -->
    <div class="toolbar">
      <el-button-group>
        <el-tooltip content="撤销">
          <el-button @click="undo" :disabled="!canUndo">
            <el-icon><RefreshLeft /></el-icon>
          </el-button>
        </el-tooltip>
        <el-tooltip content="重做">
          <el-button @click="redo" :disabled="!canRedo">
            <el-icon><RefreshRight /></el-icon>
          </el-button>
        </el-tooltip>
      </el-button-group>

      <el-divider direction="vertical" />

      <el-button-group>
        <el-tooltip content="查看草稿">
          <el-button @click="showDraftList">
            <el-icon><FolderOpened /></el-icon>
          </el-button>
        </el-tooltip>
        <el-tooltip content="检查完整性">
          <el-button @click="checkCompleteness">
            <el-icon><CircleCheck /></el-icon>
          </el-button>
        </el-tooltip>
      </el-button-group>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Document,
  Promotion,
  RefreshLeft,
  RefreshRight,
  FolderOpened,
  CircleCheck
} from '@element-plus/icons-vue'
import BasicInfoPanel from './panels/BasicInfoPanel.vue'
import GlobalStylePanel from './panels/GlobalStylePanel.vue'
import ImageResourcePanel from './panels/ImageResourcePanel.vue'
import AudioResourcePanel from './panels/AudioResourcePanel.vue'
import PreviewPanel from './panels/PreviewPanel.vue'
import PublishPanel from './panels/PublishPanel.vue'
import DraftManager from './panels/DraftManager.vue'
import { validateGTRSTheme, type GTRSTheme } from '@/utils/gtrs-validator'
import defaultTheme from '@/configs/gtrs-template.json'
import { Document, Promotion, FolderOpened } from '@element-plus/icons-vue'

// ========== 数据定义 ==========

const currentTab = ref<'basic' | 'style' | 'image' | 'audio' | 'preview' | 'publish'>('basic')
const isDirty = ref(false)
const saving = ref(false)
const publishing = ref(false)
const draftManagerVisible = ref(false)
const draftManagerRef = ref()

// 主题数据
const themeData = ref<GTRSTheme>(JSON.parse(JSON.stringify(defaultTheme)))

// 导航标签
const tabs = [
  { key: 'basic', label: '基本信息', icon: '📋' },
  { key: 'style', label: '全局样式', icon: '🎨' },
  { key: 'image', label: '图片资源', icon: '🖼️' },
  { key: 'audio', label: '音频资源', icon: '🔊' },
  { key: 'preview', label: '实时预览', icon: '👁️' },
  { key: 'publish', label: '发布主题', icon: '📤' }
]

// 撤销/重做栈
const undoStack = ref<GTRSTheme[]>([])
const redoStack = ref<GTRSTheme[]>([])

const canUndo = computed(() => undoStack.value.length > 0)
const canRedo = computed(() => redoStack.value.length > 0)

// 自动保存定时器
let autoSaveTimer: number | null = null

// ========== 方法 ==========

// 切换 Tab
const switchTab = (tab: string) => {
  currentTab.value = tab as any
}

// 保存草稿
const saveDraft = async () => {
  saving.value = true
  try {
    // TODO: 调用后端 API 保存草稿
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    // 保存到草稿管理器
    if (draftManagerRef.value) {
      draftManagerRef.value.saveDraft(
        themeData.value,
        themeData.value.themeInfo.themeName
      )
    }
    
    // 先保存到撤销栈（在修改 isDirty 之前）
    undoStack.value.push(JSON.parse(JSON.stringify(themeData.value)))
    
    // 然后标记为已保存
    isDirty.value = false
    
    ElMessage.success('草稿保存成功')
  } catch (error) {
    ElMessage.error('保存失败：' + (error as Error).message)
  } finally {
    saving.value = false
  }
}

// 显示草稿管理器
const showDraftManager = () => {
  draftManagerVisible.value = true
}

// 恢复草稿
const handleDraftRestore = (theme: GTRSTheme) => {
  themeData.value = JSON.parse(JSON.stringify(theme))
  isDirty.value = true
  ElMessage.success('草稿已恢复')
}

// 发布主题
const publishTheme = async () => {
  // 验证主题
  const result = validateGTRSTheme(JSON.stringify(themeData.value))

  if (!result.valid) {
    ElMessage.error('主题校验失败：' + result.message)
    return
  }

  publishing.value = true
  try {
    // TODO: 调用后端 API 发布主题
    await new Promise(resolve => setTimeout(resolve, 2000))

    ElMessage.success('主题发布成功！')
    isDirty.value = false
  } catch (error) {
    ElMessage.error('发布失败：' + (error as Error).message)
  } finally {
    publishing.value = false
  }
}

// 撤销
const undo = () => {
  if (undoStack.value.length === 0) return

  redoStack.value.push(JSON.parse(JSON.stringify(themeData.value)))
  const previous = undoStack.value.pop()
  if (previous) {
    themeData.value = previous
    isDirty.value = true
  }
}

// 重做
const redo = () => {
  if (redoStack.value.length === 0) return

  undoStack.value.push(JSON.parse(JSON.stringify(themeData.value)))
  const next = redoStack.value.pop()
  if (next) {
    themeData.value = next
    isDirty.value = true
  }
}

// 查看草稿列表
const showDraftList = () => {
  ElMessageBox.alert('草稿列表功能开发中...', '提示')
}

// 检查完整性
const checkCompleteness = () => {
  const errors: string[] = []

  // 检查基本信息
  if (!themeData.value.themeInfo.themeName) {
    errors.push('请填写主题名称')
  }
  if (!themeData.value.themeInfo.gameId) {
    errors.push('请选择适用游戏')
  }

  // 检查资源
  const imageCount = Object.keys(themeData.value.resources.images.login).length +
                   Object.keys(themeData.value.resources.images.scene).length +
                   Object.keys(themeData.value.resources.images.ui).length
  const audioCount = Object.keys(themeData.value.resources.audio.bgm).length +
                   Object.keys(themeData.value.resources.audio.effect).length

  if (imageCount === 0) {
    errors.push('请至少上传1张图片')
  }
  if (audioCount === 0) {
    errors.push('请至少上传1个音频文件')
  }

  if (errors.length === 0) {
    ElMessage.success('主题完整性检查通过！✅')
  } else {
    ElMessageBox.alert(errors.join('\n'), '完整性检查', {
      type: 'warning',
      confirmButtonText: '知道了'
    })
  }
}

// 处理发布事件
const handlePublish = async () => {
  await publishTheme()
}

// 自动保存
const startAutoSave = () => {
  autoSaveTimer = window.setInterval(() => {
    if (isDirty.value) {
      saveDraft()
    }
  }, 30000) // 30秒自动保存
}

// ========== 生命周期 ==========

onMounted(() => {
  console.log('GTRS 主题编辑器已加载')
  startAutoSave()
})

onUnmounted(() => {
  if (autoSaveTimer) {
    clearInterval(autoSaveTimer)
  }
})

// ========== 监听 ==========

// 监听主题数据变化
watch(
  () => JSON.stringify(themeData.value),
  () => {
    isDirty.value = true
  },
  { deep: true }
)
</script>

<style scoped lang="scss">
.gtrs-theme-creator {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f7fa;
}

.creator-header {
  height: 60px;
  padding: 0 20px;
  background: #fff;
  border-bottom: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
  justify-content: space-between;

  .header-left {
    display: flex;
    align-items: center;
    gap: 12px;

    .title {
      font-size: 20px;
      font-weight: bold;
      color: #303133;
    }
  }

  .header-right {
    display: flex;
    gap: 12px;
  }
}

.creator-body {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.left-navigation {
  width: 200px;
  background: #fff;
  border-right: 1px solid #dcdfe6;
  padding: 20px 0;

  .nav-item {
    padding: 12px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    transition: all 0.3s;
    color: #606266;

    &:hover {
      background: #f5f7fa;
    }

    &.active {
      background: #409eff;
      color: #fff;
    }

    .nav-icon {
      font-size: 18px;
    }

    .nav-label {
      font-size: 14px;
    }
  }
}

.main-editor {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.toolbar {
  height: 50px;
  background: #fff;
  border-top: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
  padding: 0 20px;
  gap: 12px;
}
</style>
