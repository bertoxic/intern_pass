
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intern_pass/src/ui/RegisterPage/register_page.dart';
import 'package:intern_pass/src/ui/loginPage/login_view.dart';

import '../src/ui/Homepage/homepage.dart';
import '../src/ui/mainWrapper/main_wrapper.dart';


// ollama run qwen2.5-coder:7b 'show me how to use the go_router in flutter and its shell route' | glow

final  _rootNavigatorKey = GlobalKey<NavigatorState>();
final  _rootNavigatorHome = GlobalKey<NavigatorState>();
final  _rootNavigatorProfile = GlobalKey<NavigatorState>();
final  _rootNavigatorSettings = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
    initialLocation: '/home_page',
    navigatorKey: _rootNavigatorKey,
    routes:[
  StatefulShellRoute.indexedStack(builder: (context, state, navigationShell)=>MainPageWrapper(navigationShell: navigationShell,), branches: <StatefulShellBranch>[
    StatefulShellBranch(
        initialLocation: "/home_page",
        navigatorKey: _rootNavigatorHome,
        routes: [
          GoRoute(path: "/home_page",
          name: "home_page",
          builder: (BuildContext context, GoRouterState state) =>
              HomePage(key: state.pageKey,),)


        ]),
    StatefulShellBranch(
        initialLocation: "/profile_page",
        navigatorKey: _rootNavigatorProfile,
        routes: [
          GoRoute(path: "/profile_page",
            name: "profile_page",
            builder: (BuildContext context, GoRouterState state) =>
                SignUpView(key: state.pageKey,),)
        ])
  ],),
  
]);

get routes => _router;