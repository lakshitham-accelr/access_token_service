import 'package:access_token_service/helper/auth_storage.dart';
import 'package:access_token_service/model/outlet.dart';
import 'package:access_token_service/service/sample_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  List<Outlet>? outlets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Success !!!"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  outlets = null;
                });

                var token = await getIt.get<AuthStorage>().loadTokenFromCache();
                var tempOutlets = await fetchOutlets(token.idToken!);

                setState(() {
                  outlets = tempOutlets;
                });
              },
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                child: const Text(
                  'Get Data',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            (outlets != null) ? JsonViewer(outlets!.map((e) => e.toJson().toString()).toList()) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
