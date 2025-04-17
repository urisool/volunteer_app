import 'package:flutter/material.dart';
import 'package:volunteer_app/services/auth_service.dart';
import 'colors.dart';
import 'package:provider/provider.dart';

// Models
import 'models/volunteer_model.dart';
import 'models/organization_model.dart';

// Providers
import 'providers/auth_provider.dart';

// Screens
import 'views/auth/splash_screen.dart';
import 'views/auth/role_selection_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/home/volunteer_home_screen.dart';
import 'views/home/organization_home_screen.dart';

// Use aliases to avoid name conflicts
import 'views/profiles/volunteer_profile.dart' as volunteer_profile;
import 'views/profiles/organization_profile.dart' as organization_profile;
import 'views/profiles/edit_profile.dart';
// Correct ApiService import
import 'package:volunteer_app/services/api_service.dart' as api_service;
// Assuming achievement_provider.dart has its own ApiService

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthService(api_service.ApiService()), // Use the ApiService with the alias
            api_service.ApiService(), // Assuming AuthProvider needs both instances of ApiService
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.paleGreen,
        primaryColor: AppColors.forestGreen,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.deepGreen,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkForest),
          bodyMedium: TextStyle(color: AppColors.oliveGreen),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
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
            return volunteer_profile.VolunteerProfilePage(volunteer: user);
          }
          return const Scaffold(
            body: Center(child: Text('Error: User type mismatch')),
          );
        },
        '/organization/profile': (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.currentUser;
          if (user is Organization) {
            return organization_profile.OrganizationProfilePage(organization: user);
          }
          return const Scaffold(
            body: Center(child: Text('Error: User type mismatch')),
          );
        },
        '/edit-profile': (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.currentUser;
          if (user != null) {
            return EditProfilePage(
              user: user,
              isOrganization: user is Organization,
              onSave: (updatedUser) async {
                await authProvider.updateProfile(updatedUser);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context); // الرجوع للخلف بعد الحفظ
              },
            );
          }
          return const Scaffold(
            body: Center(child: Text('Error: No user found')),
          );
        },
      },
    );
  }
}
