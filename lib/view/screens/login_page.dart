import 'package:flutter/material.dart';

import '../../config/routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await AuthService.signIn(email: _emailController.text.trim(), password: _passwordController.text);
      // Si todo va bien, AuthGate reemplaza esta pantalla por el dashboard.
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Escribe tu correo para recuperar la contraseña.');
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await AuthService.sendPasswordReset(email);
      if (mounted) setState(() => _error = null);
      messenger.showSnackBar(SnackBar(content: Text('Te enviamos un correo a $email para restablecer la contraseña.')));
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    // La escala compensa el margen transparente del PNG.
                    child: Transform.scale(scale: 2.2, child: Image.asset('assets/logo.png', height: 140)),
                  ),
                  const SizedBox(height: 55),
                  FormErrorText(_error),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          validator: (value) => (value ?? '').trim().isEmpty ? 'Por favor ingrese su correo' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _login(),
                          validator: (value) => (value ?? '').isEmpty ? 'Por favor ingrese su contraseña' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoadingButton(label: 'Iniciar Sesión', isLoading: _isLoading, onPressed: _login),
                  const SizedBox(height: 15),
                  TextButton(onPressed: _resetPassword, child: const Text('Olvidé mi contraseña')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                    child: const Text('Registrarse'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
