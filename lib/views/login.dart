import 'package:delect/services/functions.dart';
import 'package:delect/views/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/constants.dart';
import 'election_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ethClient = Web3Client(infuraUrl, Client());

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Election'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                hintText: 'Authenticate',
              ),
              controller: controller,
            ),
            SizedBox(height: 15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    final privateKey = controller.text;

                    final electionName = await getElectionName(ethClient);
                    if (electionName.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ElectionInfo(
                              privateKey: controller.text,
                              ethClient: ethClient,
                              electionName: electionName)));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Home(
                                privateKey: controller.text,
                                ethClient: ethClient,
                              )));
                    }
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: 45,
                    child: Center(child: Text("Authenticate"))))
          ],
        ),
      ),
    );
  }
}
