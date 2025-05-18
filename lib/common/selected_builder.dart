import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SelectedBuilder<A, B> extends StatefulWidget {
  /// Creates a [SelectedBuilder] that listens to three [ValueListenable]s
  /// and combines their values using a selector function.
  const SelectedBuilder({
    required this.valueListenable,
    required this.selector,
    required this.builder,
    super.key,
    this.child,
  });

  /// The first [ValueListenable] to observe.
  final ValueListenable<A> valueListenable;

  /// A function that selects the values from listenable into a single result value.
  final B Function(A) selector;

  /// A builder function which builds a widget depending on the selected value.
  final Widget Function(BuildContext context, B result, Widget? child) builder;

  /// An optional child widget that doesn't depend on the listenable.
  final Widget? child;

  @override
  State<SelectedBuilder<A, B>> createState() => _SelectedBuilderState<A, B>();
}

class _SelectedBuilderState<A, B> extends State<SelectedBuilder<A, B>> {
  late A value;
  late B selectedValue;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    selectedValue = widget.selector(value);

    widget.valueListenable.addListener(_updateValues);
  }

  @override
  void didUpdateWidget(SelectedBuilder<A, B> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_updateValues);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_updateValues);
    }

    // selectedValue = widget.selector(value);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_updateValues);
    super.dispose();
  }

  void _updateValues() {
    value = widget.valueListenable.value;

    final oldSelected = selectedValue;
    selectedValue = widget.selector(value);

    if (oldSelected != selectedValue) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, selectedValue, widget.child);
  }
}
