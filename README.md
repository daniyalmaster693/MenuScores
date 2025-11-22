<div align="center">
<img src="https://github.com/daniyalmaster693/MenuScores/blob/main/MenuScores/Assets.xcassets/TahoeIcon.imageset/MenuScores-Tahoe.png" width="140">

  <h1>MenuScores</h1>
  <p>Live Scores - Right From Your Notch</p>

</div>

<div align="center">

[![GitHub License](https://img.shields.io/github/license/daniyalmaster693/MenuScores)](License)
[![Downloads](https://img.shields.io/github/downloads/daniyalmaster693/MenuScores/total.svg)](https://github.com/daniyalmaster693/MenuScores/releases)
[![macOS Version](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://www.apple.com/macos/)

</div>

<br>
<br>

<img src="/Assets/MenuScores-3.png" width="100%" alt="MenuScores"/><br/>

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
- FIFA World Cup
- FIFA Women's World Cup
- FIFA World Cup UEFA Qualifiers
- FIFA World Cup CONMEBOL Qualifiers
- FIFA World Cup CONCACAF Qualifiers
- FIFA World Cup African Qualifiers
- FIFA World Cup Asian Qualifiers
- FIFA World Cup Oceanian Qualifiers
- F1
- Nascar Premier
- Nascar Secondary
- Nascar Truck
- IndyCar
- PGA
- LPGA
- NLL
- PLL
- Men's College Lacrosse
- Women's College Lacrosse
- Men's College Volleyball
- Women's College Volleyball

## Features

- **Live Notch Scores** - Pin games to your notch and receive real-time score updates and game info available at a glace.
- **Live Menubar Scores** - Pin games to your menu bar and receive real-time score updates available at a glance.
- **Smart Notifications** - Get notified when a pinned game starts or finishes.
- **League Control** - Choose which leagues are shown and stay focused on the sports you care about.
- **Configurable** - Configure notification types and refresh intervals to fit your preferences.
- **Lightweight & Native** - Built with Swift and SwiftUI for fast performance and seamless macOS integration.

## Installation

**Requires macOS 13.0 and later**

### Manual Installation

1. Download the latest release.
2. Move the app to your **Applications folder**.
3. Run the app and grant necessary permissions when prompted.

### Homebrew

You can also install MenuScores using Homebrew:

```bash
brew tap daniyalmaster693/casks
brew install --cask menuscores
```

**Note**: On first launch, macOS may warn that the app couldn't be verified. Click **OK**, then go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** to launch the app.

## Usage

- **In order to use the notifications feature**, you must grant permission for MenuScores to send notification. An option will be presented to do so in the walkthrough screen.

1. Clicking on the menubar title will show a list available leagues.
2. Hovering over a league will show a dropdown of all the games for the day in that league.
3. Hovering over a game will allow you to choose from pinning the game to your menubar, notch, or viewing it in your browser.

**Note: the notch feature works best on Macbooks with a notch. It will still work on non notched devices, but hovering over it will not open the expanded view.**

4. You can use the clear set game option, or pin a different game to clear the menubar or notch.
5. When a game is pinned to the notch, expanding it will reveal different info depending on the game state and league.
6. You can quit the app directly from the menubar, or open the preferences window to configure app behaviors, or update the app.

## Roadmap

- [x] ~~Notch Display for Games~~
- [x] ~~Links to more game info~~
- [x] ~~Entire year race schedule for F1~~
- [x] ~Additional F1 Driver Info~
- [x] ~Additional Pre Game info~
- [x] ~Additional Live Game Info~
- [x] ~Recent plays in the notch component~
- [x] ~Smoother overall notch animations for score updates and game loading~
- [ ] Alerts for in game events (eg: powerplays, timeouts, yellow cards, etc)
- [ ] App Widgets
- [ ] Automatically pin games to the notch or menubar (favorite teams feature)

...and more to come...

## Dependencies

- [DynamicNotchKit](https://github.com/MrKai77/DynamicNotchKit)
- [LaunchAtLogin Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)
- [Keyboard Shortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
- [Sparkle](https://github.com/sparkle-project/Sparkle)

## Contributions

Any contributions and feedback is welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [GPLv3 License](LICENSE).
