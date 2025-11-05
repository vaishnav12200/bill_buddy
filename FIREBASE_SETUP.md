# 🔥 Firebase Setup Instructions

## ⚠️ SECURITY NOTE
Firebase credentials are stored in `lib/firebase_env.dart` which is excluded from GitHub via `.gitignore`.

## 🛠️ Quick Setup

### For New Developers:
1. Get Firebase config from project owner
2. Create `lib/firebase_env.dart` with your credentials
3. Run the app: `flutter run -d chrome`

### Firebase Environment File Structure:
```dart
// lib/firebase_env.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class FirebaseEnv {
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project.firebasestorage.app", 
    messagingSenderId: "your-sender-id",
    appId: "your-app-id",
  );
}
```

## 🔒 Security Features:
- ✅ `firebase_env.dart` is in `.gitignore` 
- ✅ Credentials stay local, never committed to GitHub
- ✅ Clean and simple setup