import 'dart:convert';
import 'package:crypto/crypto.dart';

class TextUtils {
  /// 计算文本的 MD5 值
  static String calculateMD5(String text) {
    final bytes = utf8.encode(text);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 比较两段文本是否相同（使用 MD5）
  static bool areTextsEqual(String text1, String text2) {
    return calculateMD5(text1) == calculateMD5(text2);
  }
}
