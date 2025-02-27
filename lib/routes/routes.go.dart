
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/mainWrapper/main_wrapper.dart';


// ollama run qwen2.5-coder:7b 'show me how to use the go_router in flutter and its shell route' | glow

final  _rootNavigatorKey = GlobalKey<NavigatorState>();
final  _rootNavigatorHome = GlobalKey<NavigatorState>();
final  _rootNavigatorProfile = GlobalKey<NavigatorState>();
final  _rootNavigatorSettings = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(routes:[
  StatefulShellRoute.indexedStack(builder: (context, state, navigationShell)=>MainPageWrapper(navigationShell: navigationShell,), branches: <StatefulShellBranch>[
    StatefulShellBranch( 
        initialLocation: "/home_page",
        navigatorKey: _rootNavigatorHome,
        routes: [
          GoRoute(path: "/home_page")
        ]),
    StatefulShellBranch(
        initialLocation: "/profile_page",
        navigatorKey: _rootNavigatorProfile,
        routes: [])
  ],),
  
]);

get routes => _router;