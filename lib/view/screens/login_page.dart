import 'package:firesentinel/config/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firesentinel/view/screens/screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Stack para poner las 3 capas: Degradado, Marca de agua y Contenido
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
                stops: [0.0, 0.6], // Controla dónde termina la mezcla de colores
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

          // 3. EL CONTENIDO PRINCIPAL DE LA APP
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- LOGO ---
                    Hero(
                      tag: 'logo',
                      child: Transform.scale(
                        scale: 2.2, // Ajuste para los márgenes del logo
                        child: Image.asset('assets/logo.png', height: 140, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 40),

                    // --- MANEJO DE ERRORES ---
                    Offstage(
                      offstage: error == '',
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    // --- FORMULARIO ---
                    form(),
                    const SizedBox(height: 30),

                    // --- BOTÓN LOGIN ---
                    buttonLogin(),
                    const SizedBox(height: 15),

                    // --- ENLACES INFERIORES ---
                    linksInferiores(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textEmail() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        labelStyle: const TextStyle(color: kWhiteColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05), // Casi transparente
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white70, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kWhiteColor, width: 2.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 2.0)),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return 'Por favor ingrese su correo';
        return null;
      },
      onSaved: (String? value) => email = value!,
    );
  }

  Widget textPassword() {
    return TextFormField(
      style: const TextStyle(color: kWhiteColor),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: const TextStyle(color: kWhiteColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white70, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kWhiteColor, width: 2.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.amber, width: 2.0)),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) return 'Por favor ingrese su contraseña';
        return null;
      },
      onSaved: (String? value) => password = value!,
    );
  }

  Widget form() {
    return Form(key: _formKey, child: Column(children: [textEmail(), const SizedBox(height: 20), textPassword()]));
  }

  Widget buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD30000), // Rojo fuerte
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          UserCredential? credenciales = await login(email, password);
          if (credenciales != null) {
            if (credenciales.user != null) {
              if (credenciales.user!.emailVerified) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CompositeDesign()), (route) => false);
              } else {
                setState(() {
                  error = 'Debe verificar su correo antes de ingresar por primera vez.';
                });
              }
            }
          }
        }
      },
      child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: kWhiteColor, fontWeight: FontWeight.bold)),
    );
  }

  Future<UserCredential?> login(String email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        setState(() => error = 'Usuario no encontrado');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        setState(() => error = 'Credenciales incorrectas');
      } else {
        setState(() => error = 'Error de autenticación: ${e.code}');
      }
    }
    return null;
  }

  Widget linksInferiores() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // Lógica para recuperar contraseña
          },
          child: const Text('Olvidé mi contraseña', style: TextStyle(color: kWhiteColor, fontSize: 16)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUserPage()));
          },
          child: const Text('Registrarse', style: TextStyle(color: kWhiteColor, fontSize: 16)),
        ),
      ],
    );
  }
}
