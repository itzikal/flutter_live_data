import 'dart:async';
import 'live_data_token.dart';

class LiveData<T> {
  StreamController<T>? _controller;
  LiveDataToken? _connectedToken;
  final List<LiveDataToken> _registeredLiveData = <LiveDataToken>[];
  T? _value;
  T? get value { return _value; }

  LiveData({T? initValue}) {
    _value = initValue;
  }

  LiveData.fromStream(Stream<T> stream){
    _connectedToken = LiveDataToken(stream.listen((event) {add(event);}));
  }

  LiveDataToken register(void Function(T event) onData) {
     _createController();
     return LiveDataToken(_controller!.stream.listen(onData));
  }

  Future<void> unRegister(LiveDataToken token) async{
    await token.cancel();
  }

  void add(T value){
    _value = value;
    var controller = _controller;
    if((controller?.isClosed ?? true)){
      return;
    }
    controller?.add(value);
  }

  LiveData<R> map<R>(R Function(T?) to) {
    _createController();
    LiveData<R> mappedLiveData = LiveData<R>(initValue: to(_value));
    mappedLiveData._createController();
    var token = register((event) => mappedLiveData._controller?.add(to(event)));
    mappedLiveData._connectedToken = token;
    _registeredLiveData.add(token);

    return mappedLiveData;
  }

  LiveData<R> mapAsync<R>(FutureOr<R> Function(T event) to) {
    _createController();
    LiveData<R> mappedLiveData = LiveData<R>();
    mappedLiveData._createController();
    var token = register((event) async => mappedLiveData._controller?.add(await to(event)));
    mappedLiveData._connectedToken = token;
    _registeredLiveData.add(token);

    return mappedLiveData;
  }

  dispose(){
    _registeredLiveData.forEach((element) => element.cancel());
    _registeredLiveData.clear();
    _connectedToken?.cancel();
    _connectedToken = null;
    _controller?.close();
    _controller = null;
  }

  void _createController(){
    if(_controller == null){
      _controller = StreamController<T>.broadcast();
      _controller?.onCancel = (){
        if(_controller?.hasListener == false){
          var controller = _controller;
          _controller = null;
          controller?.close();

        }
      };
    }
  }
}
