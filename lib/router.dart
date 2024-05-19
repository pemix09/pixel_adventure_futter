import 'package:go_router/go_router.dart';
import 'package:pixel_adventure/screens/game.dart';
import 'package:pixel_adventure/screens/menu.dart';

final router = GoRouter(
  initialLocation: '/game',
  routes: [
    GoRoute(
      path: '/menu',
      builder: (context, state) => const Menu(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen()
    ),
  ],
);
