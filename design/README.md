# Design Package

Дизайн-система для приложения Taskify.

## Компоненты

- **Colors** - цветовая палитра приложения
- **Themes** - светлая и темная темы
- **Typography** - типографика
- **Spacing** - отступы и размеры

## Использование

```dart
import 'package:design/design.dart';

// Использование цветов
Container(color: AppColors.primary)

// Использование темы
MaterialApp(theme: AppTheme.lightTheme)

// Использование типографики
Text('Hello', style: AppTypography.headlineLarge)

// Использование отступов
Padding(padding: EdgeInsets.all(AppSpacing.md))
```
