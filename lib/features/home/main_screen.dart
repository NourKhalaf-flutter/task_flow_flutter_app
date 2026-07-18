 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/widgets/bottom_nav_bar_widget.dart';
import 'package:task_flow/features/auth/auth_provider.dart';
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

  final _titleList = <String>['',  'My Profile'];
  int _selectedIndex =0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  
 @override
  void initState() {
     super.initState();
      Future.microtask(() {
    context.read<AuthProvider>().loadUserData();
  });
     if( widget.selectedeIndex!=null)   _selectedIndex = widget.selectedeIndex ?? 0;

  }
  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: Scaffold(
       // extendBody: true,
       //  appBar: AppBarWidget(title: _titleList[_selectedIndex], tag: 'main'),
      //  drawer: const DrawerWidget(),
        bottomNavigationBar: BottomNavBarWidget(
          selectedIndex: _selectedIndex,
          onItemTapped: _onNavTapped,
        ),
        body: screenList[_selectedIndex],
      ),
    );
  }
}
