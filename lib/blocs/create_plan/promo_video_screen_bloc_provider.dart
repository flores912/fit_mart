import 'package:fit_mart/blocs/create_plan/promo_video_screen_bloc.dart';
import 'package:flutter/cupertino.dart';

class PromoVideoScreenBlocProvider extends InheritedWidget {
  final bloc = PromoVideoScreenBloc();

  PromoVideoScreenBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PromoVideoScreenBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PromoVideoScreenBlocProvider>()
        .bloc;
  }
}
