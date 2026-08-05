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

## Features

- **Live Notch Scores** - Pin games to your notch and receive real-time score updates and game info available at a glace.
- **Live Menubar Scores** - Pin games to your menu bar and receive real-time score updates available at a glance.
- **Track your favorite teams** - Select your favorite teams and live games will automatically pin to your menu bar or notch once live.
- **Smart Notifications** - Get notified when a pinned game starts or finishes.
- **Lightweight & Native** - Built with Swift and SwiftUI for a native performance and seamless macOS integration.

## Supported Sports

MenuScores supports 50+ leagues across 12 different sports.

See [LEAGUES.md](LEAGUES.md) for the complete list.

## Installation

**Requires macOS 13.0 and later**

### Manual Installation

1. Open the [latest release](https://github.com/daniyalmaster693/MenuScores/releases/latest) and download `MenuScores.zip`.
2. Extract the `.zip` file and drag `MenuScores.app` into your **Applications** folder.

**Note:** Because the app is not signed, on first launch, macOS may warn that the app couldn't be verified. To open it:

1. Click **Done** on the warning prompt.
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

**To use the notifications feature**, you must grant permission for MenuScores to send notifications. An option will be presented to do so in the settings window under the behavior tab by clicking the question mark icon.

1. Click the **radio waves** icon in the menu bar to browse available leagues.
2. Hovering over a league will show you different games. From there you can select a game to pin to the **menu bar**, **notch**, or open it on ESPN.
3. Configure enabled leagues, favorite teams, notifications, and other preferences from the **Settings** window.

**Note:** The notch display works best on MacBooks with a notch. On Macs without a notch, the notch can still be expanded using the **Expand Notch** keyboard shortcut.

### Auto Pin Games

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

**Note:** the Auto Pin feature supports all leagues except Tennis.

## Roadmap

- [x] ~Notch Display for Games~
- [x] ~Detailed Leaderboards for F1~
- [x] ~Recent plays and additional game info in the notch~
- [x] ~Headline features for pre game and post game matchups~
- [x] ~Automatically pin games to the notch or menubar (favorite teams feature)~
- [x] ~Tennis Integration~
- [x] ~Multi day schedules and scores~
- [ ] Automatically clear games from the notch or menubar when finished (for manual pins)
- [ ] Automatic notch expansion for game events (goals, penalties, and key moments)
- [ ] UFC Integration
- [ ] Cricket Integration
- [ ] Updated Menubar Views and custom Menubar Score Component
- [ ] Widgets

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
