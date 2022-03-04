import 'dart:async';

import 'package:access_token_service/helper/auth_storage.dart';
import 'package:access_token_service/service/auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class TokenRefreshService {
  Timer? _timer;

  TokenRefreshService();

  void startTokenRefreshProcess() async {
    var cachedToken = await getIt.get<AuthStorage>().loadTokenFromCache();

    print("******************");
    print("******************");
    print("Access token refreshing circle started !!!");
    print("******************");
    print("******************");

    /// Stop if exist already running process
    stopTokenRefreshProcess();

    if (!cachedToken.isEmpty()) {
      /// (cachedToken.expiresIn! / 3) = 1200s
      /// The token will be refreshed every 20 min
      _timer = Timer.periodic(Duration(seconds: cachedToken.expiresIn! ~/ 3), (timer) async {
        print("******************");
        print("******************");
        print("Access token refreshed !!!");
        print("******************");
        print("******************");

        await getIt.get<AuthService>().requestTokenByRefreshToken(cachedToken.refreshToken!);
      });
    }
  }

  void stopTokenRefreshProcess() {
    /// If lost the internet connection, timer should be stopped
    /// If the internet connection is lost, the timer should stop, and the refresh token process should restart when the connection is restored.
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      print("Token refresh timer stopped !!!");
    }
  }
}
