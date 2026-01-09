/// Base class for ad controller state enums.
///
/// All ad state enums should extend this class to maintain consistency.
/// The state values must be in the same order: initial(0), loading(1), loaded(2), error(3)
/// to ensure the state index can be used by the schedulers.
abstract class AdStateBase {
  /// The numeric index of this state (used by schedulers).
  int get index;

  /// Helper to check if state is loading.
  bool get isLoading;

  /// Helper to check if state is loaded.
  bool get isLoaded;

  /// Helper to check if state is error.
  bool get hasError;
}
