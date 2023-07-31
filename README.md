# Clima Weather

Some self learner project.

## How to navigate to debug mode

```sh
flutter run
```

## How to build your App

```sh
flutter build apk --split-per-abi
```

## Example about l10n applyer

```dart
// Context support
AppLocalization t = Applocalization.of(context);

return Scaffold(appBar: AppBar(
    title: Text(t.translate("settings.appBar.title")),
)
    (), body: Column(children: [
    Text(t.translate("welcome")),
    
]))
```