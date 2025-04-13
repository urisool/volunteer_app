import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/providers/auth_provider.dart';
import 'package:volunteer_app/views/auth/role_selection_screen.dart';
import 'package:volunteer_app/views/home/volunteer_home_screen.dart';
import 'package:volunteer_app/views/home/organization_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUser();

    await Future.delayed(const Duration(seconds: 2));

    if (authProvider.currentUser != null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => authProvider.currentUser is Volunteer
              ? const VolunteerHomeScreen()
              : const OrganizationHomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            const Text(
              'Volunteer App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

extension on AuthProvider {
  loadUser() {}
}