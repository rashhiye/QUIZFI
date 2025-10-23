📱 QuizFi
​<p align="center">
<!-- REPLACE the image path below with your actual logo or a prominent app screenshot -->
<img src="path/to/your/quizfi_logo_or_screenshot.png" alt="QuizFi App Logo" width="300"/>
</p>
​QuizFi is an offline multiplayer quiz application designed for fun and competitive learning. Built with Flutter 🚀, it allows users to effortlessly host and join quiz rooms over a local hotspot, personalize their experience with unique avatars and themes, and track their performance through a real-time leaderboard.
​🌟 Key Features
​<!-- Using explicit HTML table structure as requested -->
​<table>
<thead>
<tr>
<th>Icon</th>
<th>Feature</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>🎮</td>
<td><b>Multiplayer Support</b></td>
<td>Create or join quiz rooms instantly over a <b>local Wi-Fi hotspot</b> network.</td>
</tr>
<tr>
<td>🧠</td>
<td><b>AI-Powered Quizzes</b></td>
<td>The <i>Quick Play</i> mode uses <b>Gemini AI</b> for dynamic, on-demand quiz generation.</td>
</tr>
<tr>
<td>👥</td>
<td><b>Player Avatars</b></td>
<td>Personalize your profile with a choice of <b>9 custom avatar emojis</b>.</td>
</tr>
<tr>
<td>🌙</td>
<td><b>Theme Toggle</b></td>
<td>Switch seamlessly between <i>Light</i> and <i>Dark</i> modes anytime for comfort.</td>
</tr>
<tr>
<td>📊</td>
<td><b>Real-time Leaderboard</b></td>
<td>Track performance and scores instantly during multiplayer games.</td>
</tr>
<tr>
<td>💾</td>
<td><b>Offline First</b></td>
<td>Works entirely offline without requiring any internet connectivity after installation.</td>
</tr>
</tbody>
</table>
​⚙️ Core Technologies
​QuizFi is powered by a robust stack designed for speed and offline reliability:
​Flutter (Dart): The primary framework for a beautiful, cross-platform mobile UI.
​Gemini AI: Powers the intelligent Quick Play feature for content generation.
​Hive: Used for highly efficient local database management and data persistence.
​TCP Sockets: Handles low-level, direct communication over the local hotspot network.
​SharedPreferences: Persists user settings like theme and avatar preferences.
​📂 Project Structure (Core Modules)
​The application is structured into clear, maintainable modules. We use the HTML <details> tag to keep this section tidy and collapsible.
​<details>
<summary><b>Click to View Detailed Module Breakdown</b></summary>


​main.dart — The application's main entry point.
​tcp_client.dart / tcp_server.dart — Manages low-level network communication between players.
​create_room/, join_room/, quick_play/ — Core screens for each quiz mode.
​settings/ — Contains logic for avatar selection, theme switching, and profile rename.
​leaderboard/ — Handles displaying and updating real-time scores.
​login/ — Player name input screen with validation.
​</details>
 Team Members
This project was built by the QUIZFI-TEAM:
<!-- Using explicit HTML table structure as requested -->
<table>
<thead>
<tr>
<th>Member</th>
<th>Role</th>
</tr>
</thead>
<tbody>
<tr>
<td>Muhammed Fadhi T</td>
<td>Lead Developer</td>
</tr>
<tr>
<td>Devanandhu KKT</td>
<td>UI/UX & Backend</td>
</tr>
<tr>
<td>Muhammed Rashid KP</td>
<td>Feature Implementation</td>
</tr>
</tbody>
</table>

License
This project is licensed under the MIT License.