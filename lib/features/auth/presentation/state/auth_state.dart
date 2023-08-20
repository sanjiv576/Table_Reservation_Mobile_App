import 'package:table_reservation_mobile_app/features/auth/domain/entity/user_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? imageName;

  // static String userRole = '';

  // while logging User data come in userEntity
  static UserEntity? userEntity;

  AuthState({required this.isLoading, this.error, this.imageName});

  // initial values
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      error: null,
      imageName: null,
    );
  }

  AuthState copyWith({bool? isLoading, String? error, String? imageName}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
    );
  }
}
