# LedgerX 📒

A comprehensive Flutter desktop-mobile, offline-first ledger application with enterprise-grade features.

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🌟 Features

### Core Functionality
- **Customer Management**: Complete CRUD operations for customer records
- **Credit/Debit Entries**: Track all financial transactions with running balance
- **Tags System**: Organize entries with custom tags for better categorization
- **Quick Search**: Fast full-text search across customers, entries, and tags
- **Running Balance**: Real-time balance calculation per customer

### Data Management
- **CSV Import**: Bulk import customers from CSV files
- **PDF Export**: Generate professional PDF invoices and reports
- **Backup/Restore**: Secure database backup and restore functionality
- **Offline-First**: Works completely offline with local SQLite storage

### Security & Privacy
- **Credential Hashing**: Store user passwords with SHA-256 hashes
- **Audit Logging**: Complete activity tracking with visualization
- **Data Integrity**: Repository pattern with clean architecture

### User Experience
- **Dark/Light Themes**: Beautiful Material Design 3 themes
- **Keyboard Shortcuts**: Desktop shortcuts for power users
- **Local Notifications**: Reminders for important tasks
- **Responsive Design**: Optimized for mobile, tablet, and desktop

### Architecture
- **GetX**: State management, routing, and dependency injection
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Repository Pattern**: Abstracted data access layer
- **SQLite with FFI**: Cross-platform database support
- **Unit Tests**: Comprehensive test coverage

## 🏗️ Architecture

```
lib/
├── data/
│   ├── datasources/       # Database helper and data sources
│   ├── models/           # Data transfer objects
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business objects
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic
├── presentation/
│   ├── controllers/      # GetX controllers
│   ├── pages/           # UI screens
│   ├── widgets/         # Reusable widgets
│   └── themes/          # App themes
└── l10n/                # Internationalization
```

## 📦 Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: GetX 4.6+
- **Database**: Drift ORM + sqlite3_flutter_libs
- **Security**: SHA-256 hashing via crypto
- **PDF Generation**: pdf & printing packages
- **CSV Processing**: csv package
- **Notifications**: flutter_local_notifications
- **File Operations**: file_picker & path_provider

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Windows/Linux/macOS for desktop builds
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/md-riaz/LedgerX.git
cd LedgerX
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For desktop (Windows/Linux/macOS)
flutter run -d windows
flutter run -d linux
flutter run -d macos

# For mobile
flutter run -d android
flutter run -d ios
```

### Building

#### Windows
```bash
# Using the build script
scripts\build_windows.bat

# Or manually
flutter build windows --release
```

#### Linux
```bash
# Using the build script
chmod +x scripts/build_linux.sh
./scripts/build_linux.sh

# Or manually
flutter build linux --release
```

#### Android/iOS
```bash
flutter build apk --release
flutter build ios --release
```

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 📱 Screenshots

### Dashboard
The main dashboard provides a quick overview of your ledger with:
- Total customers count
- Total entries count
- Credits and debits summary
- Quick action buttons

### Customer Management
- Add, edit, delete customers
- Search and filter
- Import from CSV
- Export to CSV

### Entry Management
- Create credit/debit entries
- Tag entries for organization
- View running balance
- Filter by customer
- Export to PDF

### Settings
- Theme toggle (dark/light)
- Backup/restore database
- Audit log viewer
- About & license info

## 🔐 Security

- **Credential Hashing**: SHA-256 hashing for user passwords
- **Audit Trail**: All CRUD operations are logged
- **Data Validation**: Input validation at all layers
- **Future Hardening**: Add at-rest encryption or secure storage as required for deployments

## 🎨 Customization

### Themes
Modify themes in `lib/presentation/themes/app_theme.dart`:
- Light theme colors
- Dark theme colors
- Custom color schemes

### Database Schema
Database schema can be modified in `lib/data/datasources/ledger_database.dart`

## 📊 Audit Logging

All operations are automatically logged:
- CREATE: New records
- UPDATE: Modified records
- DELETE: Removed records
- Timestamp tracking
- Entity type and ID tracking

View audit logs in Settings > Audit Logs

## 🌐 Internationalization

The app supports internationalization (i18n):
- English (default)
- Add more languages in `lib/l10n/`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX community for the powerful state management
- All contributors and users

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact: support@ledgerx.app

## 🗺️ Roadmap

- [ ] Multi-user support
- [ ] Cloud sync (optional)
- [ ] Advanced reporting
- [ ] Mobile app optimization
- [ ] Web version
- [ ] More export formats
- [ ] Custom report builder
- [ ] Integration with accounting software

---

Made with ❤️ using Flutter
