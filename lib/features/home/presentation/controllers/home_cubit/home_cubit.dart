import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/home_repository.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const HomeState());

  final HomeRepository _homeRepository;
}
