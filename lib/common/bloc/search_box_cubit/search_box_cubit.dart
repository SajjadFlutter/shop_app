import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class SearchBoxCubit extends Cubit<bool> {
  SearchBoxCubit() : super(true);

  void changeVisibility(bool newValue) => emit(newValue);
}
