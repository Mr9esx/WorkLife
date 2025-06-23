# WeekLife Flutter 项目 Makefile
# 使用方法: make <command>

.PHONY: help clean build-runner deps upgrade analyze format test run-debug run-release install-deps clean-all pod-install pod-clean

# 默认目标 - 显示帮助信息
help:
	@echo "WeekLife Flutter 项目 Makefile"
	@echo ""
	@echo "可用命令:"
	@echo "  help           - 显示此帮助信息"
	@echo "  deps           - 获取项目依赖"
	@echo "  upgrade        - 升级项目依赖"
	@echo "  build-runner   - 重新生成数据库代码 (Drift/build_runner)"
	@echo "  clean          - 清理项目缓存"
	@echo "  clean-all      - 深度清理 (包括 pub cache)"
	@echo "  analyze        - 代码静态分析"
	@echo "  format         - 格式化代码"
	@echo "  test           - 运行测试"
	@echo "  run-debug      - 运行调试版本"
	@echo "  run-release    - 运行发布版本"
	@echo "  install-deps   - 安装系统依赖 (macOS)"
	@echo "  build-ios      - 构建 iOS 应用"
	@echo "  build-android  - 构建 Android 应用"
	@echo "  build-apk      - 构建 Android APK"
	@echo "  pod-install    - 修复 CocoaPods 同步问题"
	@echo "  pod-clean      - 清理并重新安装 CocoaPods"
	@echo ""

# 获取项目依赖
deps:
	@echo "📦 获取项目依赖..."
	flutter pub get

# 升级项目依赖
upgrade:
	@echo "⬆️  升级项目依赖..."
	flutter pub upgrade

# 重新生成数据库代码
build-runner:
	@echo "🔄 重新生成数据库代码..."
	dart run build_runner build --delete-conflicting-outputs

# 监听模式生成代码
build-runner-watch:
	@echo "👀 监听模式生成代码..."
	dart run build_runner watch --delete-conflicting-outputs

# 清理项目缓存
clean:
	@echo "🧹 清理项目缓存..."
	flutter clean
	flutter pub get

# 深度清理
clean-all:
	@echo "🧹 深度清理项目..."
	flutter clean
	dart pub cache clean
	rm -rf .dart_tool/
	rm -rf build/
	rm -rf ios/Pods/
	rm -rf ios/.symlinks/
	rm -rf ios/Podfile.lock
	rm -rf android/.gradle/
	rm -rf android/app/build/
	flutter pub get

# 代码静态分析
analyze:
	@echo "🔍 代码静态分析..."
	dart analyze

# 格式化代码
format:
	@echo "✨ 格式化代码..."
	dart format lib/ test/ --set-exit-if-changed

# 修复格式化
format-fix:
	@echo "✨ 修复代码格式..."
	dart format lib/ test/

# 运行测试
test:
	@echo "🧪 运行测试..."
	flutter test

# 运行调试版本
run-debug:
	@echo "🚀 运行调试版本..."
	flutter run --debug

# 运行发布版本
run-release:
	@echo "🚀 运行发布版本..."
	flutter run --release

# 安装系统依赖 (macOS)
install-deps:
	@echo "📱 安装系统依赖..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "安装 CocoaPods..."; \
		brew install cocoapods; \
		echo "安装 Android Studio 命令行工具..."; \
		brew install --cask android-studio; \
	else \
		echo "请先安装 Homebrew: https://brew.sh/"; \
	fi

# 构建 iOS 应用
build-ios:
	@echo "🍎 构建 iOS 应用..."
	flutter build ios --release

# 构建 Android 应用
build-android:
	@echo "🤖 构建 Android 应用..."
	flutter build appbundle --release

# 构建 Android APK
build-apk:
	@echo "📱 构建 Android APK..."
	flutter build apk --release

# 检查 Flutter 环境
doctor:
	@echo "🩺 检查 Flutter 环境..."
	flutter doctor -v

# 修复 CocoaPods 同步问题
pod-install:
	@echo "🔧 修复 CocoaPods 同步问题..."
	@if [ -d "ios" ]; then \
		echo "进入 ios 目录..."; \
		cd ios && pod install --repo-update; \
		echo "✅ CocoaPods 同步完成!"; \
	else \
		echo "❌ 未找到 ios 目录，请确保在 Flutter 项目根目录执行"; \
	fi

# 清理并重新安装 CocoaPods
pod-clean:
	@echo "🧹 清理并重新安装 CocoaPods..."
	@if [ -d "ios" ]; then \
		echo "清理 CocoaPods 缓存..."; \
		cd ios && rm -rf Pods/ Podfile.lock .symlinks/; \
		echo "重新安装 pods..."; \
		pod install --repo-update; \
		echo "✅ CocoaPods 重新安装完成!"; \
	else \
		echo "❌ 未找到 ios 目录，请确保在 Flutter 项目根目录执行"; \
	fi

# 启动 iOS 模拟器
ios-sim:
	@echo "📱 启动 iOS 模拟器..."
	open -a Simulator

# 列出可用设备
devices:
	@echo "📱 列出可用设备..."
	flutter devices

# 完整的开发环境设置
setup: clean deps build-runner
	@echo "✅ 开发环境设置完成!"

# 发布前检查
pre-release: clean deps build-runner analyze test
	@echo "✅ 发布前检查完成!"

# 快速重启 (热重载相关)
restart:
	@echo "🔄 重启应用..."
	@echo "请在运行的 Flutter 应用中按 'R' 键重启"

# 生成图标
icons:
	@echo "🎨 生成应用图标..."
	dart run flutter_launcher_icons

# 生成启动页
splash:
	@echo "🌟 生成启动页..."
	dart run flutter_native_splash:create

# 本地化相关
l10n:
	@echo "🌍 生成本地化文件..."
	flutter gen-l10n

# 性能分析
profile:
	@echo "📊 性能分析模式运行..."
	flutter run --profile

# 查看依赖树
deps-tree:
	@echo "🌳 查看依赖树..."
	flutter pub deps

# 检查过时的依赖
deps-outdated:
	@echo "📅 检查过时的依赖..."
	flutter pub outdated

# Git 相关快捷命令
git-status:
	@echo "📋 Git 状态..."
	git status

git-add-all:
	@echo "➕ 添加所有更改..."
	git add .

git-commit:
	@echo "💾 提交更改..."
	@read -p "请输入提交信息: " msg; git commit -m "$$msg"

git-push:
	@echo "⬆️  推送到远程仓库..."
	git push

# 快速提交流程
quick-commit: git-add-all git-commit git-push
	@echo "✅ 快速提交完成!" 