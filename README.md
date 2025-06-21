# Undercover Game (Flutter Frontend)

Hi there — I’m Alejandro Ruesga! 👋

## What and Why This?

This project, together with its sister repository—the backend—is a cross-platform party game for friends on iOS, Android, and the Web.

I’ve been programming for 12+ years. Until now, every repo I wrote stayed private—sometimes because I feared my “next-big-app” idea would be copied, other times because the code belonged to a company. But the best part of our craft is, without doubt, open-source. I’m a Linux enthusiast who loves C++, PHP, TypeScript/JavaScript, Dart, and more; an open community has always helped me, so I’m giving back by releasing this project openly. 🐧

This game is meant to be played with friends, good vibes, and 🍻 a cold beer. So please enjoy it by playing or helping with this project.

Feel free to fork, improve, and enjoy—pull requests are welcome! 😄

## The Game – Undercover 🕵️‍♂️

Welcome to **Undercover Game Front** — a Flutter client for the classic party game *Undercover* (also known as *Spyfall* or *Loup-Garou Undercover*).  
Launch the app, add your friends, and start a round in seconds; all preferences (language, theme, colors) are stored locally, so the next match is always one tap away.

### Gameplay (example)

| Players | What they see | Goal |
|---------|---------------|------|
| **4 × Regulars** | **“Lightsaber”** | Spot the spies |
| **2 × Undercovers** | **“Wand”** | Blend in & survive |

* **Clue round** – In the order shown by the app, each player gives **one clue** related to their word.  
   *No repeats, and you may **not** say the actual word you read.*

*  **Discussion & vote** – After all clues, debate who the undercovers are and cast your vote in-app.  
   The app immediately reveals whether the chosen player *was* an undercover.

*  **Elimination** – A wrongly accused player sits out; play continues with the remaining players.

* **Win conditions**  
   * **Citizens win** if all undercovers are eliminated.  
   * **Undercovers win** if they become the last team standing.

Quick to learn, perfect for game nights, and totally offline — just pass the device around, share some laughs, and enjoy! 🍻



## Features

| ✅   | Description                          |
|------|--------------------------------------|
| ⚡   | Quick-match wizard                   |
| 🌐   | English & Spanish UI (runtime switch) |
| 🎨   | Light / Dark / System theme, 6 accent colors |
| 💾   | Preferences persisted via `shared_preferences` |
| 🖥️   | Runs on Web, iOS, Android, desktop  |

## Getting Started

```bash
git clone https://github.com/poropo97/under-cover-game-front.git
cd under-cover-game-front
flutter pub get
flutter gen-l10n             # if you modify .arb files
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 9797
```

### Project Structure

| Path              | Purpose                     |
|-------------------|-----------------------------|
| `lib/screens/`    | UI pages                   |
| `lib/l10n/`       | ARB + generated localizations |
| `assets/`         | Logo, Lottie splash        |

## Contributing

1. Fork & branch (e.g., `feat/local_scoreboard`).
2. Ensure `flutter analyze` is clean.
3. Submit a clear PR with screenshots.

Translations, bug fixes, and new extras are welcome!

## Acknowledgements & Donate ☕

Thanks to Flutter, Dart, LottieFiles, and the board-game creators.  
If you enjoy the project, star ⭐ it or buy me a coffee:

- [Ko-fi](https://ko-fi.com/alejandroruesga)  
<!-- - [PayPal](https://paypal.com) -->

## License

Apache-2.0 (see LICENSE).  
Need a proprietary license without attribution? → alejandro.ruesga97@gmail.com
