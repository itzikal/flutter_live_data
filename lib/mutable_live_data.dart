part of 'live_data.dart';

class MutableLiveData<T> extends LiveData<T>{

  MutableLiveData({required T initValue}) :super(initValue:  initValue);

  void addError(Object error){
    _controller?.addError(error);
  }
  /// post a new value.
  /// will notify sll registered listeners, if exist
  /// value will be stored localy
  /// [value] new value to post.
  void add(T value){
    _value = value;
    var controller = _controller;
    if((controller?.isClosed ?? true)){
      return;
    }
    controller?.add(value);
  }

  void notifyDataChanged(){
    _controller?.add(_value);
  }

  /// close all streams and listeners
  @override
  Future<void> dispose() async{
    super.dispose();
    _controller?.close();
    _controller = null;
  }

  @override
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