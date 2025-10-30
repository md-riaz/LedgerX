# LedgerX Quick Start Guide

Get up and running with LedgerX in minutes!

## Prerequisites

Before you begin, ensure you have:
- Flutter SDK 3.0 or higher installed
- Dart SDK 3.0 or higher installed
- Your preferred IDE (VS Code, Android Studio, or IntelliJ)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/md-riaz/LedgerX.git
cd LedgerX
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all required packages including:
- GetX for state management
- Drift ORM + sqlite3_flutter_libs for the local database
- PDF generation tools
- CSV utilities and file pickers
- And more...

### 3. Run the Application

#### For Desktop (Windows/Linux/macOS)

**Windows:**
```bash
flutter run -d windows
```

**Linux:**
```bash
flutter run -d linux
```

**macOS:**
```bash
flutter run -d macos
```

#### For Mobile

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

#### For Web

```bash
flutter run -d chrome
```

## First-Time Setup

### When You First Open LedgerX

1. **Dashboard**: You'll see the main dashboard with four cards showing:
   - Total Customers (initially 0)
   - Total Entries (initially 0)
   - Total Credits (initially 0)
   - Total Debits (initially 0)

2. **Add Your First Customer**:
   - Click on "Customers" card or navigate using the menu
   - Click the "+" floating action button
   - Fill in customer details:
     - Name (required)
     - Email (optional)
     - Phone (optional)
     - Address (optional)
   - Click "Add"

3. **Create Your First Entry**:
   - Click on "Entries" card or navigate using the menu
   - Click the "+" floating action button
   - Select the customer you just created
   - Choose entry type (Credit or Debit)
   - Enter the amount
   - Add a description (optional)
   - Add tags (optional, comma-separated)
   - Select a date
   - Click "Add"

4. **View Balance**:
   - Go back to Entries page
   - If viewing a specific customer's entries, you'll see the running balance at the top

## Quick Features Overview

### Search
- Use the search bar at the top of Customers or Entries pages
- Search customers by name, email, or phone
- Search entries by description or tags

### Import Customers from CSV
1. Go to Customers page
2. Click the upload icon in the app bar
3. Select a CSV file formatted as:
   ```
   Name,Email,Phone,Address
   John Doe,john@example.com,1234567890,123 Main St
   ```
4. Customers will be imported automatically

### Export to PDF
1. Go to Entries page
2. Click the PDF icon
3. Select customer (if generating invoice)
4. PDF will be generated and ready to print/save

### Change Theme
1. Go to Settings (gear icon)
2. Toggle "Dark Mode" switch
3. Theme changes immediately

### Keyboard Shortcuts (Desktop)
Press **F1** to see all available shortcuts:
- `Ctrl + H`: Home
- `Ctrl + Shift + C`: Customers
- `Ctrl + Shift + E`: Entries
- `Ctrl + Shift + S`: Settings
- `Ctrl + N`: New Item
- `Ctrl + F`: Search
- `Ctrl + T`: Toggle Theme

### View Audit Logs
1. Go to Settings
2. Click "Audit Logs"
3. View activity timeline and statistics

### Backup Your Data
1. Go to Settings
2. Click "Backup Data"
3. Choose location to save backup
4. Keep this file safe!

### Restore from Backup
1. Go to Settings
2. Click "Restore Data"
3. Select your backup file
4. Confirm restoration

## Building for Production

### Windows
```bash
# Using build script
scripts\build_windows.bat

# Or manually
flutter build windows --release
```
Executable will be at: `build\windows\runner\Release\ledgerx.exe`

### Linux
```bash
# Using build script
chmod +x scripts/build_linux.sh
./scripts/build_linux.sh

# Or manually
flutter build linux --release
```
Executable will be at: `build/linux/x64/release/bundle/ledgerx`

### Android
```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```
Output will be in: `build/web/`

## Common Issues & Solutions

### Issue: "Flutter not found"
**Solution**: Ensure Flutter is in your PATH. Run:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### Issue: "Gradle build failed" (Android)
**Solution**: Ensure you have Android SDK installed and configured.

### Issue: "CocoaPods not found" (iOS)
**Solution**: Install CocoaPods:
```bash
sudo gem install cocoapods
```

### Issue: Database error on first run
**Solution**: This is normal. The app will create the database automatically on first run.

## Next Steps

1. **Read the User Guide**: See [USER_GUIDE.md](USER_GUIDE.md) for detailed feature documentation
2. **Explore Features**: Try all the features like CSV import, PDF export, etc.
3. **Customize**: Adjust theme, explore settings
4. **Backup Regularly**: Set up a backup routine
5. **Report Issues**: Found a bug? Open an issue on GitHub

## Getting Help

- **Documentation**: Check [README.md](README.md) and [USER_GUIDE.md](USER_GUIDE.md)
- **Issues**: Open an issue on [GitHub](https://github.com/md-riaz/LedgerX/issues)
- **Email**: support@ledgerx.app

## Tips for Success

1. **Regular Backups**: Back up your data weekly
2. **Tag Everything**: Use tags to organize entries
3. **Add Descriptions**: Detailed descriptions help future reference
4. **Use Search**: Instead of scrolling, use search to find items quickly
5. **Keyboard Shortcuts**: Learn shortcuts for faster navigation (desktop)

## Welcome to LedgerX! 🎉

You're now ready to start tracking your ledger entries. Happy accounting!

---

**Version**: 1.0.0  
**Last Updated**: 2024
