import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SlideRightRouteWithBuilder extends PageRouteBuilder {
  final Widget Function(BuildContext, Animation<double>, Animation<double>)
      builder;
  @override
  RouteSettings settings;
  SlideRightRouteWithBuilder({required this.builder, required this.settings})
      : super(
          pageBuilder: builder,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.black,
              child: child,
            );
          },
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionDuration: const Duration(milliseconds: 500),
        );
}

class ScaleRouteWithBuilder extends PageRouteBuilder {
  final Widget Function(BuildContext, Animation<double>, Animation<double>)
      builder;
  @override
  RouteSettings settings;
  ScaleRouteWithBuilder({required this.builder, required this.settings})
      : super(
          pageBuilder: builder,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              fillColor: Colors.black,
              child: child,
            );
          },
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionDuration: const Duration(milliseconds: 600),
        );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  @override
  RouteSettings settings;
  SlideRightRoute({required this.page, required this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.black,
              child: child,
            );
          },
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  RouteSettings settings;
  FadeRoute({required this.page, required this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const double begin = 0.0;
            const double end = 1;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: offsetAnimation,
              // position: offsetAnimation,
              child: child,
            );
          },
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionDuration: const Duration(milliseconds: 300),
        );
}
