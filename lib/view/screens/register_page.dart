import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const _minPasswordLength = 6;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Por favor, verifica tu correo.'), backgroundColor: Colors.green),
      );
      navigator.pop();
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _required(String? value, String message) => (value ?? '').trim().isEmpty ? message : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireBackground(
        gradientEnd: 0.5,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Hero(
                    tag: 'logo',
                    child: Transform.scale(scale: 2.2, child: Image.asset('assets/logo.png', height: 100)),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Registro de Usuario',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  FormErrorText(_error),
                  _buildForm(),
                  const SizedBox(height: 30),
                  LoadingButton(label: 'Crear Cuenta', isLoading: _isLoading, onPressed: _register),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '¿Ya tienes cuenta? '),
                          TextSpan(
                            text: 'Iniciar Sesión',
                            style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 15,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person_outline)),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, 'Por favor, ingresa tu nombre.'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) => _required(v, 'Por favor, ingresa tu correo.'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
            obscureText: true,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if ((v ?? '').isEmpty) return 'Por favor, ingresa tu contraseña.';
              if (v!.length < _minPasswordLength) return 'La contraseña debe tener al menos $_minPasswordLength caracteres.';
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmar Contraseña', prefixIcon: Icon(Icons.lock_outline)),
            obscureText: true,
            onFieldSubmitted: (_) => _register(),
            validator: (v) {
              if ((v ?? '').isEmpty) return 'Por favor, confirma tu contraseña.';
              if (v != _passwordController.text) return 'Las contraseñas no coinciden.';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
