<div align="center">
<img src="https://github.com/daniyalmaster693/MenuScores/blob/main/MenuScores/Assets.xcassets/TahoeIcon.imageset/MenuScores-Tahoe.png" width="140">

  <h1>MenuScores</h1>
  <p>Live Scores, Designed for Mac</p>

</div>

<div align="center">

[![GitHub License](https://img.shields.io/github/license/daniyalmaster693/MenuScores)](License)
[![Downloads](https://img.shields.io/github/downloads/daniyalmaster693/MenuScores/total.svg)](https://github.com/daniyalmaster693/MenuScores/releases)
[![macOS Version](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://www.apple.com/macos/)

</div>

<br>
<br>

<img src="/Assets/Mockups/MenuScores-Cover.png" width="100%" alt="MenuScores"/><br/>

## Supported Leagues

- NHL
- Men's College Hockey
- Women's College Hockey
- NBA
- WNBA
- Men's College Basketball
- Women's College Basketball
- NFL
- College Football
- MLB
- College Baseball
- College Softball
- Champions League
- Europa Champions League
- Women's Champions League
- MLS
- National Women's Soccer League
- Premier League
- Women's Super League
- La Liga
- Bundesliga
- Serie A
- LIGA MX
- Ligue 1
- Eredivisie
- Primeira Liga
- F1
- Nascar Premier
- Nascar Secondary
- Nascar Truck
- IndyCar
- PGA
- LPGA
- ATP
- WTA
- NLL
- PLL
- Men's College Lacrosse
- Women's College Lacrosse
- Men's College Volleyball
- Women's College Volleyball
- Men's Olympic Ice Hockey
- Women's Olympic Ice Hockey
- Men's Olympic Basketball
- Women's Olympic Basketball
- FIFA World Cup
- FIFA Women's World Cup
- FIFA World Cup UEFA Qualifiers
- FIFA World Cup CONMEBOL Qualifiers
- FIFA World Cup CONCACAF Qualifiers
- FIFA World Cup African Qualifiers
- FIFA World Cup Asian Qualifiers
- FIFA World Cup Oceanian Qualifiers

## Features

- **Live Notch Scores** - Pin games to your notch and receive real-time score updates and game info available at a glace.
- **Live Menubar Scores** - Pin games to your menu bar and receive real-time score updates available at a glance.
- **Track your favorite teams** - Select your favorite teams and live games will automatically pin to your menu bar or notch once live.
- **Smart Notifications** - Get notified when a pinned game starts or finishes.
- **League Control** - Track over 48 different leagues across 12 different sports.
- **Lightweight & Native** - Built with Swift and SwiftUI for a native performance and seamless macOS integration.

## Installation

**Requires macOS 13.0 and later**

### Manual Installation

1. Open the [latest release](https://github.com/daniyalmaster693/MenuScores/releases/latest) and download `MenuScores.zip`.
2. Extract the `.zip` file and drag `MenuScores.app` into your **Applications** folder.

**Note:** Because the app is not signed, on first launch, macOS may warn that the app couldn't be verified. To open it:

1. Click **OK** on the warning prompt.
2. Open **System Settings → Privacy & Security**.
3. Scroll down to the security section and click **Open Anyway**.

### Homebrew

You can also install and manage MenuScores using Homebrew:

```bash
brew tap daniyalmaster693/casks
brew trust --cask daniyalmaster693/casks/menuscores
brew install --cask menuscores
xattr -dr com.apple.quarantine /Applications/MenuScores.app
```

## Usage

- **In order to use the notifications feature**, you must grant permission for MenuScores to send notifications. An option will be presented to do so in the settings window under the behavior tab by clicking the question mark icon.

1. Clicking on the radio waves icon will show a list available leagues.

2. Hovering over a league show you different games.

3. Hovering over a game will allow you to choose from pinning the game to your menubar, notch, or viewing the game page in your browser on ESPN. **Important: If you pin a game to the notch and then to the menubar, the app will only update the newest pin**.

**Note: the notch feature works best on Macbooks with a notch. It will still work on non notched devices, but hovering over it will not open the expanded view. You can still expand the notch using the expand notch shortcut**

4. You can use the clear set game option to remove a game, or pin a different game to clear a pinned game.

5. When a game is pinned to the notch, expanding it will reveal different info depending on the game state and league.

6. You can configure enabled leagues from the preferences window.

### Auto Pin Games

**Note: the Auto Pin feature supports all leagues except Tennis.**

**Configuration**

1. Configure your favorite teams directly from the **Favorites** tab in the Settings window by selecting a league to load its teams.
2. Only enabled leagues are supported. If you add a team and later disable the league, make sure to remove the team.
3. Click the star icon next to a team to add it to your favorites.
4. Teams added as favorites will be displayed in the favorite teams section. You can choose to remove a team using the star icon or change it's priority using the arrows.
5. The app uses the order of teams as a priority list to decide which game to pin if multiple favorite teams are playing live simultaneously. Higher-ranked teams take precedence.

**Usage**

6. Games are automatically pinned once they go live, and update in real time.
7. If you have a manually pinned game, the app will clear the game in favour of an auto pin game.
8. If you manually clear an auto pin game, the app will not auto pin that game again (unless you restart the app).
9. Once an auto pin game finishes, it will automatically be cleared from the notch/menubar.

## Roadmap

- [x] ~Notch Display for Games~
- [x] ~Links to more game info~
- [x] ~Detailed Leaderboards for F1~
- [x] ~Recent plays in the notch~
- [x] ~Headline features for pre game and post game matchups~
- [x] ~Additional live game info (outs, strikes, down placements, weather info, arena info)~
- [x] ~Animated score updates and game loading~
- [x] ~Higher quality icons for notch views~
- [x] ~Automatically pin games to the notch or menubar (favorite teams feature)~
- [x] ~Tennis Integration~
- [x] ~Multi day schedules and scores~
- [ ] Automatically clear games from the notch or menubar when finished (for manual pins)
- [ ] Automatic notch expansion for game events (goals, penalties, and key moments)
- [ ] UFC Integration
- [ ] Cricket Integration
- [ ] Updated Menubar control view
- [ ] Custom Menubar Score Component
- [ ] Lock Screen Widgets
- [ ] App Widgets

...and more to come...

## Dependencies

- [DynamicNotchKit](https://github.com/MrKai77/DynamicNotchKit)
- [TourKit](https://github.com/rampatra/TourKit)
- [LaunchAtLogin Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)
- [Keyboard Shortcuts](https://github.com/sindresorhus/KeyboardShortcuts)

## Contributions

Any contributions and feedback is welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [GPLv3 License](LICENSE).
