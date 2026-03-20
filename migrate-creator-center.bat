@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 创作者中心模块化重构 - 自动化集成脚本
echo ========================================
echo.

REM 获取当前目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..
set FRONTEND_ROOT=%PROJECT_ROOT%\kids-game-frontend
set CREATOR_CENTER_DIR=%FRONTEND_ROOT%\src\modules\creator-center
set COMPONENTS_DIR=%CREATOR_CENTER_DIR%\components

echo 项目根目录：%PROJECT_ROOT%
echo 前端目录：%FRONTEND_ROOT%
echo 创作者中心目录：%CREATOR_CENTER_DIR%
echo.

REM Step 1: 备份原文件
echo [Step 1] 备份原有文件...
if exist "%CREATOR_CENTER_DIR%\index.vue" (
    copy "%CREATOR_CENTER_DIR%\index.vue" "%CREATOR_CENTER_DIR%\index.vue.backup" >nul
    echo ✓ 已创建备份：index.vue.backup
) else (
    echo ⚠ index.vue 不存在，跳过备份
)

REM Step 2: 创建组件目录
echo.
echo [Step 2] 创建组件目录...
if not exist "%COMPONENTS_DIR%" (
    mkdir "%COMPONENTS_DIR%"
    echo ✓ 已创建目录：components
) else (
    echo ⚠ components 目录已存在
)

REM Step 3: 移动组件文件
echo.
echo [Step 3] 移动组件文件到 components 目录...

for %%f in (OfficialThemesList.vue MyThemesManagement.vue ThemeStore.vue ThemeSwitcher.vue) do (
    if exist "%CREATOR_CENTER_DIR%\%%f" (
        if not exist "%COMPONENTS_DIR%\%%f" (
            move "%CREATOR_CENTER_DIR%\%%f" "%COMPONENTS_DIR%\%%f"
            echo ✓ 已移动：%%f → components/%%f
        ) else (
            echo ⚠ components/%%f 已存在，跳过
        )
    ) else (
        echo ⚠ 源文件不存在：%%f
    )
)

REM Step 4: 处理主组件
echo.
echo [Step 4] 处理主组件...
if exist "%CREATOR_CENTER_DIR%\index-refactored.vue" (
    REM 重命名原文件为 .old
    if exist "%CREATOR_CENTER_DIR%\index.vue" (
        move /y "%CREATOR_CENTER_DIR%\index.vue" "%CREATOR_CENTER_DIR%\index.vue.old" >nul
        echo ✓ 原文件已保存为：index.vue.old
    )
    
    REM 将重构版重命名为 index.vue
    move "%CREATOR_CENTER_DIR%\index-refactored.vue" "%CREATOR_CENTER_DIR%\index.vue"
    echo ✓ 已使用新版本替换原文件
) else (
    echo ⚠ index-refactored.vue 不存在
)

REM Step 5: 验证结果
echo.
echo [Step 5] 验证迁移结果...
echo.
echo 文件结构检查:
dir /b "%CREATOR_CENTER_DIR%" | findstr /v ".old .backup"
echo.
echo components 目录内容:
dir /b "%COMPONENTS_DIR%" 2>nul || echo ⚠ components 目录为空或不存在

REM 完成提示
echo.
echo ========================================
echo ✓ 迁移完成!
echo ========================================
echo.
echo 下一步操作:
echo   1. 启动开发服务器：npm run dev
echo   2. 访问创作者中心进行测试
echo   3. 如有问题，恢复备份：copy index.vue.backup index.vue
echo.
echo ⚠️  注意：原文件已保存为 index.vue.old
echo.

pause
