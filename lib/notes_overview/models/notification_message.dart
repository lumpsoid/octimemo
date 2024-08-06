/// [UniqueNotification] to make a unique message
/// each object will be treated as unique
class UniqueNotification {
  /// Default constructor for the [UniqueNotification]
  UniqueNotification(this.value)
      : timestamp = DateTime.now().millisecondsSinceEpoch;

  const UniqueNotification.empty()
      : timestamp = 0,
        value = '';

  final String value;
  final int timestamp;
}
