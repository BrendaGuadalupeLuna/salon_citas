// PLANTILLA. El archivo real (lib/firebase_options.dart) lo genera el comando
// `flutterfire configure` y NO se sube a GitHub (ver .gitignore).
// Copia este archivo como firebase_options.dart solo si quieres ver la estructura.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'TU_API_KEY',
    appId: 'TU_APP_ID',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );
}
