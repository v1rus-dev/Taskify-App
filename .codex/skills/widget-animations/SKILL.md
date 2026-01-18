---
name: widget-animations
description: Use for animation visiblity widgets in Flutter
---

# Widget animations

## AnimatedVisibility

For adding some animation use library `package:animated_visibility/animated_visibility.dart`.

Example usage:

```
AnimatedVisibility(
        visible: _isShow,
        enter: fadeIn() + scaleIn(),
        exit: fadeOut() + slideOutHorizontally(),
        child: <content to show/hide>,
      );
```

## List of animations examples

```
[
              _body("Fade", _content(enter: fadeIn(), exit: fadeOut())),
              _body("Scale", _content(enter: scaleIn(), exit: scaleOut())),
              _body(
                  "Fade+Scale",
                  _content(
                      enter: fadeIn() + scaleIn(),
                      exit: fadeOut() + scaleOut())),
              _body("Slide", _content(enter: slideIn(), exit: slideOut())),
              _body(
                  "Slide from top",
                  _content(
                      enter: slideInVertically(
                          initialOffsetY: -1,
                          curve: Curves.fastEaseInToSlowEaseOut),
                      exit: slideOutVertically(
                          targetOffsetY: -1,
                          curve: Curves.fastEaseInToSlowEaseOut))),
              _body(
                  "Slide from bottom",
                  _content(
                      enter: slideInVertically(), exit: slideOutVertically())),
              _body(
                  "Slide from start",
                  _content(
                      enter: slideInHorizontally(initialOffsetX: -1),
                      exit: slideOutHorizontally(targetOffsetX: -1))),
              _body(
                  "Slide from end",
                  _content(
                      enter: slideInHorizontally(),
                      exit: slideOutHorizontally())),
              _body(
                  "Expand Center Vertically",
                  _content(
                      enter: expandVertically(alignment: 0),
                      exit: shrinkVertically(alignment: 0))),
              _body(
                  "Expand Center Horizontally",
                  _content(
                      enter: expandHorizontally(), exit: shrinkHorizontally())),
              _body(
                  "Expand from top",
                  _content(
                      enter: expandVertically(alignment: -1),
                      exit: shrinkVertically(alignment: -1))),
              _body(
                  "Expand from start",
                  _content(
                      enter: expandHorizontally(alignment: -1),
                      exit: shrinkHorizontally(alignment: -1))),
              _body(
                  "Fade+Scale+Slide",
                  _content(
                      enter: fadeIn() + scaleIn() + slideInHorizontally(),
                      exit: fadeOut() + scaleOut() + slideOutHorizontally())),
              _body(
                  "Expand+Fade",
                  _content(
                      enter: expandHorizontally(alignment: 1) +
                          fadeIn(initialAlpha: 0.5),
                      exit: shrinkHorizontally(alignment: 1) +
                          fadeOut(targetAlpha: 0.5))),
            ]
```