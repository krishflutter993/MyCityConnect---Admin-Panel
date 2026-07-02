# MyCityConnect Admin Panel

Initial Stable Release of the MyCityConnect Admin Panel. This application provides a powerful, visually appealing, and responsive interface for administrators to oversee the MyCity platform.

## Features

- **Admin Dashboard**: Overview of key metrics using beautiful charts.
- **Service Management**: Add, update, and remove city services.
- **Booking Management**: View and manage user bookings across all services.
- **Modern UI**: Designed for a premium and seamless experience.
- **Real-time Data**: Integrated with Firebase for live updates.

## Technology Stack

- **Flutter**: Core UI framework for cross-platform support.
- **Firebase**: Backend database (Cloud Firestore) and services.
- (No PHP API or SQLite in this version, purely Firebase).

## Folder Structure

```
lib/
├── models/       # Data models representing domain entities
├── screens/      # Full-page UI views (e.g., admin_panel_screen, add_service_screen)
├── services/     # Business logic and external API/Firebase interactions
├── utils/        # Helper functions, constants, and theme data
├── widgets/      # Reusable UI components (e.g., service_card)
└── main.dart     # Application entry point
```

## Installation

### Requirements
- Flutter SDK `>=3.0.0 <4.0.0`
- Configured Firebase (`google-services.json` / `GoogleService-Info.plist`)

### How to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/krishflutter993/MyCityConnect---Admin-Panel.git
   cd addminsaid_mycity
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

## Screenshots

*(Screenshots will be added in future updates)*

## Future Improvements

- Advanced Analytics and Reporting
- Role-based Access Control
- Export Bookings to CSV/PDF

## Author

Krish Savaliya

## GitHub Repository

https://github.com/krishflutter993/MyCityConnect---Admin-Panel

## APK Download

[![Download APK](https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=android)](https://github.com/krishflutter993/MyCityConnect---Admin-Panel/releases/latest/download/app-release.apk)

https://github.com/krishflutter993/MyCityConnect---Admin-Panel/releases/latest/download/app-release.apk
