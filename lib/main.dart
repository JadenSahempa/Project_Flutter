import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/utils/shared_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper.init(); // WAJIB
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final loggedIn = StorageHelper.instance.isLoggedIn();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luarsekolah LMS',
      theme: ThemeData(primarySwatch: Colors.purple),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: loggedIn ? RouteNames.shell : RouteNames.login,
    );
  }
}
