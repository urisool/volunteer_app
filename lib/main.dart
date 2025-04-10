import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'models/user_model.dart';

// Providers
import 'providers/auth_provider.dart';

// Screens
import 'views/auth/splash_screen.dart';
import 'views/auth/role_selection_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/home/volunteer_home_screen.dart';
import 'views/home/organization_home_screen.dart';
import 'views/profiles/volunteer_profile.dart';
import 'views/profiles/organization_profile.dart';
import 'views/profiles/edit_profile.dart';


import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/models/organization_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/volunteer/login': (context) => const LoginScreen(isOrganization: false),
        '/organization/login': (context) => const LoginScreen(isOrganization: true),
        '/volunteer/register': (context) => const RegisterScreen(isOrganization: false),
        '/organization/register': (context) => const RegisterScreen(isOrganization: true),
        '/volunteer/home': (context) => const VolunteerHomeScreen(),
        '/organization/home': (context) => const OrganizationHomeScreen(),
        '/volunteer/profile': (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.currentUser;
          if (user is Volunteer) {
            return VolunteerProfilePage(volunteer: user);
          }
          return const Scaffold(body: Center(child: Text('Error: User type mismatch')));
        },
        '/organization/profile': (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.currentUser;
          if (user is Organization) {
            return OrganizationProfilePage(organization: user);
          }
          return const Scaffold(body: Center(child: Text('Error: User type mismatch')));
        },
        '/edit-profile': (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.currentUser;
          if (user != null) {
            return EditProfilePage(
              user: user,
              isOrganization: user is Organization,
            );
          }
          return const Scaffold(body: Center(child: Text('Error: No user found')));
        },
      },
    );
  }
}