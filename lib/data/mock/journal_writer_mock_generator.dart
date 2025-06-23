import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';

/// Journal Writer Mock 数据生成器
/// 用于在调试模式下生成默认的测试数据，避免模拟器重启导致数据丢失
class JournalWriterMockGenerator {
  
  /// 生成默认的 Journal Writer 数据
  /// 
  /// 返回一个包含基本信息的默认用户数据
  static JournalWriterData generateDefaultWriter() {
    final now = DateTime.now();
    
    return JournalWriterData(
      // id 为 null，让数据库自动生成
      id: null,
      
      // 默认用户名
      username: '默认用户',
      
      // 当前用户标识，设为1表示这是主要用户
      currentWriter: 1,
      
      // 性别：1表示男性，2表示女性，这里默认设为1
      gender: 1,
      
      // 默认生日：1990年1月1日
      birthDay: DateTime(1995, 5, 30),
      
      // 默认头像（可选）
      avatar: null,
      
      // 默认出生地（可选）
      birthPlace: '肇庆',
      
      // 创建时间设为当前时间
      createdAt: now,
      
      // 更新时间为空
      updatedAt: null,
    );
  }
  
  /// 生成多个测试用户数据
  /// 
  /// [count] 要生成的用户数量，默认为3个
  /// 返回用户数据列表
  static List<JournalWriterData> generateMultipleWriters({int count = 3}) {
    final now = DateTime.now();
    final List<JournalWriterData> writers = [];
    
    final List<Map<String, dynamic>> userData = [
      {
        'username': '张三',
        'gender': 1,
        'birthDay': DateTime(1985, 3, 15),
        'birthPlace': '上海',
      },
      {
        'username': '李四',
        'gender': 2,
        'birthDay': DateTime(1992, 7, 22),
        'birthPlace': '广州',
      },
      {
        'username': '王五',
        'gender': 1,
        'birthDay': DateTime(1988, 11, 8),
        'birthPlace': '深圳',
      },
      {
        'username': '赵六',
        'gender': 2,
        'birthDay': DateTime(1995, 5, 12),
        'birthPlace': '杭州',
      },
      {
        'username': '钱七',
        'gender': 1,
        'birthDay': DateTime(1987, 9, 30),
        'birthPlace': '南京',
      },
    ];
    
    for (int i = 0; i < count && i < userData.length; i++) {
      final user = userData[i];
      writers.add(JournalWriterData(
        id: null,
        username: user['username'] as String,
        currentWriter: i + 1, // 每个用户有不同的currentWriter值
        gender: user['gender'] as int,
        birthDay: user['birthDay'] as DateTime,
        avatar: null,
        birthPlace: user['birthPlace'] as String,
        createdAt: now.subtract(Duration(days: i)), // 不同的创建时间
        updatedAt: null,
      ));
    }
    
    return writers;
  }
  
  /// 生成自定义的 Journal Writer 数据
  /// 
  /// [username] 用户名
  /// [gender] 性别（1:男，2:女）
  /// [birthYear] 出生年份
  /// [birthMonth] 出生月份
  /// [birthDay] 出生日期
  /// [birthPlace] 出生地（可选）
  /// [currentWriter] 当前用户标识（可选，默认为1）
  /// 
  /// 返回自定义的用户数据
  static JournalWriterData generateCustomWriter({
    required String username,
    required int gender,
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    String? birthPlace,
    int currentWriter = 1,
  }) {
    final now = DateTime.now();
    
    return JournalWriterData(
      id: null,
      username: username,
      currentWriter: currentWriter,
      gender: gender,
      birthDay: DateTime(birthYear, birthMonth, birthDay),
      avatar: null,
      birthPlace: birthPlace,
      createdAt: now,
      updatedAt: null,
    );
  }
  
  /// 获取性别显示文本
  /// 
  /// [gender] 性别代码（1:男，2:女）
  /// 返回性别的中文显示文本
  static String getGenderText(int gender) {
    switch (gender) {
      case 1:
        return '男';
      case 2:
        return '女';
      default:
        return '未知';
    }
  }
  
  /// 验证生成的数据是否有效
  /// 
  /// [writer] 要验证的用户数据
  /// 返回验证结果，true表示有效
  static bool validateWriterData(JournalWriterData writer) {
    // 检查必填字段
    if (writer.username.isEmpty) return false;
    if (writer.gender < 1 || writer.gender > 2) return false;
    if (writer.currentWriter < 1) return false;
    
    // 检查生日是否合理（不能是未来日期）
    if (writer.birthDay.isAfter(DateTime.now())) return false;
    
    // 检查年龄是否合理（假设最小年龄为0岁，最大年龄为150岁）
    final age = DateTime.now().year - writer.birthDay.year;
    if (age < 0 || age > 150) return false;
    
    return true;
  }
} 