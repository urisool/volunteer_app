import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:volunteer_app/providers/auth_provider.dart';
import 'package:volunteer_app/models/organization_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
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
    
    // محاكاة عملية التهيئة
    await Future.delayed(const Duration(seconds: 2));

    if (authProvider.currentUser != null) {
      // إذا كان المستخدم مسجل الدخول بالفعل
      final isOrganization = authProvider.currentUser is Organization;
      Navigator.pushReplacementNamed(
        context,
        isOrganization ? '/organization/home' : '/volunteer/home',
      );
    } else {
      // إذا لم يكن المستخدم مسجل الدخول
      Navigator.pushReplacementNamed(context, '/role-selection');
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
    );
  }
}