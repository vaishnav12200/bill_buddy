# 🔥 Firebase Setup Instructions

## ⚠️ IMPORTANT SECURITY NOTICE
The Firebase API keys have been removed from the public repository for security reasons.

## 🛠️ Setup Steps

### 1. Get Your Firebase Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `billbuddy-90b14`
3. Go to **Project Settings** → **General**
4. Scroll down to **Your apps** section
5. Click on the **Web app** (</>) icon
6. Copy the `firebaseConfig` object

### 2. Configure Firebase Options
1. Open `lib/firebase_options.dart`
2. Replace the placeholder values with your actual Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: "your-actual-api-key",
  authDomain: "billbuddy-90b14.firebaseapp.com",
  projectId: "billbuddy-90b14", 
  storageBucket: "billbuddy-90b14.firebasestorage.app",
  messagingSenderId: "your-sender-id",
  appId: "your-app-id",
);
```

### 3. Security Notes
- ✅ `firebase_options.dart` is in `.gitignore` - it won't be committed
- ✅ Never commit API keys to version control
- ✅ Each developer needs their own Firebase configuration
- ✅ Use environment variables for production deployments

### 4. Run the App
```bash
flutter pub get
flutter run -d chrome
```

## 🔒 Security Best Practices
1. **Never commit** `firebase_options.dart`
2. **Regenerate API keys** if accidentally exposed
3. **Use Firebase security rules** to protect your database
4. **Enable Firebase App Check** for additional security

## 📞 Need Help?
- Check Firebase Console for your project configuration
- Ensure Firestore Database is created and configured
- Verify web app is properly registered in Firebase