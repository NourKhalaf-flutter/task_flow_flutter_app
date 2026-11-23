 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/widgets/bottom_nav_bar_widget.dart';
import 'package:task_flow/features/auth/login_provider.dart';
import 'package:task_flow/features/home/home_screen.dart';
import 'package:task_flow/features/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int? selectedeIndex;
  const MainScreen({this.selectedeIndex, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState( );
}

class _MainScreenState extends State<MainScreen> {
  final screenList = <Widget>[
    const HomeScreen(),
    
    const ProfileScreen(),
  ];

  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  
 @override
  void initState() {
     super.initState();
      Future.microtask(() {
    context.read<LoginProvider>().loadUserData();
  });
     if( widget.selectedeIndex!=null)   _selectedIndex = widget.selectedeIndex ?? 0;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavTapped,
      ),
      body: SafeArea(
        bottom: false,
        child: screenList[_selectedIndex],
      ),
    );
  }
}
