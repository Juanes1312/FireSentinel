import 'package:firebase_auth/firebase_auth.dart';

/// Error de autenticación con un mensaje listo para mostrar al usuario.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Envoltorio de Firebase Auth. Las pantallas solo manejan [AuthException].
abstract final class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  static User? get currentUser => _auth.currentUser;

  /// Inicia sesión. Si el correo no está verificado cierra la sesión de
  /// inmediato para que no quede un usuario sin verificar con acceso.
  static Future<void> signIn({required String email, required String password}) async {
    final credential = await _guard(() => _auth.signInWithEmailAndPassword(email: email, password: password));
    if (credential.user?.emailVerified != true) {
      await _auth.signOut();
      throw const AuthException('Debe verificar su correo antes de ingresar por primera vez.');
    }
  }

  /// Crea la cuenta, guarda el nombre, envía el correo de verificación y
  /// cierra la sesión (el usuario debe verificar antes de entrar).
  static Future<void> register({required String name, required String email, required String password}) async {
    final credential = await _guard(() => _auth.createUserWithEmailAndPassword(email: email, password: password));
    final user = credential.user!;
    await user.updateDisplayName(name);
    await user.sendEmailVerification();
    await _auth.signOut();
  }

  static Future<void> sendPasswordReset(String email) => _guard(() => _auth.sendPasswordResetEmail(email: email));

  static Future<void> signOut() => _auth.signOut();

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  static String _messageFor(String code) => switch (code) {
    'invalid-email' => 'El formato del correo no es válido.',
    'user-not-found' => 'Usuario no encontrado.',
    'wrong-password' || 'invalid-credential' => 'Credenciales incorrectas.',
    'email-already-in-use' => 'El correo electrónico ya está en uso.',
    'weak-password' => 'La contraseña es muy débil (debe tener al menos 6 caracteres).',
    'too-many-requests' => 'Demasiados intentos. Inténtalo más tarde.',
    'network-request-failed' => 'Sin conexión a internet.',
    _ => 'Error de autenticación ($code).',
  };
}
