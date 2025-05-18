import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ComposedBuilder3<A, B, C, R> extends StatefulWidget {
  /// Creates a [ComposedBuilder3] that listens to three [ValueListenable]s
  /// and combines their values using a selector function.
  const ComposedBuilder3({
    required this.first,
    required this.second,
    required this.third,
    required this.composer,
    required this.builder,
    super.key,
    this.child,
  });

  /// The first [ValueListenable] to observe.
  final ValueListenable<A> first;

  /// The second [ValueListenable] to observe.
  final ValueListenable<B> second;

  /// The third [ValueListenable] to observe.
  final ValueListenable<C> third;

  /// A function that combines the values from all three listenables into a single result value.
  final R Function(A, B, C) composer;

  /// A builder function which builds a widget depending on the combined result value.
  final Widget Function(BuildContext context, R result, Widget? child) builder;

  /// An optional child widget that doesn't depend on the listenables.
  final Widget? child;

  @override
  State<ComposedBuilder3<A, B, C, R>> createState() =>
      _ComposedBuilder3State<A, B, C, R>();
}

class _ComposedBuilder3State<A, B, C, R>
    extends State<ComposedBuilder3<A, B, C, R>> {
  late A firstValue;
  late B secondValue;
  late C thirdValue;
  late R result;

  @override
  void initState() {
    super.initState();
    firstValue = widget.first.value;
    secondValue = widget.second.value;
    thirdValue = widget.third.value;
    result = widget.composer(firstValue, secondValue, thirdValue);

    widget.first.addListener(_updateValues);
    widget.second.addListener(_updateValues);
    widget.third.addListener(_updateValues);
  }

  @override
  void didUpdateWidget(ComposedBuilder3<A, B, C, R> oldWidget) {
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

    if (oldWidget.third != widget.third) {
      oldWidget.third.removeListener(_updateValues);
      thirdValue = widget.third.value;
      widget.third.addListener(_updateValues);
    }

    result = widget.composer(firstValue, secondValue, thirdValue);
  }

  @override
  void dispose() {
    widget.first.removeListener(_updateValues);
    widget.second.removeListener(_updateValues);
    widget.third.removeListener(_updateValues);
    super.dispose();
  }

  void _updateValues() {
    setState(() {
      firstValue = widget.first.value;
      secondValue = widget.second.value;
      thirdValue = widget.third.value;
      result = widget.composer(firstValue, secondValue, thirdValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, result, widget.child);
  }
}

class ComposedBuilder2<A, B, R> extends StatefulWidget {
  /// Creates a [ComposedBuilder2] that listens to three [ValueListenable]s
  /// and combines their values using a selector function.
  const ComposedBuilder2({
    required this.first,
    required this.second,
    required this.composer,
    required this.builder,
    super.key,
    this.child,
  });

  /// The first [ValueListenable] to observe.
  final ValueListenable<A> first;

  /// The second [ValueListenable] to observe.
  final ValueListenable<B> second;

  /// A function that combines the values from all three listenables into a single result value.
  final R Function(A, B) composer;

  /// A builder function which builds a widget depending on the combined result value.
  final Widget Function(BuildContext context, R result, Widget? child) builder;

  /// An optional child widget that doesn't depend on the listenables.
  final Widget? child;

  @override
  State<ComposedBuilder2<A, B, R>> createState() =>
      _ComposedBuilderState2<A, B, R>();
}

class _ComposedBuilderState2<A, B, R> extends State<ComposedBuilder2<A, B, R>> {
  late A firstValue;
  late B secondValue;
  late R result;

  @override
  void initState() {
    super.initState();
    firstValue = widget.first.value;
    secondValue = widget.second.value;
    result = widget.composer(firstValue, secondValue);

    widget.first.addListener(_updateValues);
    widget.second.addListener(_updateValues);
  }

  @override
  void didUpdateWidget(ComposedBuilder2<A, B, R> oldWidget) {
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

    result = widget.composer(firstValue, secondValue);
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
      result = widget.composer(firstValue, secondValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, result, widget.child);
  }
}
