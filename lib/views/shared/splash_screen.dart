import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/providers/auth_provider.dart';
import 'package:volunteer_app/models/organization_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimationAndInitialize();
  }

  Future<void> _startAnimationAndInitialize() async {
    // بدء الأنيميشن
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
    });

    // انتظار لإكمال الأنيميشن
    await Future.delayed(const Duration(seconds: 2));

    // تحقق من المصادقة
    try {
      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();

      if (!mounted) return;

      if (authProvider.currentUser != null) {
        final isOrganization = authProvider.currentUser is Organization;
        Navigator.pushReplacementNamed(
          context,
          isOrganization ? '/organization/home' : '/volunteer/home',
        );
      } else {
        Navigator.pushReplacementNamed(context, '/role-selection');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/role-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 150),
              const SizedBox(height: 20),
              Text(
                'Volunteer App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
