import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:WeekLife/presentation/pages/app_main/home/provider/counterStore.p.dart';

List<SingleChildWidget> providersConfig = [
  ChangeNotifierProvider<CounterStore>(create: (_) => CounterStore()),
];
