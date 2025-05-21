import 'package:WeekLife/common/constants/writer_constants.dart';
import 'package:WeekLife/common/exceptions/writer_exceptions.dart';

/// Writer 数据验证器
class WriterValidator {
  /// 验证用户名
  /// 
  /// [username] 要验证的用户名
  /// 
  /// 可能抛出的异常:
  /// - [WriterValidationException] 当用户名不符合要求时
  static void validateUsername(String username) {
    if (username.isEmpty) {
      throw WriterValidationException('用户名不能为空');
    }
    if (username.length < WriterConstants.minUsernameLength) {
      throw WriterValidationException('用户名长度不能小于${WriterConstants.minUsernameLength}个字符');
    }
    if (username.length > WriterConstants.maxUsernameLength) {
      throw WriterValidationException('用户名长度不能超过${WriterConstants.maxUsernameLength}个字符');
    }
    // 如果需要限制用户名字符类型,可以取消下面的注释
    // if (!RegExp(r'^[a-zA-Z0-9_\u4e00-\u9fa5]+$').hasMatch(username)) {
    //   throw WriterValidationException('用户名只能包含字母、数字、下划线和中文');
    // }
  }

  /// 验证性别
  /// 
  /// [gender] 要验证的性别值
  /// 
  /// 可能抛出的异常:
  /// - [WriterValidationException] 当性别值无效时
  static void validateGender(int gender) {
    if (gender != WriterConstants.genderMale && gender != WriterConstants.genderFemale) {
      throw WriterValidationException('无效的性别值，必须是${WriterConstants.genderMale}(男)或${WriterConstants.genderFemale}(女)');
    }
  }

  /// 验证生日
  /// 
  /// [birthDay] 要验证的生日
  /// 
  /// 可能抛出的异常:
  /// - [WriterValidationException] 当生日无效时
  static void validateBirthDay(DateTime birthDay) {
    if (birthDay.year < WriterConstants.minBirthYear || birthDay.year > WriterConstants.maxBirthYear) {
      throw WriterValidationException('无效的生日年份，必须在${WriterConstants.minBirthYear}-${WriterConstants.maxBirthYear}之间');
    }
    try {
      DateTime(birthDay.year, birthDay.month, birthDay.day);
    } catch (e) {
      throw WriterValidationException('无效的日期');
    }
  }
} 