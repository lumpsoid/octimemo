import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MultiBuilder<A, B> extends StatefulWidget {
  /// Creates a [MultiBuilder] that listens to three [ValueListenable]s
  /// and combines their values using a selector function.
  const MultiBuilder({
    required this.first,
    required this.second,
    required this.builder,
    super.key,
    this.child,
  });

  /// The first [ValueListenable] to observe.
  final ValueListenable<A> first;

  /// The second [ValueListenable] to observe.
  final ValueListenable<B> second;

  /// A builder function which builds a widget depending on the multi values.
  final Widget Function(BuildContext context, A first, B second, Widget? child)
      builder;

  /// An optional child widget that doesn't depend on the listenables.
  final Widget? child;

  @override
  State<MultiBuilder<A, B>> createState() => _MultiBuilderState<A, B>();
}

class _MultiBuilderState<A, B> extends State<MultiBuilder<A, B>> {
  late A firstValue;
  late B secondValue;

  @override
  void initState() {
    super.initState();
    firstValue = widget.first.value;
    secondValue = widget.second.value;

    widget.first.addListener(_updateValues);
    widget.second.addListener(_updateValues);
  }

  @override
  void didUpdateWidget(MultiBuilder<A, B> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.first != widget.first) {
      oldWidget.first.removeListener(_updateValues);
      firstValue = widget.first.value;
      widget.first.addListener(_updateValues);
    }

    if (oldWidget.second != widget.second) {
      oldWidget.second.removeListener(_updateValues);
      secondValue = widget.second.value;
      widget.second.addListener(_updateValues);
    }
  }

  @override
  void dispose() {
    widget.first.removeListener(_updateValues);
    widget.second.removeListener(_updateValues);
    super.dispose();
  }

  void _updateValues() {
    setState(() {
      firstValue = widget.first.value;
      secondValue = widget.second.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, firstValue, secondValue, widget.child);
  }
}
