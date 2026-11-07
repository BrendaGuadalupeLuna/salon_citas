# Salón de Belleza – Agenda de citas (Flutter + Firebase)

App móvil para agendar y consultar citas de un salón de belleza.
Stack: Flutter, Firebase Authentication (anónima) y Cloud Firestore.

## Funciones
- Pantalla principal con acceso a "Agendar cita" y "Ver citas".
- Formulario: nombre, teléfono (10 dígitos), servicio, fecha, hora y notas.
- Lista en tiempo real desde Firestore; marcar como completada o eliminar.
- Validaciones: campos obligatorios, no registros vacíos, fecha futura,
  horario 10:00–20:00 y no permite dos citas en el mismo horario.
- Seguridad: credenciales fuera del repositorio (.gitignore) y reglas de
  Firestore (`firestore.rules`) que exigen autenticación y validan los datos.

## 1. Crear el proyecto y copiar el código
```bash
flutter create --org com.tuapellido salon_citas
cd salon_citas
# copia aquí: lib/, pubspec.yaml, analysis_options.yaml, .gitignore, firestore.rules
flutter pub get
```

## 2. Configurar Firebase (TU proyecto propio)
1. Entra a https://console.firebase.google.com → **Agregar proyecto**.
2. **Build → Firestore Database → Crear base de datos** (modo producción).
3. **Build → Authentication → Comenzar → Anonymous → Habilitar**.
4. En Firestore → pestaña **Reglas**: pega el contenido de `firestore.rules` y **Publicar**.
5. En la terminal:
```bash
dart pub global activate flutterfire_cli
npm install -g firebase-tools   # si no lo tienes
firebase login
flutterfire configure           # elige tu proyecto y Android (y Web si quieres URL)
```
Esto genera `lib/firebase_options.dart` y `android/app/google-services.json`
(ambos ignorados por Git para proteger las credenciales).

## 3. Ejecutar
```bash
flutter run
```

## 4. Control de versiones
```bash
git init
git add .
git commit -m "Proyecto inicial Flutter"
git add . && git commit -m "Pantallas: inicio, formulario y lista"
git add . && git commit -m "Integración con Firebase Firestore"
git add . && git commit -m "Validaciones y reglas de seguridad"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/salon_citas.git
git push -u origin main
```
(Haz commits reales conforme avances, no todos al final.)

## 5. Compilar APK
```bash
flutter build apk --release
# Resultado: build/app/outputs/flutter-apk/app-release.apk
```
Instálalo en un celular (copiar el APK y abrirlo, o `adb install app-release.apk`).

## 6. URL de la aplicación
**Opción A – Firebase App Distribution (APK por enlace)**
1. Consola Firebase → Release & Monitor → App Distribution → Comenzar.
2. Sube `app-release.apk`, agrega tu correo como tester y distribuye.
3. Comparte el enlace de descarga.

**Opción B – Web con Firebase Hosting (URL para probarla en navegador)**
```bash
flutterfire configure           # incluye la plataforma Web
flutter build web
firebase init hosting           # public dir: build/web, SPA: yes
firebase deploy
```
La URL queda como `https://TU-PROYECTO.web.app`.

## Evidencias a entregar
- Capturas de Firestore (colección `citas`) mostrando tu proyecto y los documentos.
- APK, URL, ZIP del código, enlace de GitHub y video demostrativo.
