# Changelog

All notable changes to LedgerX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added
- Initial release of LedgerX
- Customer management with CRUD operations
- Credit/Debit entry tracking
- Running balance calculation per customer
- Drift-backed SQLite database
- Audit logging system with visualization
- CSV import/export for customers
- PDF invoice and report generation
- Dark/light theme support
- Keyboard shortcuts for desktop
- Local notifications support
- Backup and restore functionality
- Quick search across customers and entries
- Tag system for entry categorization
- Multi-platform support (Windows, Linux, macOS, Android, iOS, Web)
- Clean architecture with GetX state management
- Offline-first design
- Comprehensive user guide
- Unit tests for core entities

### Features

#### Customer Management
- Add, edit, and delete customers
- Store customer information (name, email, phone, address)
- Search customers by name, email, or phone
- Import customers from CSV
- Export customers to CSV

#### Entry Management
- Create credit and debit entries
- Link entries to customers
- Add descriptions and tags to entries
- View entries filtered by customer
- Search entries by description or tags
- Real-time balance calculation
- Date selection for entries

#### Reporting & Export
- Generate PDF invoices per customer
- Generate comprehensive ledger reports
- Export customer data to CSV
- Print reports directly

#### Security
- Drift-backed SQLite storage with hashed credentials
- Audit logging for all operations
- Secure local storage

#### User Experience
- Material Design 3 UI
- Dark and light theme support
- Responsive design for all screen sizes
- Keyboard shortcuts for desktop
- Quick search functionality
- Intuitive navigation

#### Developer Features
- Clean architecture (data, domain, presentation layers)
- Repository pattern
- GetX for state management, routing, and DI
- Comprehensive test coverage
- Code documentation
- Contributing guidelines

### Technical Details

#### Dependencies
- Flutter 3.0+
- GetX 4.6+ for state management
- drift 2.29+ for database access
- sqlite3_flutter_libs 0.5+ for bundled SQLite runtime
- crypto 3.0+ for hashing
- pdf 3.10+ for PDF generation
- csv 5.1+ for CSV processing
- flutter_local_notifications 16.3+ for notifications
- fl_chart 0.65+ for visualization

#### Architecture
- Clean Architecture with three layers
- Repository pattern for data access
- GetX for dependency injection
- Reactive programming with Rx

#### Database Schema
Tables:
- `customers` - Customer information
- `entries` - Transaction entries
- `tags` - Tag definitions
- `reminders` - Reminder notifications
- `audit_logs` - Activity audit trail

### Platform Support
- ✅ Windows 10/11
- ✅ Linux (Ubuntu, Fedora, Debian)
- ✅ macOS 10.14+
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 12.0+
- ✅ Web (Progressive Web App)

### Known Issues
- PDF export requires native platform support
- Some keyboard shortcuts may conflict with system shortcuts
- Web version has limited file system access

### Documentation
- README.md with project overview
- USER_GUIDE.md with comprehensive usage instructions
- CONTRIBUTING.md with contribution guidelines
- Inline code documentation
- API documentation in code comments

## [Unreleased]

### Planned Features
- Multi-language support (Spanish, French, German)
- Cloud sync (optional, with end-to-end encryption)
- Advanced reporting with custom date ranges
- Recurring entries
- Multiple currencies support
- Email invoice functionality
- Custom themes builder
- Excel export
- Android/iOS widgets
- Watch app integration
- Voice commands
- Barcode scanning
- Receipt photo attachment
- Advanced analytics dashboard
- Multi-user support with permissions
- Integration with accounting software

### Future Improvements
- Enhanced search with filters
- Batch operations
- Data import from other apps
- Custom fields for customers
- Advanced tagging system
- Bulk edit functionality
- Template system for common entries
- Automatic backup scheduling
- Cloud storage integration
- Two-factor authentication
- Face/fingerprint authentication

## Version History

### Version Numbering
- **Major** (1.x.x): Breaking changes, major features
- **Minor** (x.1.x): New features, backward compatible
- **Patch** (x.x.1): Bug fixes, minor improvements

### Support Policy
- Current version: Full support
- Previous minor version: Security updates only
- Older versions: No longer supported

## Migration Guide

### From Future Versions
Migration guides will be provided with major version updates.

## Release Notes

### How to Update
1. Download the latest version from releases
2. Backup your data before updating
3. Install the new version
4. Restore from backup if needed

### Breaking Changes
None in version 1.0.0 (initial release)

---

For more information, visit [GitHub Releases](https://github.com/md-riaz/LedgerX/releases)
