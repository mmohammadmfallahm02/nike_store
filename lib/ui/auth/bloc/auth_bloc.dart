import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/constants/exception.dart';
import 'package:nike/data/repo/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoginMode;
  final IAuthRepository authRepository;
  AuthBloc(this.authRepository, {this.isLoginMode = true})
      : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonIsClicked) {
          emit(AuthLoading(isLoginMode));

          if (isLoginMode) {
            await authRepository.login(event.username, event.password);
            emit(AuthSuccess(isLoginMode));
          } else {
            await authRepository.signUp(event.username, event.password);
            emit(AuthSuccess(isLoginMode));
          }
        }
        if (event is AuthModeChangeIsClicked) {
          isLoginMode = !isLoginMode;
          emit(AuthInitial(isLoginMode));
        }
      } on DioError catch (e) {
        emit(AuthError(AppException(
            message: e.response?.data['message'] ?? AppException())));
      }
    });
  }
}
