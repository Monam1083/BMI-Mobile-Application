# 🧮 BMI Calculator — Flutter App

A sleek, dark-themed Body Mass Index calculator built with Flutter. Features smooth animations, color-coded results, gender selection, and personalised health advice — all in a single self-contained Dart file.

---

## 📸 Screenshots


| Home Screen | Result Card |
|---|---|
<img width="666" height="1488" alt="WhatsApp Image 2026-05-13 at 9 37 45 AM (1)" src="https://github.com/user-attachments/assets/94d9eec4-97b8-49f4-b28c-8b6abe4365a4" />
<img width="709" height="1482" alt="WhatsApp Image 2026-05-13 at 9 37 45 AM (2)" src="https://github.com/user-attachments/assets/0c198716-d994-4a68-9106-bbcf345ea3ce" />
<img width="656" height="1473" alt="WhatsApp Image 2026-05-13 at 9 37 45 AM" src="https://github.com/user-attachments/assets/8faeff1f-10c5-4089-91ce-3cf706a45218" />
<img width="720" height="1494" alt="WhatsApp Image 2026-05-13 at 9 37 46 AM" src="https://github.com/user-attachments/assets/af4afe1e-269a-40ce-b102-ea87173649d3" />



---
## video




https://github.com/user-attachments/assets/1474fcbe-c892-4b88-b6dc-8635f7446226


## ✨ Features

- **Gender toggle** — animated Male / Female selector
- **Clean inputs** — height (cm) and weight (kg) with large, readable typography
- **BMI gauge** — circular progress indicator that fills based on your BMI value
- **Color-coded categories**

| Category | BMI Range | Color |
|---|---|---|
| Underweight | < 18.5 | 🔵 Blue |
| Normal Weight | 18.5 – 24.9 | 🟢 Teal |
| Overweight | 25 – 29.9 | 🟠 Amber |
| Obese | ≥ 30 | 🔴 Red |

- **Contextual advice** — a personalised health tip shown for each BMI category
- **Input validation** — handles empty fields, non-numeric input, and zero/negative values with friendly snackbar messages
- **Smooth animations** — slide + fade transition when the result card appears

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart SDK `2.17.0` or higher

Check your versions:

```bash
flutter --version
dart --version
```

## 📁 Project Structure

```
bmi-calculator-flutter/
├── lib/
│   └── main.dart          # Entire app — single file
├── fonts/                 # Poppins font files (optional)
├── pubspec.yaml
└── README.md
```

Since this is a single-file project, all logic, widgets, and styling live in `lib/main.dart` 

---

## 🧠 BMI Formula

```
BMI = weight (kg) / height (m)²
```

Height is entered in **centimetres** and converted internally:

```dart
double heightM = heightCm / 100;
double bmi = weightKg / pow(heightM, 2);
```

---

## 🎨 Design System

| Token | Value | Usage |
|---|---|---|
| `_bg` | `#0D0D1A` | App background |
| `_card` | `#1A1A2E` | Card surfaces |
| `_accent` | `#7C4DFF` | Primary purple |
| `_accentLight` | `#B47AFF` | Gradient end / icons |
| `_teal` | `#00E5CC` | Normal weight highlight |
| `_textPrimary` | `#EEEEFF` | Headings & values |
| `_textSecondary` | `#9999BB` | Labels & subtitles |

---

## 🐛 Known Bugs Fixed (vs original)

| # | Bug | Fix Applied |
|---|---|---|
| 1 | Calculate button not wired up | `onPressed: calculateBMI` |
| 2 | `setState()` syntax error in gender toggle | Corrected to `setState(() { ... })` |
| 3 | `BorderRadiusGeometry.circular()` compile error | Changed to `BorderRadius.circular()` |
| 4 | `EdgeInsetsGeometry.all()` compile error | Changed to `EdgeInsets.all()` |
| 5 | No try/catch — crashes on bad input | Wrapped in `try/catch` with snackbar |
| 6 | No zero/negative validation | Added guard before calculation |
| 7 | Weight field used `Icons.height` | Changed to `Icons.monitor_weight_outlined` |
| 8 | BMI category never shown in result | Category chip added to result card |
| 9 | Gender toggle looked identical in both states | Proper selected/unselected styling |
| 10 | Method named `CalculateBMI` (PascalCase) | Renamed to `calculateBMI` (Dart convention) |

---

## 📦 Dependencies

This project uses **only Flutter's built-in packages** — no third-party dependencies required.

```yaml
dependencies:
  flutter:
    sdk: flutter
```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---



---

_Built with ❤️ using Flutter_
