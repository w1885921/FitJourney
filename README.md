# fitness_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Overview

This is a Flutter project designed for building cross-platform mobile applications using Dart.

*Prerequisites

    NOTE: Before you begin, ensure you have the following installed:

    Flutter SDK (Download here)

    Dart SDK (comes with Flutter)

    Android Studio (for Android development)

    Xcode (for iOS development on macOS)

    A device/emulator for testing


Installation

1.Clone the repository:

    git clone https://github.com/w1885921/FitJourney
    cd FitJourney

2.Install dependencies:

    flutter pub get

3.Run the app:

    flutter run

Project Structure

project-root/
├── lib/                     # Main application code
│   ├── app/                 # Application layer
│   │   ├── api/             # API calls
│   │   │   ├── api_calls.dart
│   │   ├── data/            # Data models
│   │   │   ├── api_error_model.dart
│   │   │   ├── api_success_model.dart
│   │   │   ├── news_article_model.dart
│   │   ├── generated/       # Localization files
│   │   │   ├── locales.g.dart
│   │   ├── models/          # General models
│   │   │   ├── models.dart
│   │   ├── modules/         # Application modules
│   │   │   ├── be-fit/
│   │   │   ├── goals/
│   │   │   ├── home/
│   │   │   ├── login/
│   │   │   ├── personal-details/
│   │   │       ├── bindings/
│   │   │       ├── controllers/
│   │   │       ├── views/
│   ├── routes/              # Routing configurations
│   ├── services/            # API and database services
├── assets/                  # Images, fonts, etc.
├── pubspec.yaml             # Dependencies and assets configuration
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── test/                    # Unit and widget tests
├── README.md                # Key project information

* Running on Different Platforms

    - Android: flutter run --android

    - iOS: flutter run --ios

    - Web: flutter run -d chrome

* Building the Application

    - Android: flutter build apk

    - iOS: flutter build ios

    - Web: flutter build web


* Additional Commands

    - Check for issues: flutter doctor

    - Analyze code: flutter analyze

    - Format code: flutter format .

    - Run tests: flutter test

*Contribution Guidelines

    Fork the repository

    Create a feature branch (git checkout -b feature-branch)

    Commit changes (git commit -m 'Add new feature')

    Push to the branch (git push origin feature-branch)

    Open a Pull Request

On Windows:

1. Get IP address: ipconfig on windows 

On Apple

1. Get IP address: ipconfig getifaddr en0

2.Copy IP and replace it in const baseUrl  (Exist in /lib/app/api/api_calls.dart) 