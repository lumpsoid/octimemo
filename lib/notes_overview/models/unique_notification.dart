/// [UniqueNotification] to make a unique message
/// each object will be treated as unique
class UniqueNotification {
  /// Default constructor for the [UniqueNotification]
  UniqueNotification(this.value);

  const UniqueNotification.empty() : value = '';

  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is UniqueNotification) return false;
    return super == other;
  }

  @override
  int get hashCode => value.hashCode;
}
