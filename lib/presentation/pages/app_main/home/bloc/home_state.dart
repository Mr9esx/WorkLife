import 'package:WeekLife/data/models/journal_writer/journal_writer_data.dart';

class HomeState {
  final int counter;
  final bool isDbInitialized;
  final bool isInitializing;
  final JournalWriterData? writer;
  final String? errorMsg;

  HomeState({
    this.counter = 0,
    this.isDbInitialized = false,
    this.isInitializing = false,
    this.writer,
    this.errorMsg,
  });

  HomeState copyWith({
    int? counter,
    bool? isDbInitialized,
    bool? isInitializing,
    JournalWriterData? writer,
    String? errorMsg,
  }) {
    return HomeState(
      counter: counter ?? this.counter,
      isDbInitialized: isDbInitialized ?? this.isDbInitialized,
      isInitializing: isInitializing ?? this.isInitializing,
      writer: writer ?? this.writer,
      errorMsg: errorMsg,
    );
  }
} 