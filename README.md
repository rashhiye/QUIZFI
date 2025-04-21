#📱 QuizFi

QuizFi is an offline multiplayer quiz application designed for fun and competitive learning. Built with Flutter, it allows users to host and join quiz rooms over a local hotspot, personalize their experience with avatars and themes, and track performance through an interactive leaderboard.

#🚀 Features
🎮 Multiplayer Support: Create or join rooms over a local network.

🧠 AI-Powered Quizzes: Quick Play mode uses Gemini AI for dynamic quiz generation.

👥 Player Avatars: Choose from 9 custom avatar emojis for personalization.

🌙 Theme Toggle: Switch between light and dark mode anytime.

📊 Leaderboard: Real-time scoring for multiplayer games.

📱 Offline First: Works entirely offline without internet connectivity.

💾 Local Storage: Uses Hive for efficient local database management.

#🛠️ Technologies Used
Flutter (Dart)

Hive (Local database)

Gemini AI (for Quick Play quiz generation)

TCP Sockets (for communication over hotspot)

SharedPreferences (for theme & avatar preferences)


#📂 Project Structure (Core Modules)
main.dart — Entry point

tcp_client.dart / tcp_server.dart — Handles communication between players

create_room/, join_room/, quick_play/ — Quiz modes

settings/ — Avatar selection, theme switcher, profile rename, etc.

leaderboard/ — Shows real-time scores

login/ — Player name input with validation

#🧑‍💻 Getting Started
Clone the repository:

bash
Copy
Edit
git clone <your-repo-url>
cd quizfi
Install dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

bash
Copy
Edit
flutter run
⚠️ Note: To use multiplayer features, ensure devices are connected via the same local hotspot.

#🧑‍🤝‍🧑 Team Members
QUIZFI-TEAM

Muhammed Fadhi T

Devanandhu KKT

Muhammed Rashid KP

📄 License
MIT License
