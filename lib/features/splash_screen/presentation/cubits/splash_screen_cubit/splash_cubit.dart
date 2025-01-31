import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/splash_screen_repository.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required SplashScreenRepository splashScreenRepository,
  })  : _splashScreenRepository = splashScreenRepository,
        super(const SplashState());

  final SplashScreenRepository _splashScreenRepository;
}
