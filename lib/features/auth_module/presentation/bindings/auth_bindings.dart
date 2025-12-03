import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:luar_sekolah_lms/features/auth_module/data/datasources/firebase_auth_datasource.dart';
import 'package:luar_sekolah_lms/features/auth_module/data/datasources/user_profile_remote_data_source.dart';

import 'package:luar_sekolah_lms/features/auth_module/data/repositories/auth_repository_impl.dart';
import 'package:luar_sekolah_lms/features/auth_module/data/repositories/user_profile_repository_impl.dart';

import 'package:luar_sekolah_lms/features/auth_module/domain/repositories/auth_repository.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/repositories/user_profile_repository.dart';

import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/create_user_profile.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/get_current_user.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/get_user_profile.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/login_with_email.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/logout.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/register_with_email.dart';

import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // --------------------
    // Firebase Auth
    // --------------------
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance);

    Get.lazyPut<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(firebaseAuth: Get.find<FirebaseAuth>()),
    );

    // Repository untuk Auth → daftar sebagai interface AuthRepository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<FirebaseAuthDataSource>()),
    );

    // Usecase Auth
    Get.lazyPut<LoginWithEmail>(
      () => LoginWithEmail(Get.find<AuthRepository>()),
    );

    Get.lazyPut<RegisterWithEmail>(
      () => RegisterWithEmail(Get.find<AuthRepository>()),
    );

    Get.lazyPut<Logout>(() => Logout(Get.find<AuthRepository>()));

    Get.lazyPut<GetCurrentUser>(
      () => GetCurrentUser(Get.find<AuthRepository>()),
    );

    // --------------------
    // Firestore + User Profile (role student/admin)
    // --------------------
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance);

    Get.lazyPut<UserProfileRemoteDataSource>(
      () => UserProfileRemoteDataSourceImpl(Get.find<FirebaseFirestore>()),
    );

    Get.lazyPut<UserProfileRepository>(
      () => UserProfileRepositoryImpl(Get.find<UserProfileRemoteDataSource>()),
    );

    Get.lazyPut<CreateUserProfileUseCase>(
      () => CreateUserProfileUseCase(Get.find<UserProfileRepository>()),
    );

    Get.lazyPut<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(Get.find<UserProfileRepository>()),
    );

    // --------------------
    // AuthController
    // --------------------
    Get.put<AuthController>(
      AuthController(
        loginWithEmail: Get.find<LoginWithEmail>(),
        registerWithEmail: Get.find<RegisterWithEmail>(),
        logoutUseCase: Get.find<Logout>(),
        getCurrentUser: Get.find<GetCurrentUser>(),
        createUserProfileUseCase: Get.find<CreateUserProfileUseCase>(),
        getUserProfileUseCase: Get.find<GetUserProfileUseCase>(),
      ),
      permanent: true,
    );
  }
}
