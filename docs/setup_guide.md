# ⚙️ Setup & Installation Guide

## Prerequisites
- **Flutter SDK**: Version 3.8.1 or higher
- **Backend Server**: Ensure your backend is running before starting the app.

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/faizhebak/AITravelBuddy.git
   cd aitravelbuddy
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment**
   Create a `.env` file in the project root. This is **critical** for connecting to the backend.

   ```env
   # Android Emulator (loops back to host machine):
   BASE_URL=http://10.0.2.2:8000

   # Physical Device (use your machine's LAN IP):
   # BASE_URL=http://192.168.1.100:8000
   
   # iOS Simulator:
   # BASE_URL=http://localhost:8000
   ```
   > **Important**: The app uses `flutter_dotenv` to read `BASE_URL`. If this is missing, API calls will fail.

4. **Run the Application**
   ```bash
   flutter run
   ```

## Troubleshooting

- **API Connection Failed**: Verify `BASE_URL` in `.env`. Restart the app after changing `.env` (hot reload might not pick up env changes).
- **Camera/AR Issues**: The AR feature requires Camera permissions. Grant them when prompted. Note that AR results are currently simulated.
