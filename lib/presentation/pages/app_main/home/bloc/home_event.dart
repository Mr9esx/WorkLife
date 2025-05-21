abstract class HomeEvent {}

class IncrementEvent extends HomeEvent {}
class DecrementEvent extends HomeEvent {}
class InitDatabaseEvent extends HomeEvent {}
class RefreshWriterEvent extends HomeEvent {}
class CreateWriterEvent extends HomeEvent {}
class UpdateWriterNameEvent extends HomeEvent {} 