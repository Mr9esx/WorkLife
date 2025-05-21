// 导入必要的包
import 'package:drift/drift.dart' hide JsonKey;  // 导入 Drift 包，hide 表示隐藏 JsonKey 以避免命名冲突
import 'package:WeekLife/data/database/tables/journal_writer_tbl.dart';  // 导入表定义
import 'package:WeekLife/data/repositories/journal_writer/journal_writer_repo.dart';  // 导入仓库类

/// Writer 数据模型
// 在 Dart 中，class 用于定义类，这是面向对象编程的基本单位
class JournalWriterData {
  // final 表示这些字段是只读的，一旦赋值就不能修改
  // 类型声明（如 int?, String）是 Dart 的类型系统的一部分，用于类型安全
  // ? 表示该字段可以为 null（空安全特性）
  final int? id;          // 可空的整数类型
  final String username;  // 非空的字符串类型
  final int gender;      // 非空的整数类型
  final DateTime birthDay;  // 非空的日期时间类型
  final String? avatar;    // 可空的字符串类型
  final String? birthPlace;  // 可空的字符串类型
  final DateTime createdAt;  // 非空的日期时间类型
  final DateTime? updatedAt;  // 可空的日期时间类型

  // const 构造函数，表示这是一个编译时常量构造函数
  // required 表示这些参数在创建对象时必须提供
  const JournalWriterData({
    this.id,              // 可选参数，因为 id 是可空的
    required this.username,  // 必需参数
    required this.gender,    // 必需参数
    required this.birthDay,  // 必需参数
    this.avatar,            // 可选参数
    this.birthPlace,        // 可选参数
    required this.createdAt, // 必需参数
    this.updatedAt,         // 可选参数
  });

  // factory 构造函数，用于从数据库实体创建数据模型
  // 工厂构造函数可以返回类的实例，而不是必须创建新实例
  factory JournalWriterData.fromDb(JournalWriter writer) => JournalWriterData(
    // 从数据库实体中提取数据并创建新的 JournalWriterData 实例
    id: writer.id,           // 直接访问数据库实体的字段
    username: writer.username,
    gender: writer.gender,
    birthDay: writer.birthDay,
    avatar: writer.avatar,
    birthPlace: writer.birthPlace,
    createdAt: writer.createdAt,
    updatedAt: writer.updatedAt,
  );

  // 将数据模型转换为数据库实体
  // 用于将数据保存到数据库
  JournalWriterTableCompanion toCompanion() => JournalWriterTableCompanion(
    // Value 是 Drift 提供的包装类，用于处理可空值
    id: id == null ? const Value.absent() : Value(id!),  // ! 表示非空断言
    username: Value(username),  // 非空值直接包装
    gender: Value(gender),
    birthDay: Value(birthDay),
    avatar: avatar == null ? const Value.absent() : Value(avatar!),
    birthPlace: birthPlace == null ? const Value.absent() : Value(birthPlace!),
    createdAt: Value(createdAt),
    updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
  );

  // copyWith 方法用于创建对象的副本，同时允许修改部分字段
  // 这是 Dart 中常用的不可变对象模式
  JournalWriterData copyWith({
    int? id,                // 所有参数都是可选的
    String? username,
    int? gender,
    DateTime? birthDay,
    String? avatar,
    String? birthPlace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // 使用 ?? 运算符，如果左侧为 null 则使用右侧的值
    return JournalWriterData(
      id: id ?? this.id,           // 如果新 id 为 null，使用当前对象的 id
      username: username ?? this.username,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      avatar: avatar ?? this.avatar,
      birthPlace: birthPlace ?? this.birthPlace,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// 查询条件类，用于构建数据库查询
class JournalWriterQuery {
  // 查询参数定义
  final int? id;
  final String? username;
  final int? gender;
  final DateTime? birthDay;
  final String? birthPlace;
  final DateTime? createdAtStart;
  final DateTime? createdAtEnd;
  final int? limit;      // 限制返回结果数量
  final int? offset;     // 分页偏移量
  final String? orderBy; // 排序字段
  final bool? orderDesc; // 是否降序排序

  // 构造函数
  JournalWriterQuery({
    this.id,
    this.username,
    this.gender,
    this.birthDay,
    this.birthPlace,
    this.createdAtStart,
    this.createdAtEnd,
    this.limit,
    this.offset,
    this.orderBy,
    this.orderDesc,
  });

  // 将查询条件转换为数据库查询表达式
  Expression<bool> Function(JournalWriterTable) toWhereClause() {
    // 返回一个函数，该函数接收表对象并返回查询条件
    return (tbl) {
      var conditions = <Expression<bool>>[];  // 创建条件列表
      
      // 根据参数构建查询条件
      if (id != null) {
        conditions.add(tbl.id.equals(id!));  // 添加 id 相等条件
      }
      if (username != null) {
        conditions.add(tbl.username.equals(username!));
      }
      // ... 其他条件类似

      // 使用 fold 方法将所有条件用 AND 连接
      return conditions.fold(
        const Constant(true),  // 初始值
        (prev, condition) => prev & condition,  // 组合条件
      );
    };
  }
}

// 枚举类型，用于定义排序字段
enum WriterSortField {
  id,
  username,
  createdAt,
  updatedAt,
}

// 枚举类型，用于定义排序顺序
enum SortOrder {
  asc,   // 升序
  desc,  // 降序
}