#!/bin/bash

# WeekLife Widget 构建修复脚本
# 修复Xcode构建依赖循环问题

echo "🔧 开始修复Widget构建问题..."

# 1. 清理构建缓存
echo "🧹 清理构建缓存..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
rm -rf ../build
flutter clean

# 2. 重新获取依赖
echo "📦 重新获取依赖..."
cd ..
flutter pub get
cd ios

# 3. 清理Pods
echo "🗑️ 清理Pods..."
rm -rf Pods
rm -rf Podfile.lock
pod install --repo-update

# 4. 尝试构建
echo "🔨 尝试构建项目..."
cd ..
flutter build ios --simulator --debug

echo "✅ 修复完成！如果仍有问题，请查看错误信息。" 