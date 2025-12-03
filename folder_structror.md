lib/
├── core/                          # Core utilities, constants, themes
│   ├── constants/                 # App constants
│   ├── theme/                     # Theme configuration
│   ├── router/                    # Navigation (go_router)
│   ├── network/                   # Network layer (Dio)
│   ├── error/                     # Error handling
│   └── utils/                     # Utility functions & extensions
│
├── data/                          # DATA LAYER (Clean Architecture)
│   ├── models/                    # Data models (Freezed + JsonSerializable)
│   ├── datasources/               # Data sources (Remote/Local)
│   │   ├── remote/
│   │   └── local/
│   └── repositories/              # Repository implementations
│
├── domain/                        # DOMAIN LAYER (Business Logic)
│   ├── entities/                  # Business entities
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Use cases
│
├── presentation/                  # PRESENTATION LAYER (MVVM)
│   ├── providers/                 # Riverpod providers (ViewModel)
│   ├── pages/                     # App pages (View)
│   └── widgets/                   # Shared widgets
│       └── common/                # Common reusable widgets
│
└── main.dart