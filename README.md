#  Student Grade Calculator

A Flutter app to manage student grades, calculate results, rank students and view class statistics.

## Features

- **Setup Subjects** — Define 1–10 custom subjects (e.g. Maths, English, Science)
- **Add / Edit / Delete Students** — Register students with scores per subject
- **Grade Calculation** — Automatically computes average, letter grade (A+ to F), and remark
- **Class Ranking** — Results displayed in descending order (1st to last)
- **Statistics Dashboard**:
  -  Highest grade & top student
  -  Lowest grade & bottom student
  -  Class average
  -  Pass rate percentage
- **Grade Distribution Chart** — Visual bar for each grade band
- **Grading Key** — Built-in reference table

## Grading Scale

| Grade | Range   | Remark    |
|-------|---------|-----------|
| A+    | 90–100  | Excellent |
| A     | 80–89   | Very Good |
| B+    | 75–79   | Very Good |
| B     | 70–74   | Good      |
| C+    | 65–69   | Good      |
| C     | 60–64   | Average   |
| D+    | 55–59   | Pass      |
| D     | 50–54   | Pass      |
| F     | 0–49    | Fail      |

> **Pass mark is 50%**

## Project Structure

```
lib/
├── main.dart                         # App entry point
├── models/
│   └── student.dart                  # Student data model
├── screens/
│   ├── home_screen.dart              # Student list & management
│   └── results_screen.dart           # Rankings & statistics
└── widgets/
    ├── add_student_dialog.dart       # Add/Edit student form
    └── setup_subjects_dialog.dart    # Configure subjects
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Run the App

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK
flutter build apk --release
```

## How to Use

1. **Tap the tune icon (⚙️)** in the top-right to set up your subjects
2. **Tap "Add Student"** to register each student and enter their scores
3. **Edit or delete** students using the icons on each card
4. **Tap "Calculate Results"** to view the full ranked report with statistics
