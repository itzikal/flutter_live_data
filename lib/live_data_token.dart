import 'dart:async';

class LiveDataToken{
  final StreamSubscription _subscription;

  LiveDataToken(StreamSubscription subscription) : _subscription = subscription;

  Future<void> cancel() async{
    await _subscription.cancel();
  }
}
