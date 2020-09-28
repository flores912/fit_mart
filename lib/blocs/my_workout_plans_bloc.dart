import 'package:fit_mart/repository.dart';
import 'package:rxdart/rxdart.dart';

//TODO: FINISH BLOC
class MyWorkoutPlansBloc {
  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _trainer = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _progress = BehaviorSubject<double>();
}
