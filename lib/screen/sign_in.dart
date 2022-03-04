import 'dart:async';

import 'package:access_token_service/model/token.dart';
import 'package:access_token_service/screen/success.dart';
import 'package:access_token_service/service/auth_service.dart';
import 'package:access_token_service/util/token_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:webview_flutter/webview_flutter.dart';

GetIt getIt = GetIt.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();
  bool isPageLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getWebView(),
    );
  }

  Widget getWebView() {
    var url = '$clientPoolURL/oauth2/authorize?identity_provider=Google&redirect_uri=$redirectURI&response_type=CODE&client_id=$clientID&scope=$scope';

    return Stack(
      children: [
        WebView(
          initialUrl: url,
          userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController.complete(webViewController);
          },
          onPageFinished: (finish) {
            setState(() {
              isPageLoading = false;
            });
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("$redirectURI/?code=")) {
              String code = request.url.substring("$redirectURI/?code=".length);
              completeSignIn(code);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          gestureNavigationEnabled: true,
        ),
        isPageLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Stack(),
      ],
    );
  }

  void completeSignIn(String code) async {
    try {
      Token token = await getIt.get<AuthService>().requestTokenByAuthCode(code);

      print("******************");
      if (token.idToken != null) {
        print(parseJWT(token.idToken!)['full_name']);
        print(parseJWT(token.idToken!)['email']);
        print("expiresIn : ${token.expiresIn!}");
        print("issueTimeStamp : ${token.issueTimeStamp}");
        print("expireTimeStamp : ${token.expireTimeStamp!}");
      }
      print("******************");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const SuccessScreen(),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
