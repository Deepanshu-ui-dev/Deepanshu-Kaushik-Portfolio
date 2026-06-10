# DEEPANSHU KAUSHIK — PORTFOLIO

```
  ██████╗ ███████╗███████╗██████╗  █████╗ ███╗   ██╗███████╗██╗  ██╗██╗   ██╗
  ██╔══██╗██╔════╝██╔════╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██║  ██║██║   ██║
  ██║  ██║█████╗  █████╗  ██████╔╝███████║██╔██╗ ██║███████╗███████║██║   ██║
  ██║  ██║██╔══╝  ██╔══╝  ██╔═══╝ ██╔══██║██║╚██╗██║╚════██║██╔══██║██║   ██║
  ██████╔╝███████╗███████╗██║     ██║  ██║██║ ╚████║███████║██║  ██║╚██████╔╝
  ╚═════╝ ╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝

  O B S I D I A N   &   Z I N C   //   v 2 . 0 . 0
```

> A minimal, editorial personal portfolio built with Flutter. Cold zinc palette. Hairline grids. Tactile micro-interactions. A pixel cat that follows your cursor.

---

## ✦ Features

### 🎨 Design System
- **Obsidian & Zinc Palette** — Pure cold zinc monochrome scale (`zinc-950 → zinc-50`). Zero warm tones, zero hue shifts.
- **Dark & Light Mode** — True-black dark base (`#09090B`) and crisp white light base (`#FFFFFF`), both with sharp ink contrast.
- **Diagonal Hatch Dividers** — 315° repeating hairline stripe bands between sections, painted with a custom `CustomPainter` and GPU-cached via `RepaintBoundary`.
- **Editorial Grid** — Max-content width constrained to `720px`, mimicking a print-editorial column layout with visible guide hairlines on widescreen.
- **Typefaces** — `Outfit` for display & body copy; `JetBrains Mono` for code, metadata, and tags.

### 🐱 Interactive Cat (Oneko)
A pixel cat sprite that lives on every screen:
- **Desktop**: follows your mouse cursor continuously.
- **Mobile**: chases taps, long-presses, and swipes.
- **Speech Bubbles**: the cat talks! It says things like `"hi! 👋"` on load, `"play time! 🐾"` when woken up, `"going for sleep... 💤"` when returning home, and `"zzz... 😴"` once asleep — with smooth scale + opacity animations.
- **Idle Animations**: sleeping, scratching itself, scratching walls — all pulled from the classic `oneko.gif` sprite sheet.

### 🏠 Home Screen
- **Hero Section** — Name, title typewriter effect, and CTA links.
- **Opportunities Banner** — Animated typewriter cycling through current availability.
- **GitHub Contribution Heatmap** — Live GitHub commit activity rendered as a custom-drawn monochrome grid with shimmer loading states.
- **Experience Timeline** — Collapsible, left-border-hover animated work history cards.

### 📬 Contact
- **Chat-UI Contact Interface** — A mock bot-assisted chat that guides users through emailing. Pre-fills subject and body into the native mail client via `mailto:`.
- **Zero Data Storage** — Nothing is stored in any third-party database.

### 📸 Photography
- Responsive multi-column gallery viewer matching the editorial aesthetic.

### 🛠 Projects & Skills
- Filterable project cards with tech-stack chips.
- Philosophy cards and tool/framework badges.

### 📊 Live Visitor Counter
- Real-time global visitor count powered by **Supabase RPC** — displayed with a custom ordinal badge (e.g. `YOU'RE THE 1,324th VISITOR`).

---

## 🏗 Architecture

```
lib/
├── config/
│   └── portfolio_config.dart          # Central static content & configuration
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Colors, spacing, radii, full ThemeData
│   └── widgets/
│       ├── cat_cursor_follower.dart   # Oneko pixel cat with speech bubbles
│       ├── floating_nav_bar.dart      # Magnetic-hover floating bottom nav
│       ├── hatch_background.dart      # Diagonal hatch & screen-line dividers
│       ├── shared_widgets.dart        # TypewriterLine, footer, section headers
│       ├── stagger_reveal.dart        # Visibility-triggered stagger animations
│       ├── left_border_hover.dart     # Hover left-border accent cards
│       ├── scroll_border_app_bar.dart # App bar with scroll-reactive border
│       └── tech_chip.dart             # Monochrome technology badge chip
└── features/
    ├── about/        # About screen & personal details
    ├── blog/         # Blog list & post detail screens
    ├── contact/      # Chat-style contact UI
    ├── github/       # GitHub API bindings & statistics screen
    ├── home/         # Hero, heatmap, experience, opportunities
    ├── photography/  # Gallery view & lightbox
    ├── projects/     # Project cards with filter tags
    └── skills/       # Philosophy cards & tool/framework badges
```

---

## ⚡ Performance

| Optimization | Detail |
|---|---|
| **Stack-based texture caching** | Background canvas elements decoupled from scroll tree via `Stack` + `RepaintBoundary` — zero repaints on scroll |
| **Repaint boundaries** | Applied to heavy animation nodes (`opportunities_banner`, `contribution_graph`) to isolate ticker frames |
| **Shared shimmer controller** | Heatmap loader shimmers share a single `AnimationController` to avoid thread saturation |
| **FilterQuality.none on sprites** | Pixel-perfect oneko cat rendering with no blurring overhead |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK **3.x** or later
- Dart SDK (bundled with Flutter)

### Run locally

```bash
# 1. Clone
git clone https://github.com/Deepanshu-Kaushik/Deepanshu-Kaushik-Portfolio.git
cd Deepanshu-Kaushik-Portfolio

# 2. Install dependencies
flutter pub get

# 3. Run (Android / iOS / Desktop)
flutter run

# 4. Run on Chrome (web)
flutter run -d chrome --web-renderer canvaskit
```

---

## 🔧 Environment Variables

The app uses Supabase for the visitor counter. Set the following environment variables at build time:

```bash
flutter run \
  --dart-define=SUPABASE_URL=<your-url> \
  --dart-define=SUPABASE_ANON_KEY=<your-key>
```

---

## 📄 License

MIT © Deepanshu Kaushik
