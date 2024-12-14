// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:delect/services/functions.dart';
import 'package:delect/utils/constants.dart';

import 'election_info.dart';

class Home extends StatefulWidget {
  String privateKey;
  Web3Client ethClient;
  Home({
    Key? key,
    required this.ethClient,
    required this.privateKey,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                hintText: 'Enter Election Name',
              ),
              controller: controller,
            ),
            SizedBox(height: 15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await startElection(
                        controller.text, widget.ethClient!, widget.privateKey);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ElectionInfo(
                            privateKey: widget.privateKey,
                            ethClient: widget.ethClient,
                            electionName: controller.text)));
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: 45,
                    child: Center(child: Text("Start Election"))))
          ],
        ),
      ),
    );
  }
}
