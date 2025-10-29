# Contributing to LedgerX

Thank you for your interest in contributing to LedgerX! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Your environment (OS, Flutter version, etc.)

### Suggesting Features

We welcome feature suggestions! Please create an issue with:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach
- Any relevant examples or mockups

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/md-riaz/LedgerX.git
   cd LedgerX
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding standards
   - Add tests for new features
   - Update documentation as needed

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add feature: your feature description"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Provide a clear description
   - Reference any related issues
   - Ensure all tests pass

## Development Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation
```bash
# Clone the repository
git clone https://github.com/md-riaz/LedgerX.git
cd LedgerX

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/entity_test.dart
```

### Code Analysis
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## Coding Standards

### Dart/Flutter Style
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Architecture
- Follow clean architecture principles
- Separate concerns (data, domain, presentation)
- Use GetX for state management
- Implement repository pattern for data access

### File Structure
```
lib/
├── data/           # Data layer
│   ├── datasources/    # Database, API, etc.
│   ├── models/         # Data models
│   ├── repositories/   # Repository implementations
│   └── services/       # Services (PDF, Notifications)
├── domain/         # Domain layer
│   ├── entities/       # Business objects
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/   # Presentation layer
    ├── controllers/    # GetX controllers
    ├── pages/          # UI screens
    ├── widgets/        # Reusable widgets
    └── themes/         # App themes
```

### Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Aim for >80% code coverage
- Use meaningful test descriptions

### Git Commit Messages
Follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add CSV export for entries
fix: correct balance calculation bug
docs: update installation instructions
```

## Areas for Contribution

### High Priority
- [ ] Additional unit tests
- [ ] Integration tests
- [ ] UI improvements
- [ ] Performance optimizations
- [ ] Accessibility features

### Features
- [ ] Multi-language support
- [ ] Cloud sync (optional)
- [ ] Advanced reporting
- [ ] Custom themes
- [ ] Export to Excel
- [ ] Recurring entries

### Documentation
- [ ] API documentation
- [ ] Tutorial videos
- [ ] Code examples
- [ ] Architecture diagrams

### Bug Fixes
Check the [Issues](https://github.com/md-riaz/LedgerX/issues) page for open bugs.

## Review Process

1. **Automated Checks**
   - All tests must pass
   - Code must pass linting
   - No merge conflicts

2. **Code Review**
   - At least one maintainer approval required
   - Address all review comments
   - Squash commits if requested

3. **Merge**
   - Maintainers will merge approved PRs
   - Thank you message and contributor credit

## Development Workflow

### Branch Naming
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Test additions/updates

### Testing Checklist
Before submitting a PR, ensure:
- [ ] All tests pass
- [ ] Code is formatted
- [ ] No analyzer warnings
- [ ] Documentation updated
- [ ] Changelog updated (if applicable)

### Performance Considerations
- Minimize database queries
- Use lazy loading where appropriate
- Optimize widget rebuilds
- Profile before and after changes

## Getting Help

### Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart)

### Community
- GitHub Issues for bugs and features
- Discussions for questions
- Email: dev@ledgerx.app

## License

By contributing to LedgerX, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in the app's About section

Thank you for contributing to LedgerX! 🎉
