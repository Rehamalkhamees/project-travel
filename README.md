# Saudi Escape: Your Bag, Your Destination

A Flutter app for choosing where to go in Saudi Arabia and what to pack for it. Every destination comes with its own bag: AlUla asks for a camera and comfortable shoes, Umluj for a swimsuit, Abha for warm clothes.

A Flutter project with web, Android and Windows targets. Destinations are loaded from Supabase.

<p align="center">
  <img src="docs/screenshots/desktop-hero.webp" alt="Home screen on desktop: the AlUla stage with the bag chips, the map and the facts panels" width="100%">
</p>

<p align="center">
  <img src="docs/screenshots/desktop-explore.webp" alt="About the experience, Don't miss and the destination cards" width="100%">
</p>

<p align="center">
  <img src="docs/screenshots/phone-home.webp" alt="Home screen on a phone" width="300">
  &nbsp;&nbsp;
  <img src="docs/screenshots/phone-detail.webp" alt="AlUla detail screen on a phone" width="300">
</p>

## How it works

Every destination has its own things to pack. The stage shows only the ones for the destination you are on, and you tick them off as you pack.

| Destination | In your bag |
| --- | --- |
| AlUla | Camera, Comfortable shoes |
| Umluj | Swimsuit |
| Abha | Warm clothes |
| Riyadh | Best outfit |
| Diriyah | Curiosity |

The line above the chips says what is still missing, for example *Pack camera + comfortable shoes for AlUla*, or *Your bag is ready for AlUla* once everything is ticked. Each destination card shows how many of its items you have packed.

The items live in `lib/data/bag.dart`. A destination added from the app has no items yet, so its stage shows no bag.

## Features

- **Stage:** a large photo with the destination's name, its bag to tick off, a counter and previous / next buttons. Photos cross-fade when you switch.
- **Facts:** a line map of Saudi Arabia that marks the destination and its route from Riyadh, plus region, distance, best season and type of experience.
- **Story:** *About the experience* and *Don't miss* for each destination.
- **Destinations:** search, and a card for each destination that shows how many of its items you have packed.
- **Add a destination:** the **+** button opens a form (name, type, one of the bundled photos, accent colour) and saves a new row to `destinationData`. A destination with a new name shows the photo you picked on the stage, with general texts.
- **Responsive:** a wide layout on desktop and tablet; on phones the card opens a detail screen.
- **Reliable loading:** the destinations load once; if the request fails there is a message and a *Try again* button.
- **Accessible:** buttons have labels, the map has a text description, and the map's pulse stops when the system's reduce-motion setting is on.

## Run it

You need a Flutter beta that ships Dart 3.14 or newer (the project requires `^3.14.0-95.2.beta`).

```bash
git clone https://github.com/Rehamalkhamees/project-travel
cd project-travel
cp .env.example .env      # then put your Supabase URL and key in .env
flutter pub get
flutter run -d chrome
```

### Try it without Supabase

The app can run on the sample destinations that ship with it. `.env` must still exist, but its values can stay as placeholders.

```bash
cp .env.example .env
flutter run -d chrome --dart-define=OFFLINE_DEMO=true
```

### Supabase table

The app reads a table called `destinationData` with these columns:

| Column | Example | Notes |
| --- | --- | --- |
| `name` | `AlUla` | Must be one of `Diriyah`, `Riyadh`, `AlUla`, `Umluj`, `Abha`: the hero photo, map position, texts and bag items are looked up by name. |
| `type` | `Adventure` | Shown as the destination's experience. |
| `image` | `assets/images/alula2.jpeg` | The card photo, a path inside `assets/images/`. |
| `color` | `0xFFEB9C63` | The destination's accent colour as an ARGB number. |

Saving from the app needs permission to insert into this table. If you use Row Level Security, add an insert policy for the role the app uses; otherwise the form shows the error from Supabase.

## Tests

```bash
flutter test
```

They cover the bag items, ticking them on the home page, search, the retry button, adding a destination, and that the phone layout builds without overflow.

## Project structure

```
lib/
  main.dart                      start-up (loads .env, connects to Supabase)
  config.dart                    the OFFLINE_DEMO switch
  models/destination_model.dart  a row of destinationData
  service/database.dart          reads the table
  data/
    bag.dart                     bag items and the matching rules
    destination_content.dart     region, season, distance, texts and map position per destination
    demo_destinations.dart       sample rows for the offline demo and tests
  pages/                         home page and the phone detail screen
  widgets/                       stage, map, panels, story, cards
  ui/style.dart                  colours, text styles, breakpoints
assets/
  images/                        destination photos
  fonts/                         Bebas Neue and Manrope (SIL Open Font License)
docs/screenshots/                the images in this README
```

To change a destination's season, region or texts, edit `lib/data/destination_content.dart`. Distances are straight-line estimates from Riyadh, and the map is a simplified outline.
