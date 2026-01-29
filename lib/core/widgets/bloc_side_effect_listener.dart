import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSideEffectListener<B extends BlocBase, E> extends StatefulWidget {
  final void Function(E)? listener;
  final Widget child;

  const BlocSideEffectListener({
    super.key,
    this.listener,
    required this.child,
  });

  @override
  State<BlocSideEffectListener<B, E>> createState() => _BlocSideEffectListenerState<B, E>();
}

class _BlocSideEffectListenerState<B extends BlocBase, E>
    extends State<BlocSideEffectListener<B, E>> {
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = (context.read<B>() as BlocSideEffectMixin<B, E>).sideEffects.listen((effect) {
      widget.listener?.call(effect);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

mixin BlocSideEffectMixin<B extends BlocBase, E> {

  Stream<E> get sideEffects => throw UnimplementedError();
}