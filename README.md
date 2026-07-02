# MyCityConnect Admin Panel

A comprehensive Flutter-based admin dashboard for managing city services, bookings, and user interactions. This application provides a powerful, visually appealing, and responsive interface for administrators to oversee the MyCity platform.

## Features

- **Admin Dashboard**: Overview of key metrics using beautiful charts (`fl_chart`).
- **Service Management**: Add, update, and remove city services (plumbing, electrical, cleaning, etc.).
- **Booking Management**: View and manage user bookings across all services.
- **Modern UI**: Designed with `glassmorphism`, `google_fonts`, and modern Flutter widgets for a premium feel.
- **Real-time Data**: Integrated with Firebase (`firebase_core`, `cloud_firestore`) for live updates.
- **Image Handling**: Seamless image selection and caching (`image_picker`, `cached_network_image`).
- **Loading States**: Shimmer effects (`shimmer`) for smooth user experience during data fetch.

## Technologies Used

- Flutter & Dart
- Firebase (Cloud Firestore)
- fl_chart (Data Visualizations)
- google_fonts (Custom Typography)
- glassmorphism (UI Effects)
- cached_network_image & image_picker

## Installation

To run this project locally:

1. **Prerequisites**: Ensure you have Flutter installed (SDK `>=3.0.0 <4.0.0`).
2. **Clone the repository**:
   ```bash
   git clone https://github.com/krishflutter993/MyCityConnect---Admin-Panel.git
   cd addminsaid_mycity
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Firebase Setup**: 
   - Ensure you have the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) configured in your project.
5. **Run the app**:
   ```bash
   flutter run
   ```

## Screenshots

*(Add screenshots of the admin dashboard here)*

## Folder Structure

The project follows a standard Flutter architectural pattern for maintainability:

```
lib/
├── models/       # Data models representing domain entities
├── screens/      # Full-page UI views (e.g., admin_panel_screen, add_service_screen)
├── services/     # Business logic and external API/Firebase interactions
├── utils/        # Helper functions, constants, and theme data
├── widgets/      # Reusable UI components (e.g., service_card)
└── main.dart     # Application entry point
```

## APK Download

[![Download APK](https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=android)](https://github.com/krishflutter993/MyCityConnect---Admin-Panel/releases/latest/download/app-release.apk)

https://github.com/krishflutter993/MyCityConnect---Admin-Panel/releases/latest/download/app-release.apk

## GitHub Repository

https://github.com/krishflutter993/MyCityConnect---Admin-Panel
