import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intern_pass/core/utils/responsive/responsivex_size.dart';

import '../../../core/utils/globalError.dart';
import '../../widgets/custom_navigationbar.dart';



class MainPageWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainPageWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainPageWrapper> createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> with WidgetsBindingObserver   {
  late Future<void> _initializationFuture;
  bool _isInitializing = true;
  Object? _initializationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set up global error handling
    ErrorWidget.builder = _buildErrorWidget;

    // Trigger initialization
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig().init(context);  // Manually initializing SizeConfig
  }
  // Improved initialization method with error handling
  Future<void> _initializeApp() async {
    if (!mounted){

    }
    setState(() {
      _isInitializing = true;
      _initializationError = null;
    });

    try {
      await _initialize();
      setState(() => _isInitializing = false);
    } catch (error) {
      setState(() {
        _isInitializing = false;
        _initializationError = error;
      });
    }
  }

  // Placeholder for actual initialization logic
  Future<void> _initialize() async {
    // will implement  initialization logic here
    // This  include:
    // - Setting up databases
    // - Loading initial configurations
    // - Checking network connectivity
    // - Authenticating user
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
  }

  // Centralized error handling method
  void _handleInitializationError() {
    if (_initializationError != null) {
      handleGlobalError(context, _initializationError);
    }
  }

  // Custom error widget builder
  Widget _buildErrorWidget(FlutterErrorDetails details) {
    if(!mounted) return const SizedBox.shrink();
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
               SizedBox(height: 16.h),
              Text(
                'An unexpected error occurred',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                details.exception.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeApp,
                child: const Text('Retry Initialization'),
              ),
            ],
          ),
        ),
      ),
    ).responsive(  // Using responsive builder
      mobile: (context, child) => child!,
      tablet: (context, child) => Center(child: child),
      desktop: (context, child) => Align(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator during initialization
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    // Show error screen if initialization failed
    if (_initializationError != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Initialization Failed'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeApp,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Main app layout
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main content (navigation shell)
          Positioned.fill(
            child: widget.navigationShell,
          ),

          // Positioned bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 2.h,
            child: CustomBottomNavBar(items: [
              BottomNavItem(icon: Icons.home),
              BottomNavItem(icon: Icons.send_and_archive_rounded),
              BottomNavItem(icon: Icons.format_align_center),
              BottomNavItem(icon: Icons.person),
            ], onItemSelected: (int index){
                setState(() {
                  goToBranch(index);
                });
            }),
          ),
        ],
      ),
    );
  }

  Future<void> goToBranch(int index) async{
    widget.navigationShell.goBranch(index,
    initialLocation: index ==widget.navigationShell.currentIndex
    );
  }
}

