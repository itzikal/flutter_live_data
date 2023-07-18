part of '../stream_live_data.dart';

class LiveDataToken{
  final StreamSubscription _subscription;

  LiveDataToken(StreamSubscription subscription) : _subscription = subscription;

  Future<void> cancel() async{
    await _subscription.cancel();
  }
}
