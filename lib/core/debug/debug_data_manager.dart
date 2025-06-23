/// 调试数据管理器
/// 用于收集和管理当前页面的调试数据
class DebugDataManager {
  static final DebugDataManager _instance = DebugDataManager._internal();
  factory DebugDataManager() => _instance;
  DebugDataManager._internal();

  // 当前页面数据
  Map<String, dynamic> _currentPageData = {};
  String _currentPageName = '';

  /// 设置当前页面数据
  void setCurrentPageData(String pageName, Map<String, dynamic> data) {
    _currentPageName = pageName;
    _currentPageData = data;
  }

  /// 获取当前页面名称
  String get currentPageName => _currentPageName;

  /// 获取当前页面数据
  Map<String, dynamic> get currentPageData => Map.from(_currentPageData);

  /// 添加或更新单个数据项
  void updateData(String key, dynamic value) {
    _currentPageData[key] = value;
  }

  /// 移除数据项
  void removeData(String key) {
    _currentPageData.remove(key);
  }

  /// 清空当前页面数据
  void clearData() {
    _currentPageData.clear();
    _currentPageName = '';
  }

  /// 获取格式化的调试信息
  String getFormattedDebugInfo() {
    if (_currentPageName.isEmpty) {
      return '📄 当前页面: 未知\n📊 数据: 无';
    }

    final buffer = StringBuffer();
    buffer.writeln('📄 当前页面: $_currentPageName');
    buffer.writeln('📊 页面数据:');
    
    if (_currentPageData.isEmpty) {
      buffer.writeln('  无数据');
    } else {
      _currentPageData.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }
    
    return buffer.toString();
  }

  /// 获取 JSON 格式的调试数据
  Map<String, dynamic> getDebugDataAsJson() {
    return {
      'pageName': _currentPageName,
      'pageData': _currentPageData,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
} 