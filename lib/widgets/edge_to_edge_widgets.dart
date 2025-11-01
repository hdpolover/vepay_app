import 'package:flutter/material.dart';

/// A widget that handles system UI insets properly for edge-to-edge display
/// Use this wrapper for screens that need to respect system bars
class EdgeToEdgeSafeArea extends StatelessWidget {
  const EdgeToEdgeSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = false,
    this.right = false,
    this.maintainBottomViewPadding = false,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

/// A widget that adds proper padding for system UI while maintaining edge-to-edge display
class EdgeToEdgePadding extends StatelessWidget {
  const EdgeToEdgePadding({
    super.key,
    required this.child,
    this.includeTop = true,
    this.includeBottom = true,
  });

  final Widget child;
  final bool includeTop;
  final bool includeBottom;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;

    return Padding(
      padding: EdgeInsets.only(
        top: includeTop ? padding.top : 0,
        bottom: includeBottom ? padding.bottom : 0,
      ),
      child: child,
    );
  }
}

/// A custom Scaffold that handles edge-to-edge display properly
class EdgeToEdgeScaffold extends StatelessWidget {
  const EdgeToEdgeScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body != null
          ? EdgeToEdgeSafeArea(
              top: appBar == null && !extendBodyBehindAppBar,
              bottom: bottomNavigationBar == null && !extendBody,
              child: body!,
            )
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}
