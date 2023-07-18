part of '../stream_live_data.dart';


class LiveDataBuilder<T> extends StatelessWidget {
  final T? initialData;
  final AsyncWidgetBuilder<T> builder;
  final LiveData<T>? liveData;

  const LiveDataBuilder({
    Key? key,
    this.initialData,
    this.liveData,
    required this.builder,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(key: key,
      builder: builder,
      stream: liveData?.asStream(),
      initialData: initialData?? liveData?.value);
  }
}
