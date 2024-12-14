// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delect/models/candidate.dart';
import 'package:delect/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String privateKey;
  const ElectionInfo({
    Key? key,
    required this.privateKey,
    required this.ethClient,
    required this.electionName,
  }) : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  final addCondidateController = TextEditingController();
  final authorizeVoterController = TextEditingController();
  bool? isAdmin;

  @override
  void initState() {
    checkOwner(widget.privateKey, widget.ethClient).then((value) {
      setState(() {
        isAdmin = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: isAdmin == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: isAdmin!
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          FutureBuilder<List>(
                            future: getNumCandidates(widget.ethClient),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Text(
                                snapshot.data![0].toString(),
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          Text("Total Condidates"),
                        ],
                      ),
                      isAdmin!
                          ? Column(
                              children: [
                                FutureBuilder<List>(
                                  future: getTotalVoters(widget.ethClient),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return Text(
                                      snapshot.data![0].toString(),
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                Text("Total Votes"),
                              ],
                            )
                          : SizedBox()
                    ],
                  ),
                  SizedBox(height: 50),
                  isAdmin!
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    hintText: 'Enter Condidate Name',
                                  ),
                                  controller: addCondidateController,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  addCondidate(addCondidateController.text,
                                      widget.ethClient, widget.privateKey);
                                },
                                child: Container(
                                    width: 50,
                                    height: 55,
                                    child: Center(child: Text("Add"))))
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 25),
                  isAdmin!
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    hintText: 'Enter Voter Address',
                                  ),
                                  controller: authorizeVoterController,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  authorizeVoter(authorizeVoterController.text,
                                      widget.ethClient, widget.privateKey);
                                },
                                child: Container(
                                    width: 50,
                                    height: 55,
                                    child: Center(child: Text("Authorize"))))
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 25),
                  Divider(),
                  FutureBuilder<List<Candidate>>(
                      future: getCandidates(widget.ethClient),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].name),
                                subtitle: Text(
                                    "Votes: ${snapshot.data![index].numVotes}"),
                                trailing: isAdmin!
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () {
                                          vote(index, widget.ethClient,
                                              widget.privateKey);
                                        },
                                        child: Text("Vote")),
                              );
                            });
                      })
                ],
              ),
            ),
    );
  }
}
