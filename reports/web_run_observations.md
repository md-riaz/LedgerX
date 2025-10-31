# Flutter Web Run Observations

## Environment setup
- Installed Flutter 3.35.7 (stable channel) under `/opt/flutter`.
- Ran `flutter doctor -v` to validate the toolchain.

## Doctor findings
- Android toolchain and Android Studio are not installed.
- Chrome is not available for web debugging, so the Dart Debug Chrome extension or an alternative browser is required.
- `eglinfo` is unavailable, so GPU driver information could not be queried.

## Build preparation
- `flutter pub run build_runner build --delete-conflicting-outputs` was required to generate the missing `ledger_database.g.dart` source before the app could compile.

## Web server execution
- `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000` serves `lib/main.dart` at `http://0.0.0.0:5000`.
- The web server reports deprecation warnings for `serviceWorkerVersion` and `FlutterLoader.loadEntrypoint` in `web/index.html`.

## Captured preview
- Preview screenshot: `artifacts/ledgerx_web.png`.
