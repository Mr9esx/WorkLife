import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/common/utils/text_utils.dart';
import 'package:forui/forui.dart';

/// 轻量级富文本编辑器
class MarkdownEditor extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;

  const MarkdownEditor({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isPreviewMode = false;
  late String _initialTextMD5;
  bool _isToolbarReady = false; // 工具栏是否准备就绪
  bool _isStyleSheetReady = false; // 样式表是否准备就绪

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _initialTextMD5 = TextUtils.calculateMD5(widget.initialText);

    // 延迟初始化工具栏和样式表
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _isToolbarReady = true;
          _isStyleSheetReady = true;
        });
      }
    });

    // 延迟弹起键盘
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPreviewMode && mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 检查是否有未保存的更改
  bool _hasUnsavedChanges() {
    return !TextUtils.areTextsEqual(_controller.text, widget.initialText);
  }

  /// 显示关闭确认对话框
  Future<bool> _showCloseConfirmDialog() async {
    if (!_hasUnsavedChanges()) {
      return true;
    }

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认关闭'),
            content: const Text('您有未保存的更改，确定要关闭吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showCloseConfirmDialog();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.appBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示器
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 顶部操作栏
              _buildTopActionBar(),

              const SizedBox(height: 8),

              // 编辑/预览区域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isPreviewMode ? _buildPreviewWidget() : _buildEditorWidget(),
                ),
              ),

              const SizedBox(height: 8),

              // 工具栏（懒加载）
              if (_isToolbarReady) _buildToolbar() else const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部操作栏
  Widget _buildTopActionBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.appBackground.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧标题
          Text(
            '编辑周记',
            style: AppTextStyles.editorTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          // 右侧取消按钮
          GestureDetector(
            onTap: () async {
              HapticFeedback.selectionClick();
              if (await _showCloseConfirmDialog()) {
                if (mounted) Navigator.pop(context);
              }
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(),
              child: const Center(
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建编辑器组件
  Widget _buildEditorWidget() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: null,
      expands: true,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      style: AppTextStyles.editorInput.copyWith(
        fontSize: 16,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: '在这里记录本周的故事...',
        hintStyle: AppTextStyles.placeholderText.copyWith(
          fontSize: 14,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      cursorColor: AppColors.primary,
      cursorWidth: 2,
    );
  }

  /// 构建预览组件（懒加载样式表）
  Widget _buildPreviewWidget() {
    final content = _controller.text.trim();

    if (content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility,
              size: 48,
              color: AppColors.secondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无内容预览',
              style: AppTextStyles.placeholderText.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: _isStyleSheetReady
              ? MarkdownBody(
                  data: content.replaceAll('\n', '  \n'),
                  styleSheet: _getMarkdownStyleSheet(),
                  selectable: true,
                  shrinkWrap: true,
                  fitContent: false,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  /// 获取统一的 Markdown 样式配置
  MarkdownStyleSheet _getMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      p: AppTextStyles.markdownParagraph,
      h1: AppTextStyles.markdownH1,
      h2: AppTextStyles.markdownH2,
      h3: AppTextStyles.markdownH3,
      h4: AppTextStyles.markdownH4,
      h5: AppTextStyles.markdownH5,
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
      // 表格样式配置
      tableHead: AppTextStyles.markdownParagraph.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tableBody: AppTextStyles.markdownParagraph,
      tableBorder: TableBorder.all(
        color: AppColors.borderColor, // 使用边框颜色而不是红色
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(8),
      tableColumnWidth: const FlexColumnWidth(),
      // 分割线样式配置
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor, // 使用边框颜色而不是红色
            width: 1,
          ),
        ),
      ),
    );
  }

  /// 构建工具栏（简化版，只保留格式化工具）
  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.appBackground.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 预览按钮（固定在左侧）
          _buildPreviewButton(),

          const SizedBox(width: 8),

          // 分隔线
          Container(
            height: 32,
            width: 1,
            color: AppColors.secondary.withOpacity(0.3),
          ),

          const SizedBox(width: 8),

          // 格式化工具（可滚动）
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFormatButton(
                    Icons.format_bold,
                    '粗体',
                    () => _insertFormat('**', '**', '粗体文字'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.format_italic,
                    '斜体',
                    () => _insertFormat('*', '*', '斜体文字'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.title,
                    '标题',
                    () => _insertFormat('# ', '', '标题'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.format_list_bulleted,
                    '列表',
                    () => _insertFormat('- ', '', '列表项'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.format_quote,
                    '引用',
                    () => _insertFormat('> ', '', '引用内容'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.code,
                    '代码',
                    () => _insertFormat('`', '`', '代码'),
                  ),
                  const SizedBox(width: 8),
                  _buildFormatButton(
                    Icons.access_time,
                    '时间',
                    _insertCurrentTime,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 分隔线
          Container(
            height: 32,
            width: 1,
            color: AppColors.secondary.withOpacity(0.3),
          ),

          const SizedBox(width: 8),

          // 保存按钮（固定在最右侧）
          _buildSaveButton(),
        ],
      ),
    );
  }

  /// 构建保存按钮
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onSave(_controller.text);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.check,
          size: 18,
          color: AppColors.cardBackground,
        ),
      ),
    );
  }

  /// 构建预览按钮
  Widget _buildPreviewButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _isPreviewMode = !_isPreviewMode;
        });

        // 如果切换到编辑模式，重新获取焦点
        if (!_isPreviewMode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.requestFocus();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isPreviewMode ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPreviewMode ? AppColors.primary : AppColors.borderColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: _isPreviewMode
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Icon(
          _isPreviewMode ? Icons.edit : Icons.visibility,
          size: 18,
          color: _isPreviewMode ? AppColors.cardBackground : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _insertFormat(String prefix, String suffix, String defaultText) {
    final selection = _controller.selection;
    final text = _controller.text;

    String selectedText = '';
    int start = selection.start;
    int end = selection.end;

    if (selection.isValid && !selection.isCollapsed) {
      selectedText = text.substring(start, end);
    } else {
      selectedText = defaultText;
      // 如果没有选中文本，在光标位置插入
      start = selection.start >= 0 ? selection.start : text.length;
      end = start;
    }

    final newText = '$prefix$selectedText$suffix';
    final beforeText = text.substring(0, start);
    final afterText = text.substring(end);

    final newFullText = '$beforeText$newText$afterText';
    final newCursorPosition = start + newText.length;

    _controller.text = newFullText;
    _controller.selection = TextSelection.collapsed(offset: newCursorPosition);

    // 保持焦点
    _focusNode.requestFocus();
  }

  void _insertCurrentTime() {
    final now = DateTime.now();
    final timeString =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _insertFormat('**$timeString** ', '', '');
  }

  /// 显示编辑器（简化版本）
  static void show({
    required BuildContext context,
    required String initialText,
    required Function(String) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false, // 禁止点击外部关闭
      enableDrag: false, // 禁止拖拽关闭
      builder: (context) => MarkdownEditor(
        initialText: initialText,
        onSave: onSave,
      ),
    );
  }
}
