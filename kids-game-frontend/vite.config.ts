import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { resolve } from 'path';

export default defineConfig({
  plugins: [vue()],
  // 设置静态资源目录为 assets
  publicDir: 'assets',
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@root': resolve(__dirname, '..'), // 指向项目根目录 kids-game-project
    },
  },
  optimizeDeps: {
    exclude: ['phaser'],
    include: [],
  },
  server: {
    port: 3000,
    hmr: {
      overlay: true // 显示错误遮罩
    },
    // 排除特定文件的热更新
    watch: {
      ignored: [
        '**/node_modules/**',
        '**/.git/**',
        '**/dist/**',
        // 忽略大型资源文件
        '**/*.png',
        '**/*.jpg',
        '**/*.jpeg',
        '**/*.gif',
        '**/*.svg',
        '**/*.mp3',
        '**/*.wav',
        '**/*.ogg',
        // 忽略文档文件
        '**/*.md',
        '**/docs/**',
        // 忽略构建产物
        '**/build/**',
        '**/output/**'
      ]
    },
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '/ws': {
        target: 'ws://localhost:8080',
        ws: true,
      },
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
    rollupOptions: {
        external: ['phaser'], // 👉 打包时不包含Phaser
      output: {
        globals: { phaser: 'Phaser' },
        manualChunks: {
          'vendor': ['vue', 'vue-router', 'pinia'],
        },
      },
    },
  },
});
