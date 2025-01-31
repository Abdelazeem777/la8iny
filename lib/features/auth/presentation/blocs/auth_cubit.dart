import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';

import '../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
  ) : super(AuthState());

  final AuthRepo _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.login(email, password);

      emit(state.copyWith(status: AuthStatus.loaded, user: () => user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> signup({
    required String fullname,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.signup(fullname, email, password);

      emit(state.copyWith(status: AuthStatus.loaded, user: () => user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }
}
