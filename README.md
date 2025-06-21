[![pub package](https://img.shields.io/pub/v/flutter_page_gutter.svg)](https://pub.dartlang.org/packages/flutter_page_gutter)
[![GitHub stars](https://img.shields.io/github/stars/fingerart/flutter_page_gutter)](https://github.com/fingerart/flutter_page_gutter/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/fingerart/flutter_page_gutter)](https://github.com/fingerart/flutter_page_gutter/network)
[![GitHub license](https://img.shields.io/github/license/fingerart/flutter_page_gutter)](https://github.com/fingerart/flutter_page_gutter/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/fingerart/flutter_page_gutter)](https://github.com/fingerart/flutter_page_gutter/issues)

A flutter widget for handling PageView gaps.


> [!TIP]
> If this package is useful to you, please remember to give it a star✨ ([Pub](https://pub.dev/packages/flutter_page_gutter) | [GitHub](https://github.com/fingerart/flutter_page_gutter)).


## Preview

```text
--------+   +---------------+   +--------
        |   |               |   |
 0      |   |       1       |   |      2
        |   |               |   |
--------+   +---------------+   +--------
```

## Getting Started

```yaml
dependencies:
  flutter_page_gutter: ^0.0.1+3
```

```dart
import 'package:flutter_page_gutter/flutter_page_gutter.dart';

PageView.builder(
 controller: controller,
 itemBuilder: (context, index) => PageGutter(
   controller: pageController
   index: index,
   gap: 5,
   child: Placeholder(),
 ),
);
```

Using `DefaultPageController`:

```dart
DefaultPageController.builder(
  builder: (context, controller) {
    return PageView.builder(
      controller: controller,
      itemBuilder: (context, index) => PageGutter(
        index: index,
        gap: 5,
        child: Placeholder(),
      ),
    );
  },
);
```