# MyCity Admin Panel (addminsaid_mycity)

A comprehensive Flutter-based admin dashboard for managing city services, bookings, and user interactions. This application provides a powerful, visually appealing, and responsive interface for administrators to oversee the MyCity platform.

## Features

- **Admin Dashboard**: Overview of key metrics using beautiful charts (`fl_chart`).
- **Service Management**: Add, update, and remove city services (plumbing, electrical, cleaning, etc.).
- **Booking Management**: View and manage user bookings across all services.
- **Modern UI**: Designed with `glassmorphism`, `google_fonts`, and modern Flutter widgets for a premium feel.
- **Real-time Data**: Integrated with Firebase (`firebase_core`, `cloud_firestore`) for live updates.
- **Image Handling**: Seamless image selection and caching (`image_picker`, `cached_network_image`).
- **Loading States**: Shimmer effects (`shimmer`) for smooth user experience during data fetch.

## Project Structure

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

## Dependencies

Key packages used in this project:

- `flutter`: The core UI framework.
- `firebase_core` & `cloud_firestore`: Backend database and services.
- `fl_chart`: For rendering insightful data visualizations on the dashboard.
- `glassmorphism`: To create modern, frosted-glass UI elements.
- `google_fonts`: Custom typography.
- `cached_network_image`: Efficient image loading and caching.
- `shimmer`: Skeleton loading animations.
- `image_picker`: Selecting images for services or profiles.
- `intl`: Internationalization and date formatting.
- `http`: Network requests.

## Getting Started

To run this project locally:

1. **Prerequisites**: Ensure you have Flutter installed (SDK `>=3.0.0 <4.0.0`).
2. **Clone the repository**:
   ```bash
   git clone <repository-url>
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

## Design Aesthetics

This admin panel prioritizes a rich, dynamic, and premium user experience. It avoids generic designs, instead opting for harmonious color palettes, modern typography, smooth gradients, and subtle micro-animations to create an engaging interface.
