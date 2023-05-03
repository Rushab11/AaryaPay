import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:aaryapay/repository/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository authRepo = AuthenticationRepository();
  LoginBloc() : super((const LoginState())) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginFormSubmitted>(_onLoginFormSubmitted);
    on<ResetLogin>(_onResetLogin);
    add(ResetLogin());
  }

  void _onLoginEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onLoginFormSubmitted(
      LoginFormSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isEmailValid) {
      return emit(state.copyWith(errorText: "Invalid Username!"));
    }
    if (!state.isPasswordValid) {
      return emit(state.copyWith(errorText: "Invalid Password!"));
    }

    try {
      final loginResponse =
          await authRepo.login(email: state.email, password: state.password);

      if (loginResponse["verification"] == false) {
        emit(state.copyWith(verificationStatus: VerificationStatus.unverified));
      } else if (loginResponse["two_fa_required"] == true) {
        emit(state.copyWith(twoFARequired: true));
      } else {
        emit(state.copyWith(
            loginSucess: true,
            verificationStatus: VerificationStatus.verified));
      }
    } catch (e) {
      emit(state.copyWith(errorText: "Email or Password incorrect!"));
    }
    //send login request and cchange parameters that way
  }

  void _onResetLogin(ResetLogin event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
