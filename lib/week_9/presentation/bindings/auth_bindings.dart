import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:luar_sekolah_lms/week_9/data/datasources/firebase_auth_datasource.dart';
import 'package:luar_sekolah_lms/week_9/data/repositories/auth_repository_impl.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/get_current_user.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/login_with_email.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/logout.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/register_with_email.dart';
import 'package:luar_sekolah_lms/week_9/presentation/controller/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    //Firebase Auth datasource
    Get.lazyPut<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(firebaseAuth: FirebaseAuth.instance),
    );

    // Repository
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(Get.find<FirebaseAuthDataSource>()),
    );

    // Usecases
    Get.lazyPut<LoginWithEmail>(
      () => LoginWithEmail(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut<RegisterWithEmail>(
      () => RegisterWithEmail(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut<Logout>(() => Logout(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut<GetCurrentUser>(
      () => GetCurrentUser(Get.find<AuthRepositoryImpl>()),
    );

    // Controller
    Get.put<AuthController>(
      AuthController(
        loginWithEmail: Get.find<LoginWithEmail>(),
        registerWithEmail: Get.find<RegisterWithEmail>(),
        logoutUseCase: Get.find<Logout>(),
        getCurrentUser: Get.find<GetCurrentUser>(),
      ),
    );
  }
}
