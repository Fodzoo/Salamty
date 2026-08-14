# Salamty: AI-Powered Comprehensive Healthcare Mobile Application

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Dart](https://img.shields.io/badge/Dart-Latest-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-Academic-orange.svg)

## Table of Contents
- [Executive Summary](#executive-summary)
- [Project Overview](#project-overview)
- [Core Features](#core-features)
- [Technical Implementation](#technical-implementation)
- [System Requirements](#system-requirements)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [API Integration](#api-integration)
- [State Management](#state-management)
- [Localization & Internationalization](#localization--internationalization)
- [Known Limitations](#known-limitations)
- [Future Roadmap](#future-roadmap)
- [References & Documentation](#references--documentation)
- [Team Members](#team-members)

---

## Executive Summary

**Salamty** is a comprehensive AI-powered healthcare mobile application developed as a graduation project at Thebes Higher Institute of Management & Information Technology. The application leverages artificial intelligence, machine learning, and cloud computing to provide users with accessible, intelligent health management and consultation services.

**Key Achievements:**
- ✅ Multi-feature healthcare platform with 9+ core features
- ✅ Real-time AI-powered health consultations
- ✅ Bilingual support (English & Arabic)
- ✅ Material Design 3 implementation
- ✅ Secure backend integration with Supabase
- ✅ Cross-platform mobile solution (iOS & Android)
- ✅ Enterprise-level state management with Provider pattern
- ✅ Comprehensive user authentication system

---

## Project Overview

### Institutional Information
| Detail | Information |
|--------|-------------|
| **Institution** | Thebes Higher Institute of Management & Information Technology |
| **Location** | Giza, Egypt |
| **Project Type** | Graduation Project |
| **Academic Supervisor** | Dr. Sherif Sobhy |

### Problem Statement

Healthcare accessibility remains a critical challenge in developing regions. Users face difficulties in:
- Obtaining timely medical consultations
- Managing medications and drug interactions
- Tracking health metrics and lab results
- Accessing emergency health information
- Finding nearby healthcare facilities

**Salamty** addresses these challenges through an intelligent, user-centric mobile application.

### Solution Overview

Salamty provides an integrated platform that:
1. Delivers AI-powered medical consultations 24/7
2. Manages medications and drug interactions
3. Tracks health metrics (BMI, lab tests, radiology)
4. Offers emergency assistance
5. Locates nearby healthcare facilities
6. Maintains comprehensive health records
7. Supports bilingual interface (English/Arabic)

---

## Core Features

### 1. AI-Powered Health Consultation 💬
**Description**: Real-time intelligent health consultation powered by AI
- **Functionality**:
  - Natural language processing for user queries
  - AI-generated medical guidance
  - Chat history maintenance
  - Multi-turn conversation support
  - Context-aware responses
- **Technical Stack**: Supabase Integration, REST APIs
- **User Experience**: Seamless chat interface with typing indicators

### 2. Emergency AI Response System 🚨
**Description**: Rapid emergency health assessment and guidance
- **Functionality**:
  - Emergency situation recognition
  - Immediate AI response generation
  - Critical alert notifications
  - Location-based emergency services lookup
  - First aid guidance
- **Implementation**: Real-time processing, WebSocket connection
- **Safety Features**: Disclaimer overlays, emergency contact integration

### 3. BMI Calculator & Health Metrics 📊
**Description**: Personal health metrics calculation and interpretation
- **Functionality**:
  - BMI calculation (metric and imperial units)
  - Health category classification
  - Historical tracking
  - Visual result presentation
  - Personalized health recommendations
- **Algorithm**: ISO/IEC 80000-3 standard BMI formula
- **Data Persistence**: Local storage with cloud sync

### 4. Drug Interaction Checker 💊
**Description**: Comprehensive medication interaction database and warnings
- **Functionality**:
  - Drug-drug interaction lookup
  - Severity classification (Minor, Moderate, Severe)
  - Dosage information retrieval
  - Alternative drug suggestions
  - Contraindication alerts
- **Data Source**: Integration with established pharmaceutical databases
- **User Safety**: Warning color coding and detailed explanations

### 5. Laboratory Tests Management 🧪
**Description**: Complete lab test history and result management
- **Functionality**:
  - Test result storage and retrieval
  - Result interpretation guidelines
  - Historical trend analysis
  - PDF report generation
  - Test recommendation engine
  - Doctor notes attachment
- **Standards Compliance**: Medical data protection standards
- **Data Security**: Encrypted storage

### 6. Radiology Assistant 🖼️
**Description**: Medical imaging support and radiology record management
- **Functionality**:
  - Imaging report storage
  - Image annotation tools
  - Radiology history timeline
  - Doctor consultation notes
  - Image quality standards
  - DICOM support considerations
- **Future Enhancement**: AI-assisted image analysis
- **Compliance**: Medical imaging privacy standards

### 7. Medicine & Prescription Management 💉
**Description**: Comprehensive medication management system
- **Functionality**:
  - Medication inventory tracking
  - Prescription documentation
  - Refill reminders
  - Dosage scheduling
  - Side effects tracking
  - Medication adherence monitoring
- **Notifications**: Local push notifications for medication schedules
- **Integration**: Calendar sync capabilities

### 8. Find Care & Healthcare Locator 🏨
**Description**: Location-based healthcare facility discovery
- **Functionality**:
  - Hospital and clinic finder
  - GPS-based proximity search
  - Facility ratings and reviews
  - Operating hours display
  - Contact information
  - Map integration
  - Appointment booking (future)
- **APIs**: Google Places API, Geolocation Services
- **Real-time Data**: Current operating status and availability

### 9. User Profile & Account Management 👤
**Description**: Comprehensive personal health profile and account settings
- **Functionality**:
  - User registration and authentication
  - Profile customization
  - Medical history documentation
  - Health insurance information
  - Emergency contacts
  - Privacy preferences
  - Password management
  - Account security settings
- **Security**: End-to-end encryption considerations
- **GDPR Compliance**: Data privacy controls

---

## Technical Implementation

### Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Framework** | Flutter | 3.x |
| **Language** | Dart | Latest |
| **State Management** | Provider | ^6.0.0 |
| **Backend** | Supabase (PostgreSQL) | Latest |
| **Authentication** | Supabase Auth | Latest |
| **Real-time DB** | Supabase Realtime | Enabled |
| **APIs** | RESTful + WebSocket | HTTP/1.1 & WebSocket |
| **Design System** | Material 3 | Latest |
| **Localization** | Flutter i18n | ARB Format |
| **Storage** | Local + Cloud | Shared Preferences + Supabase |

### Dependencies Overview

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # State Management
  provider: ^6.0.0
  
  # Backend & APIs
  supabase_flutter: ^1.0.0
  http: ^1.0.0
  
  # UI & Design
  google_fonts: ^4.0.0
  cached_network_image: ^3.2.0
  
  # Utilities
  shared_preferences: ^2.0.0
  intl: ^0.18.0
  
  # Additional
  # [See pubspec.yaml for complete dependencies]
```

### Database Schema Overview

**Primary Entities:**
- `users`: User accounts and profiles
- `health_records`: Patient health data
- `medications`: Medicine inventory
- `lab_tests`: Laboratory test results
- `radiology_reports`: Medical imaging records
- `ai_conversations`: Chat history
- `emergency_logs`: Emergency access logs

**Security**: Row-level security (RLS) policies implemented on all tables

---

## System Requirements

### Minimum Requirements

| Requirement | Specification |
|------------|---------------|
| **Minimum Android** | Android 5.0 |
| **Minimum iOS** | iOS 12.0 or later |
| **RAM** | 2 GB minimum |
| **Storage** | 250 MB free space |

### Recommended Specifications

| Requirement | Specification |
|------------|---------------|
| **Android** | Android 11.0 |
| **iOS** | iOS 14.0+ |
| **RAM** | 4 GB or more |
| **Storage** | 300+ MB available space |

---

## Installation & Setup

### Prerequisites

```bash
# Verify Flutter installation
flutter --version

# Verify Dart installation
dart --version

# Check system setup
flutter doctor
```

**Required Tools:**
- Flutter SDK (v3.x minimum)
- Dart SDK (included with Flutter)
- Android Studio with Android SDK
- Xcode (for iOS development)
- Git version control

### Step-by-Step Installation

#### 1. Clone Repository
```bash
git clone <repository-url>
cd salamty
```

#### 2. Install Dependencies
```bash
flutter pub get
flutter pub upgrade
```

#### 3. Configure Supabase
Create `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

#### 4. Generate Code
```bash
# Generate localization files
flutter gen-l10n

# Generate build files if needed
flutter pub run build_runner build
```

#### 5. Run Application
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

#### 6. iOS Specific Setup
```bash
cd ios
pod install
pod repo update
cd ..
```

---

## Project Structure

```
salamty/
├── lib/
│   ├── main.dart                          # Application entry point
│   ├── supabase_helper.dart               # Supabase initialization
│   │
│   ├── core/                              # Core resources layer
│   │   ├── resources/
│   │   │   ├── app_colors.dart            # Color palette & gradients
│   │   │   ├── app_constants.dart         # Application constants
│   │   │   └── assets.dart                # Asset paths
│   │   │
│   │   ├── theme/
│   │   │   ├── theme.dart                 # Material 3 theme config
│   │   │   ├── light_theme.dart           # Light theme specification
│   │   │   └── dark_theme.dart            # Dark theme specification
│   │   │
│   │   ├── theme_provider/
│   │   │   └── theme_provider.dart        # Theme state management
│   │   │
│   │   └── widgets/
│   │       ├── logo_body.dart             # Reusable logo widget
│   │       └── custom_appbar.dart         # Custom app bar component
│   │
│   ├── features/                          # Feature modules
│   │   │
│   │   ├── splash/                        # Splash screen feature
│   │   │   └── presentation/
│   │   │       └── splash_screen.dart
│   │   │
│   │   ├── on_boarding/                   # Onboarding flow
│   │   │   ├── presentation/
│   │   │   │   ├── on_boarding_screen.dart
│   │   │   │   ├── data/
│   │   │   │   │   └── onboarding_data.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── page_item.dart
│   │   │   │       ├── button.dart
│   │   │   │       ├── indicator.dart
│   │   │   │       └── top_bar.dart
│   │   │
│   │   ├── login/                         # Login feature
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       └── widgets/
│   │   │           ├── login_form_body.dart
│   │   │           └── create_account_text_body.dart
│   │   │
│   │   ├── sign_up/                       # Registration feature
│   │   │   └── presentation/
│   │   │       ├── sign_up_screen.dart
│   │   │       ├── health_profile_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── forgot_password/               # Password recovery
│   │   │   └── presentation/
│   │   │       ├── forgot_password_screen.dart
│   │   │       ├── reset_password_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── home/                          # Home/Dashboard feature
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart
│   │   │       ├── home_drawer.dart
│   │   │       └── widgets/
│   │   │           ├── home_appbar.dart
│   │   │           ├── home_feature_item.dart
│   │   │           ├── daily_medical_tip.dart
│   │   │           └── home_drawer_item.dart
│   │   │
│   │   ├── ai_health_chat/                # AI Health Consultation
│   │   │   ├── model/
│   │   │   │   └── chat_message.dart
│   │   │   └── presentation/
│   │   │       ├── ai_chat_health_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── emergency_ai/                  # Emergency AI Feature
│   │   │   └── presentation/
│   │   │       ├── emergency_ai_screen.dart
│   │   │       └── widgets/
│   │   │           └── emergency_appbar.dart
│   │   │
│   │   ├── bmi_calculator/                # BMI Calculator Feature
│   │   │   └── presentation/
│   │   │       ├── bmi_calculator_screen.dart
│   │   │       ├── ResultScreen.dart
│   │   │       └── widgets/
│   │   │           └── bmi_calc_appbar.dart
│   │   │
│   │   ├── drug_interactions/             # Drug Interactions Feature
│   │   │   └── presentation/
│   │   │       ├── drug_interactions_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── lab_tests/                     # Lab Tests Feature
│   │   │   └── presentation/
│   │   │       ├── lab_tests_screen.dart
│   │   │       ├── lab_history_screen.dart
│   │   │       ├── lab_details_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── radiology_assistant/           # Radiology Feature
│   │   │   └── presentation/
│   │   │       ├── radiology_assistant_screen.dart
│   │   │       ├── radiology_history_screen.dart
│   │   │       ├── radiology_details_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── medicines/                     # Medicines Management
│   │   │   └── presentation/
│   │   │       ├── medicines_screen.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── find_care/                     # Find Care Feature
│   │   │   └── presentation/
│   │   │       ├── find_care_screen.dart
│   │   │       └── widgets/
│   │   │           └── find_care_appbar.dart
│   │   │
│   │   └── profile/                       # User Profile & Settings
│   │       └── presentation/
│   │           ├── profile_screen.dart
│   │           ├── edit_profile_screen.dart
│   │           ├── setting_screen.dart
│   │           ├── change_password_screen.dart
│   │           ├── language_screen.dart
│   │           ├── privacy_policy_screen.dart
│   │           ├── terms_of_service_screen.dart
│   │           └── widgets/
│   │               ├── profile_appbar.dart
│   │               ├── profile_header.dart
│   │               ├── profile_item.dart
│   │               └── setting_item.dart
│   │
│   └── l10n/                              # Localization files
│       ├── app_en.arb                     # English translations
│       ├── app_ar.arb                     # Arabic translations
│       └── app_localizations_*.dart       # Generated localization files
│
├── pubspec.yaml                           # Project dependencies
├── pubspec.lock                           # Dependency lock file
├── analysis_options.yaml                  # Lint rules
└── README.md                              # This file
```

---

## API Integration

### Supabase REST API

#### Authentication Endpoints
```
POST   /auth/v1/signup              # User registration
POST   /auth/v1/token               # User login
POST   /auth/v1/token/refresh        # Refresh authentication
POST   /auth/v1/logout               # User logout
```

#### Database Operations
```
GET    /rest/v1/users?select=*      # Fetch user records
POST   /rest/v1/users               # Create user record
PATCH  /rest/v1/users               # Update user record
DELETE /rest/v1/users               # Delete user record
```

#### Example: Fetch Health Records
```dart
Future<List<HealthRecord>> getHealthRecords(String userId) async {
  final response = await supabase
    .from('health_records')
    .select()
    .eq('user_id', userId);
  
  return (response as List)
    .map((record) => HealthRecord.fromJson(record))
    .toList();
}
```

### External APIs

**Google Places API**
- Used for: Healthcare facility search and mapping
- Implementation: Flutter Google Places plugin

**AI Consultation APIs**
- Used for: AI response generation
- Authentication: API key-based authentication

---

## State Management

### Provider Pattern Implementation

**App-Level Provider:**
```dart
// Theme Management
ChangeNotifierProvider(
  create: (context) => ThemeProvider(),
  child: Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return MaterialApp(
        theme: themeProvider.isDark ? darkTheme : lightTheme,
      );
    },
  ),
)
```

**Feature-Level Providers:**
```dart
// Example: Health Chat Provider
class HealthChatProvider extends ChangeNotifier {
  List<ChatMessage> messages = [];
  bool isLoading = false;
  
  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }
  
  Future<void> sendQuery(String query) async {
    isLoading = true;
    notifyListeners();
    
    try {
      final response = await aiService.getResponse(query);
      addMessage(ChatMessage(text: response, isUser: false));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## Localization & Internationalization

### Supported Languages
- 🇺🇸 **English** (en)
- 🇸🇦 **Arabic** (ar) - RTL support

### Translation Files

**app_en.arb:**
```json
{
  "appName": "Salamty",
  "welcome": "Welcome to Salamty",
  "aiConsultation": "AI Health Consultation",
  "emergency": "Emergency Assistance"
}
```

**app_ar.arb:**
```json
{
  "appName": "سلامتي",
  "welcome": "مرحبا بك في سلامتي",
  "aiConsultation": "الاستشارة الصحية الذكية",
  "emergency": "المساعدة في الطوارئ"
}
```

### Implementation Example
```dart
// Access localized strings
Text(AppLocalizations.of(context)!.appName)

// Change language
Provider.of<ThemeProvider>(context, listen: false)
  .changeLanguage(Locale('ar'));
```
---

## Known Limitations

1. **Offline Functionality**: Limited offline support; primary features require internet
2. **AI Response Time**: May vary based on API availability (typically 2-5 seconds)
3. **Localization**: Currently supports English and Arabic only
4. **Geolocation**: Find Care feature requires location permissions
5. **Storage**: Cloud storage limited by Supabase tier
6. **Concurrent Users**: Backend scaling based on subscription plan

---

## Future Roadmap

### Phase 2
- Video consultation with healthcare providers
- Appointment scheduling system
- Prescription digital verification
- Insurance integration

### Phase 3
- Wearable device integration (Apple Watch, Fitbit)
- Advanced health analytics dashboard
- Social health network features
- Telemedicine marketplace

### Phase 4
- Machine learning health predictions
- Personalized nutrition planning
- Fitness tracking integration
- Mental health support features
- Premium subscription model

### Technical Improvements
- Migration to Riverpod state management
- Implementation of BLoC pattern
- Advanced caching strategies
- Offline-first architecture
- Web and desktop platform support

---

## References & Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)
- [Supabase Documentation](https://supabase.io/docs)
- [Google Places API](https://developers.google.com/maps/documentation/places)
- [Flutter State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Responsive Design](https://flutter.dev/docs/development/ui/layout/responsive)

### Healthcare Standards
- HIPAA (Health Insurance Portability and Accountability Act)
- GDPR (General Data Protection Regulation)
- HL7/FHIR (Healthcare interoperability standards)

---

## Team Members

| # | Name
|---|---|
| 1 | Hussein Hossam 
| 2 | Fady Hany
| 3 | Youssef Mohammed
| 4 | Samouil Ayman
| 5 | Besada Nabil
| 6 | Makarious Nasser

**Supervisors:**
- Dr. Sherif Sobhy

---

## License

This project is developed as an academic graduation project at Thebes Higher Institute of Management & Information Technology. All rights reserved for educational and institutional purposes.