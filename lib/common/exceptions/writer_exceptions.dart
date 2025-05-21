/// Writer 相关异常定义

/// Writer 数据验证异常
class WriterValidationException implements Exception {
  final String message;
  WriterValidationException(this.message);
  
  @override
  String toString() => message;
}

/// Writer 数据库操作异常
class WriterDatabaseException implements Exception {
  final String message;
  WriterDatabaseException(this.message);
  
  @override
  String toString() => message;
}

/// Writer 业务逻辑异常
class WriterBusinessException implements Exception {
  final String message;
  final String code;
  final dynamic details;
  
  const WriterBusinessException(this.message, {required this.code, this.details});
  
  factory WriterBusinessException.validation(String message) => 
    WriterBusinessException(message, code: 'VALIDATION_ERROR');
    
  factory WriterBusinessException.database(String message) => 
    WriterBusinessException(message, code: 'DATABASE_ERROR');
    
  @override
  String toString() => 'WriterBusinessException: $message (code: $code)';
} 