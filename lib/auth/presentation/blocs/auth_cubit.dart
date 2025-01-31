import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:la8iny/auth/presentation/repo/auth_repo.dart';

import '../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
  ) : super(AuthState());

  final AuthRepo _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(state: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = await _authRepository.login(email, password);

      emit(state.copyWith(state: AuthStatus.loaded, user: () => user));
    } catch (e) {
      emit(state.copyWith(state: AuthStatus.error));
    }
  }
}
