# Flutter Web Run Observations

## Environment setup
- Installed Flutter 3.35.7 (stable channel) under `/workspace/flutter` after fetching the SDK archive.
- Installed Linux desktop build prerequisites with `apt`.
- Ran `flutter doctor -v` to validate the toolchain.

## Doctor findings
- Android toolchain and Android Studio are not installed.
- Chrome is not available for web debugging, so the Dart Debug Chrome extension or an alternative browser is required.
- `eglinfo` is unavailable, so GPU driver information could not be queried.

## Build preparation
- `flutter pub get` synchronized 138 packages (six report newer breaking versions).
- `flutter pub run build_runner build --delete-conflicting-outputs` was required to generate the missing `ledger_database.g.dart` source before the app could compile.

## Web server execution
- `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000` serves `lib/main.dart` at `http://0.0.0.0:5000`.
- The web server reports deprecation warnings for `serviceWorkerVersion` and `FlutterLoader.loadEntrypoint` in `web/index.html`.
- The initial white-screen behaviour was traced to Drift failing to load the `sql.js`/sqlite3 WebAssembly bundle. Bundling `web/sqlite3.wasm`, compiling `web/drift_worker.dart` to JavaScript, and switching the web connection factory to `WasmDatabase.open` resolved the crash.
- Runtime console warnings now only mention optional assets (Roboto fonts) and Chromium's fallback WebGL warning, confirming the database bootstrap succeeds.
- The app was left running for 60 seconds before capturing the preview to satisfy the runtime soak requirement.

## Captured preview
- Preview screenshot: `artifacts/ledgerx_web_after_fix.png`.

---

## 2025-11-02 environment refresh

### Flutter installation
- Cloned the stable Flutter SDK to `/opt/flutter` and ran `flutter doctor -v`.
- Doctor flagged missing Android SDK/Studio, Chrome, and GTK/mesa-utils packages, but verified the Linux desktop device and proxy configuration.

### Dependency synchronization
- `flutter pub get` refreshed 138 packages (six still have newer breaking versions available).

### Automated testing
- `flutter test` currently executes the database helper suite, which passed end-to-end.

### Web server smoke test
- `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000` served `lib/main.dart` with the same `serviceWorkerVersion` and `FlutterLoader.loadEntrypoint` deprecation warnings noted earlier.
- Captured a live preview screenshot at `artifacts/ledgerx-web.png` once the page finished loading.
