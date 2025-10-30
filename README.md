# Bill Buddy 💰

A modern Flutter web app for splitting expenses among friends and groups in real-time.

## 🌟 Features

### 💫 Core Functionality
- **Real-time Expense Splitting**: Split bills instantly with friends
- **Group Management**: Create or join groups with simple 6-digit codes
- **Live Sync**: Real-time updates across all devices
- **Smart Calculations**: Automatic balance calculations and settlement suggestions
- **No Login Required**: Privacy-first approach with no account setup needed

### 🌍 Multi-Language Support
- **11 Indian Languages**: English, Hindi, Telugu, Tamil, Kannada, Malayalam, Gujarati, Marathi, Bengali, Odia, Punjabi
- **Complete Translation**: Entire app interface available in selected language
- **Real-time Switching**: Change language instantly without app restart
- **Native Language Names**: Languages displayed in their native scripts

### ⚙️ Smart Settings
- **Language Selection**: Easy language switching from settings
- **Spending Tracker**: Track total amount spent across all groups
- **Accessible Design**: Settings available from all major screens

### 📊 Detailed Calculations
- **Transparent Breakdowns**: See exactly how calculations are made
- **Settlement Instructions**: Clear guidance on who owes whom
- **Balance Explanations**: Understand why each person owes or is owed money
- **Expense History**: Complete record of all group expenses

## 🚀 Technology Stack

- **Frontend**: Flutter 3.35.2 (Web)
- **Backend**: Firebase Firestore
- **State Management**: Custom Settings Service with ListenableBuilder
- **Design**: Material Design 3
- **Platform**: Progressive Web App (PWA)

## 📱 How to Use

1. **Start**: Enter your name and optionally a group code
2. **Create/Join**: Create a new group or join existing one with code
3. **Add Expenses**: Click + to add expenses with amount and description
4. **Track Balances**: View who owes whom in the balance summary
5. **View Details**: Tap balance cards for detailed calculation explanations
6. **Change Language**: Use settings icon to switch to your preferred language
7. **Track Spending**: Monitor your total expenses in settings

## 🛠️ Setup & Development

### Prerequisites
- Flutter SDK 3.35.2+
- Chrome browser for web development
- Firebase project (configured)

### Installation
```bash
# Clone the repository
git clone https://github.com/vaishnav12200/bill_buddy.git
cd bill_buddy

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
├── services/                    # Business logic & Firebase
├── screens/                     # UI screens
└── widgets/                     # Reusable components
```

## 👨‍💻 Developer

Created with ❤️ by [Vaishnav](https://github.com/vaishnav12200)

---

**Bill Buddy** - Making expense splitting simple, transparent, and accessible to everyone! 🎉
