@echo off
echo Building LedgerX for Windows...
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo Flutter is not installed or not in PATH.
    echo Please install Flutter from https://flutter.dev
    exit /b 1
)

REM Get dependencies
echo Installing dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo Failed to get dependencies
    exit /b 1
)

REM Build for Windows
echo Building Windows application...
call flutter build windows --release
if %errorlevel% neq 0 (
    echo Build failed
    exit /b 1
)

echo.
echo Build completed successfully!
echo Executable location: build\windows\runner\Release\ledgerx.exe
echo.
pause
