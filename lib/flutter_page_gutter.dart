import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// [DefaultPageController] builder
typedef PageControllerBuilder = Widget Function(
    BuildContext context, PageController controller);

/// Used to add gaps between each page of [PageView].
///
/// ```dart
/// PageView.builder(
///  controller: pageController,
///  itemBuilder: (context, index) => PageGutter(
///    controller: pageController
///    index: index,
///    gap: 5,
///    child: Placeholder(),
///  ),
/// );
/// ```
class PageGutter extends StatefulWidget {
  const PageGutter({
    super.key,
    this.controller,
    required this.gap,
    required this.index,
    required this.child,
  }) : assert(gap >= 0);

  /// Manually pass [PageController]. If not provided, it will be obtained by
  /// default through [DefaultPageController].
  final PageController? controller;

  /// The gap between each page.
  final double gap;

  /// Current page index.
  final int index;

  final Widget child;

  @override
  State<PageGutter> createState() => _PageGutterState();
}

class _PageGutterState extends State<PageGutter> {
  PageController? controller;
  late Axis axis;
  Offset offset = Offset.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAxis();
    _updateController();
  }

  @override
  void didUpdateWidget(covariant PageGutter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Scrollable.maybeOf(context)?.position.axis != axis) {
      _updateAxis();
    }
    if (oldWidget.controller != widget.controller) {
      _updateController();
    } else if (oldWidget.gap != widget.gap) {
      _invalidate();
    }
  }

  @override
  void dispose() {
    controller?.removeListener(_invalidate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: offset, child: widget.child);
  }

  void _updateController() {
    controller?.removeListener(_invalidate);
    controller = widget.controller ?? DefaultPageController.maybeOf(context);
    controller?.addListener(_invalidate);
    _invalidate();
  }

  void _updateAxis() {
    axis = Scrollable.maybeOf(context)?.position.axis ?? Axis.horizontal;
    _invalidate();
  }

  double get delta => axis == Axis.horizontal ? offset.dx : offset.dy;

  Offset newOffset(double delta) {
    return Offset(
      axis == Axis.horizontal ? delta : 0,
      axis == Axis.vertical ? delta : 0,
    );
  }

  void _invalidate() {
    var oldDelta = delta;
    var newDelta = _updateDelta();
    if (oldDelta != newDelta) {
      setState(() => offset = newOffset(newDelta));
    }
  }

  double _updateDelta() {
    if (controller == null) {
      return 0;
    }

    if (controller!.positions.length == 1 &&
        controller!.position.hasContentDimensions) {
      final fraction = widget.index - controller!.page!;
      return widget.gap * fraction;
    }

    if (widget.index < controller!.initialPage) {
      return -widget.gap;
    } else if (widget.index > controller!.initialPage) {
      return widget.gap;
    }

    return 0;
  }
}

/// Passing [PageController] to the child widget through the [InheritedWidget]
/// feature does not require the display of [PageController] being passed to
/// [PageGutter.controller].
///
/// ```dart
/// DefaultPageController(
///  controller: pageController,
//   builder: PageView.builder(
//    controller: pageController,
//    itemBuilder: (context, index) => PageGutter(
//      index: index,
//      gap: 5,
//      child: Placeholder(),
//    ),
//  ),
// )
//
/// DefaultPageController.builder(
//   viewportFraction: 0.9,
//   initialPage: 1,
//   builder: (context, controller) {
//     return PageView.builder(
//       controller: controller,
//       itemBuilder: (context, index) => PageGutter(
//         index: index,
//         gap: 5,
//         child: Placeholder(),
//       ),
//     );
//   },
// )
/// ```
class DefaultPageController extends StatefulWidget {
  /// Pass the existing [PageController]
  const DefaultPageController({
    super.key,
    required Widget child,
    required PageController controller,
  })  : _controller = controller,
        _child = child,
        _builder = null,
        _initialPage = null,
        _keepPage = null,
        _viewportFraction = null;

  /// By building the [PageController] internally, obtain the created
  /// [PageController] through [builder], which can be passed to [PageView].
  const DefaultPageController.builder({
    super.key,
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    required PageControllerBuilder builder,
  })  : _child = null,
        _controller = null,
        _builder = builder,
        _initialPage = initialPage,
        _keepPage = keepPage,
        _viewportFraction = viewportFraction;

  static PageController of(BuildContext context) {
    return maybeOf(context)!;
  }

  static PageController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PageControllerScope>()
        ?.controller;
  }

  final PageController? _controller;
  final PageControllerBuilder? _builder;
  final int? _initialPage;
  final bool? _keepPage;
  final double? _viewportFraction;
  final Widget? _child;

  bool get _isBuilder {
    return _child == null && _controller == null && _builder != null;
  }

  @override
  State<DefaultPageController> createState() => _DefaultPageControllerState();
}

class _DefaultPageControllerState extends State<DefaultPageController> {
  PageController? selfController;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    _recreateController();
  }

  @override
  void didUpdateWidget(covariant DefaultPageController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._isBuilder != oldWidget._isBuilder ||
        widget._keepPage != oldWidget._keepPage ||
        widget._viewportFraction != oldWidget._viewportFraction) {
      _recreateController();
    }
  }

  @override
  void dispose() {
    selfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget._child ?? widget._builder!(context, controller);
    return _PageControllerScope(controller: controller, child: child);
  }

  void _recreateController() {
    selfController?.dispose();

    if (widget._isBuilder) {
      controller = selfController = PageController(
        initialPage: widget._initialPage!,
        keepPage: widget._keepPage!,
        viewportFraction: widget._viewportFraction!,
      );
    } else {
      controller = widget._controller!;
    }
  }
}

class _PageControllerScope extends InheritedWidget {
  const _PageControllerScope({required super.child, this.controller});

  final PageController? controller;

  @override
  bool updateShouldNotify(covariant _PageControllerScope oldWidget) {
    return oldWidget.controller != controller;
  }
}
