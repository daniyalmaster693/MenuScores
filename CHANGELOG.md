# MenuScores Changelog & Notes

## Favorite Teams Feature (2025-02-25)

### Overview
Added the ability to select favorite teams and receive notifications when they play. Favorite team games can be auto-pinned to the notch or menubar.

### New Files
- `MenuScores/Utils/FavoriteTeam.swift` - Data models for favorites
- `MenuScores/Utils/FavoritesManager.swift` - Core logic for managing favorites
- `MenuScores/Utils/LeagueAPIMapping.swift` - Maps leagues to ESPN API endpoints
- `MenuScores/Notifications/FavoriteGameNotification.swift` - Notification functions
- `MenuScores/Views/Settings Views/FavoritesSettings.swift` - Settings UI

### Modified Files
- `MenuScores/Utils/GetGames.swift` - Added team fetching method
- `MenuScores/Views/Settings Views/SettingsView.swift` - Added Favorites tab
- `MenuScores/MenuScoresApp.swift` - Added favorites checking during refresh

### Settings
Access via Settings > Favorites:
- **Notify when game starts**: Get a notification when a favorite team's game begins
- **Notify when game ends**: Get a notification when a favorite team's game finishes
- **Auto-pin favorite games**: Automatically pin favorite team games to notch/menubar

### Supported Leagues
Team sports only (individual sports like Tennis, Golf, UFC, Racing are excluded):
- Hockey: NHL, NCAA Hockey
- Basketball: NBA, WNBA, NCAA Basketball
- Football: NFL, NCAA Football
- Baseball: MLB, NCAA Baseball/Softball
- Soccer: MLS, NWSL, EPL, La Liga, Bundesliga, Serie A, Ligue 1, Champions League, Europa League, Liga MX, and more
- Lacrosse: NLL, PLL, NCAA Lacrosse
- Volleyball: NCAA Volleyball

---

## Important Notes

### Relegation & Promotion (Soccer Leagues)
The favorites system is **league-agnostic** when matching games. This means:

- If you add Manchester United as a favorite from the Premier League, and they get relegated to the Championship, the app will **still detect them** in Championship games.
- The league stored with your favorite is just metadata showing where you originally selected the team - it doesn't restrict matching.
- **Requirement**: You must have the appropriate league enabled in Settings > Leagues. If your team moves to a different league, enable that league to see their games.

### How Matching Works
When checking if a game involves a favorite team, the app only compares team IDs - not league associations. ESPN uses stable team IDs that persist across league changes, so your favorites remain valid even after promotion/relegation.
