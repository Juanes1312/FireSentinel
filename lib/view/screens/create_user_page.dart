import 'package:firesentinel/config/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late String name, email, password, confirmPassword;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool _isLoading = false;

  Future<UserCredential?> create(String email, String password) async {
    setState(() {
      _isLoading = true;
      error = '';
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      // Opcional: Aquí podrías actualizar el 'displayName' del usuario con la variable 'name'
      // await userCredential.user?.updateDisplayName(name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('🚨 ERROR REAL DE FIREBASE: ${e.code} -> ${e.message}');
      if (e.code == 'email-already-in-use') {
        error = 'El correo electrónico ya está en uso.';
      } else if (e.code == 'invalid-email') {
        error = 'El formato del correo no es válido.';
      } else if (e.code == 'weak-password') {
        error = 'La contraseña es muy débil (debe tener al menos 6 caracteres).';
      } else {
        error = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el Stack principal para las 3 capas, igual que en el Login
      body: Stack(
        children: [
          // 1. EL FONDO DEGRADADO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD84315), // Naranja/Rojo fuego en la parte superior
                  Color(0xFF0B172A), // Azul marino oscuro en la parte inferior
                ],
                stops: [0.0, 0.5],
              ),
            ),
          ),

          // 2. LA MARCA DE AGUA (Logotipo gigante y transparente)
          Positioned.fill(
            child: Opacity(
              opacity: 0.03, // Muy sutil, solo el 3% de opacidad
              child: Transform.scale(
                scale: 1.5, // Lo hacemos muy grande
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
            ),
          ),

          // 3. EL CONTENIDO PRINCIPAL
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40), // Espacio superior
                    // --- LOGO ---
                    Hero(
                      tag: 'logo',
                      child: Transform.scale(
                        scale: 2.2, // Ajuste para el margen transparente del logo
                        child: Image.asset(
                          'assets/logo.png',
                          height: 100, // Altura base reducida
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- TEXTO FIRESENTINEL ---
                    const SizedBox(height: 30),
                    const Text('Registro de Usuario', textAlign: TextAlign.center, style: TextStyle(color: kWhiteColor, fontSize: 28, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),

                    // --- MANEJO DE ERRORES ---
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.bold)),
                      ),

                    // --- FORMULARIO ---
                    form(),
                    const SizedBox(height: 30),

                    // --- BOTÓN REGISTRO ---
                    buttonCreateUser(),
                    const SizedBox(height: 20),

                    // --- ENLACE A LOGIN ---
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: kWhiteColor, fontSize: 16),
                            children: [
                              TextSpan(text: '¿Ya tienes cuenta? '),
                              TextSpan(text: 'Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ESTILOS COMPARTIDOS DE INPUT ---
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kWhiteColor),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white70, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kWhiteColor, width: 2.0)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 2.0)),
    );
  }

  Widget textName() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: _inputDecoration('Nombre Completo', Icons.person_outline),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu nombre.';
        }
        return null;
      },
      onSaved: (String? value) => name = value!,
    );
  }

  Widget textEmail() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: _inputDecoration('Correo Electrónico', Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu correo.';
        }
        return null;
      },
      onSaved: (String? value) => email = value!,
    );
  }

  Widget textPassword() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: _inputDecoration('Contraseña', Icons.lock_outline),
      obscureText: true,
      onChanged: (value) => password = value, // Capturamos para comparar con confirmación
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu contraseña.';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres.';
        }
        return null;
      },
      onSaved: (String? value) => password = value!,
    );
  }

  Widget textConfirmPassword() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: _inputDecoration('Confirmar Contraseña', Icons.lock_outline),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, confirma tu contraseña.';
        }
        if (value != password) {
          // 'password' se actualiza en el onChanged del campo anterior
          return 'Las contraseñas no coinciden.';
        }
        return null;
      },
      onSaved: (String? value) => confirmPassword = value!,
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: [textName(), const SizedBox(height: 15), textEmail(), const SizedBox(height: 15), textPassword(), const SizedBox(height: 15), textConfirmPassword()]),
    );
  }

  Widget buttonCreateUser() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD30000), // Rojo fuerte
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledBackgroundColor: const Color(0xFFD30000).withOpacity(0.5),
      ),
      onPressed:
          _isLoading
              ? null
              : () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  UserCredential? credenciales = await create(email, password);

                  if (credenciales?.user != null && mounted) {
                    await credenciales!.user!.sendEmailVerification();

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Registro exitoso! Por favor, verifica tu correo.'), backgroundColor: Colors.green));

                    Navigator.of(context).pop();
                  }
                }
              },
      child:
          _isLoading
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: kWhiteColor, strokeWidth: 3))
              : const Text('Crear Cuenta', style: TextStyle(fontSize: 18, color: kWhiteColor, fontWeight: FontWeight.bold)),
    );
  }
}
