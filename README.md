# STREAM TO LIVE DATA
Flutter Streams wrapped for easy use.

## Getting Started
Add Dependency
Add below dependency in pubspec.yaml.
```
dependencies:
    stream_live_data: ^0.0.2
```

* Initialize LiveStream Instance
  You can create instance as below.
```dart
    LiveData<String> liveData = LiveData<String>();
```

*Subscribe to changes
Register to LiveData changes
```dart
    LiveDataToken token = liveData.register((event) {
      print("Rvent Received: $event");
    });
```

*Update Live Data Value
```dart
  liveData.add(newValue);
```

*Clean up
Don't forget to unregister when done
```dart
  liveData.unRegister(token);
or
  token.cancel();
```

Enjoy.