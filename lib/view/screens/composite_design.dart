import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesentinel/config/routes/app_routes.dart';
import '../widgets/widgets.dart';

class CompositeDesign extends StatefulWidget {
  const CompositeDesign({super.key});

  @override
  State<CompositeDesign> createState() => _CompositeDesignState();
}

class _CompositeDesignState extends State<CompositeDesign> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (user == null) {
          Navigator.of(context).pushReplacementNamed(AppRoute.loginRoute);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [BackgroundComposite(), MainContent()]), bottomNavigationBar: CustomBottomNavigation());
  }
}
