import 'package:access_token_service/helper/auth_storage.dart';
import 'package:access_token_service/screen/sign_in.dart';
import 'package:access_token_service/screen/success.dart';
import 'package:access_token_service/service/auth_service.dart';
import 'package:access_token_service/service/token_refresh_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  /// Register OAuth storage
  getIt.registerSingleton<AuthStorage>(AuthStorage());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<TokenRefreshService>(TokenRefreshService());

  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: InkWell(
            onTap: () async {
              var token = await getIt.get<AuthStorage>().loadTokenFromCache();

              if (token.isEmpty()) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignInScreen(),
                  ),
                );
              } else {
                print("******************");
                print("Token already exist");
                print("expiresIn : ${token.expiresIn!}");
                print("IssueTimeStamp : ${token.issueTimeStamp}");
                print("ExpireTimeStamp : ${token.expireTimeStamp}");
                print("******************");

                if (token.hasValidAccessToken()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SuccessScreen(),
                    ),
                  );
                } else {
                  print("******************");
                  print("Token expired");
                  print("******************");

                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignInScreen(),
                    ),
                  );
                }
              }
            },
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
