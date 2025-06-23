import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';

import '../widgets/editors/markdown_editor.dart';

/// 周记编辑组件
/// 负责显示和编辑周记内容，支持Markdown格式
class JournalSection extends StatelessWidget {
  /// 周记内容
  final String content;

  /// 是否处于编辑状态
  final bool isEditing;

  /// 内容变化回调
  final Function(String content) onContentChanged;

  /// 周记控制器
  final TextEditingController? controller;

  const JournalSection({
    super.key,
    required this.content,
    required this.isEditing,
    required this.onContentChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题部分
        Text(
          '周记',
          style: AppTextStyles.editorTitle,
        ),

        const SizedBox(height: 8),

        // 内容容器
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          // decoration: ShapeDecoration(
          //   color: AppColors.unselectedBgColor,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: MenuSize.borderRadius,
          //   ),
          //   shadows: const [
          //     BoxShadow(
          //       color: Color(0x195F5F5F),
          //       blurRadius: 16,
          //       offset: Offset(0, 0),
          //       spreadRadius: 0,
          //     )
          //   ],
          // ),
          decoration: BoxDecoration(
            color: AppColors.appBackground.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.borderColor,
              width: 2,
            ),
          ),
          child: _buildJournalContent(context),
        ),
      ],
    );
  }

  /// 构建周记内容区域（移除多余容器）
  Widget _buildJournalContent(BuildContext context) {
    return GestureDetector(
      onTap: isEditing ? () => _showMarkdownEditor(context) : null,
      behavior: HitTestBehavior.opaque, // 确保整个区域都能响应点击
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(4), // 添加小的内边距，确保点击区域足够大
        child: _buildContentWidget(),
      ),
    );
  }

  /// 构建内容显示组件
  Widget _buildContentWidget() {
    // 判断是否有内容
    final hasContent = content.isNotEmpty;

    if (hasContent) {
      // 有内容时显示 Markdown 渲染结果
      return Stack(
        children: [
          // 在编辑模式下使用 AbsorbPointer 完全阻止所有指针事件
          isEditing
              ? AbsorbPointer(
                  child: MarkdownBody(
                    data: content.replaceAll('\n', '  \n'), // 确保换行正确显示
                    styleSheet: _getMarkdownStyleSheet(),
                    selectable: false, // 编辑模式下完全禁用选择
                  ),
                )
              : MarkdownBody(
                  data: content.replaceAll('\n', '  \n'), // 确保换行正确显示
                  styleSheet: _getMarkdownStyleSheet(),
                  selectable: true, // 非编辑模式下允许选择
                ),
          // 编辑模式下的点击提示
          if (isEditing)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
            ),
        ],
      );
    } else {
      // 无内容时显示提示文本
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              isEditing ? '点击开始记录本周的故事...' : '点击底部编辑按钮开始记录本周的故事...',
              style: AppTextStyles.hintText,
            ),
          ),
        ],
      );
    }
  }

  /// 获取统一的 Markdown 样式配置
  MarkdownStyleSheet _getMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      p: AppTextStyles.markdownParagraph,
      h1: AppTextStyles.markdownH1,
      h2: AppTextStyles.markdownH2,
      h3: AppTextStyles.markdownH3,
      strong: AppTextStyles.markdownStrong,
      em: AppTextStyles.markdownEmphasis,
      code: AppTextStyles.markdownCode,
      codeblockDecoration: BoxDecoration(
        color: AppColors.appBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(GlobalSize.primaryPadding),
      blockquote: AppTextStyles.markdownBlockquote,
      blockquoteDecoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          left: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
            width: 4,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: GlobalSize.primaryPadding,
        vertical: GlobalSize.secondaryPadding,
      ),
      listBullet: AppTextStyles.markdownListBullet,
    );
  }

  /// 显示 Markdown 编辑器
  void _showMarkdownEditor(BuildContext context) {
    print('📝 显示 Markdown 编辑器');
    print('  当前内容长度: ${content.length}');
    print('  当前内容预览: ${content.length > 50 ? '${content.substring(0, 50)}...' : content}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MarkdownEditor(
        initialText: content,
        onSave: (newContent) {
          print('📝 周记内容已更新');
          print('  新内容长度: ${newContent.length}');
          print('  新内容预览: ${newContent.length > 50 ? '${newContent.substring(0, 50)}...' : newContent}');
          onContentChanged(newContent);

          // 如果有控制器，同步更新
          if (controller != null) {
            controller!.text = newContent;
          }
        },
      ),
    );
  }
}

/// 周记内容状态数据模型
class JournalContentState {
  final String content;
  final bool isModified;
  final DateTime? lastModified;

  const JournalContentState({
    required this.content,
    this.isModified = false,
    this.lastModified,
  });

  JournalContentState copyWith({
    String? content,
    bool? isModified,
    DateTime? lastModified,
  }) {
    return JournalContentState(
      content: content ?? this.content,
      isModified: isModified ?? this.isModified,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalContentState &&
        other.content == content &&
        other.isModified == isModified &&
        other.lastModified == lastModified;
  }

  @override
  int get hashCode {
    return content.hashCode ^ isModified.hashCode ^ lastModified.hashCode;
  }

  @override
  String toString() {
    return 'JournalContentState(content: ${content.length} chars, isModified: $isModified, lastModified: $lastModified)';
  }
}

/// 周记编辑工具类
class JournalEditUtils {
  /// 检查内容是否为空
  static bool isEmpty(String content) {
    return content.trim().isEmpty;
  }

  /// 获取内容摘要
  static String getContentSummary(String content, {int maxLength = 100}) {
    if (isEmpty(content)) return '暂无内容';

    // 移除Markdown标记
    String cleanContent = content
        .replaceAll(RegExp(r'#{1,6}\s*'), '') // 移除标题标记
        .replaceAll(RegExp(r'\*{1,2}([^*]+)\*{1,2}'), r'$1') // 移除粗体/斜体标记
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1') // 移除代码标记
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1') // 移除链接标记
        .replaceAll(RegExp(r'\n+'), ' ') // 将换行替换为空格
        .trim();

    if (cleanContent.length <= maxLength) {
      return cleanContent;
    }

    return '${cleanContent.substring(0, maxLength)}...';
  }

  /// 统计字数
  static int getWordCount(String content) {
    if (isEmpty(content)) return 0;

    // 移除Markdown标记后统计字数
    String cleanContent = getContentSummary(content, maxLength: content.length);
    return cleanContent.length;
  }

  /// 验证内容格式
  static bool isValidMarkdown(String content) {
    // 简单的Markdown格式验证
    // 检查是否有未闭合的标记

    // 检查粗体标记
    int boldCount = RegExp(r'\*\*').allMatches(content).length;
    if (boldCount % 2 != 0) return false;

    // 检查斜体标记
    int italicCount = RegExp(r'(?<!\*)\*(?!\*)').allMatches(content).length;
    if (italicCount % 2 != 0) return false;

    // 检查代码块标记
    int codeBlockCount = RegExp(r'```').allMatches(content).length;
    if (codeBlockCount % 2 != 0) return false;

    return true;
  }

  /// 格式化内容
  static String formatContent(String content) {
    return content
        .replaceAll(RegExp(r'\n{3,}'), '\n\n') // 限制连续换行
        .replaceAll(RegExp(r'[ \t]+\n'), '\n') // 移除行尾空格
        .trim();
  }
}
