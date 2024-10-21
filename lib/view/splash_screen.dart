import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    // Lock the orientation to portrait mode for this screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Initialize AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create a fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation
    _animationController.forward();

    // Navigate to the next screen after a delay
    Future.delayed(Duration(seconds: 5), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    if (authController.isLoggedIn.value) {
      Get.offAllNamed('/home'); // Navigate to HomeScreen after successful verification
    } else {
      Get.offAllNamed('/login'); // Navigate to LoginScreen after unsuccessful verification
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Restore orientation when leaving this screen
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset('assets/images/saffron_logo.png'),
        ),
      ),
    );
  }
}
