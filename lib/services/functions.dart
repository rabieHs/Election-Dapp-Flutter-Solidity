import 'package:delect/models/candidate.dart';
import 'package:delect/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = deployedContractAddress;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(
  String funcName,
  List<dynamic> args,
  Web3Client ethClient,
  String privateKey,
) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result = await ethClient.sendTransaction(
      chainId: null,
      fetchChainIdFromNetworkId: true,
      credentials,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args));
  return result;
}

Future<String> startElection(
    String electionName, Web3Client client, String privateKey) async {
  final response =
      await callFunction('startElection', [electionName], client, privateKey);
  print("Election Started Successfully");
  return response;
}

Future<String> addCondidate(
    String candidateName, Web3Client client, String privateKey) async {
  final response =
      await callFunction('addCondidate', [candidateName], client, privateKey);
  print("Candidate added Successfully");
  return response;
}

Future<String> authorizeVoter(
    String address, Web3Client client, String privateKey) async {
  final response = await callFunction(
      'authorizeVoter', [EthereumAddress.fromHex(address)], client, privateKey);
  print("Voter Authorized Successfully");
  return response;
}

Future<List<dynamic>> ask(
    String functionName, List<dynamic> args, Web3Client client) async {
  final contract = await loadContract();
  final ethFunction = await contract.function(functionName);
  final result =
      client.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<List> getNumCandidates(Web3Client client) async {
  final response = await ask("getNumCandidates", [], client);
  print("Election Started Successfully");
  return response;
}

Future<List> getTotalVoters(Web3Client client) async {
  final response = await ask("getNumVoters", [], client);
  print("Election Started Successfully");
  return response;
}

Future<List<Candidate>> getCandidates(
  Web3Client client,
) async {
  print("fetching candidates");
  List candidatesData = await getNumCandidates(client);
  int numCandidates = (candidatesData[0] as BigInt).toInt();

  //print("num of candidates fetched successfully $numCandidates");
  print("num of candidates fetched successfully $candidatesData");

  List<Candidate> candidates = [];

  for (int i = 0; i < numCandidates; i++) {
    final response = await ask("candidates", [BigInt.from(i)], client);
    print("candidates fetched successfully $response");
    candidates.add(
      Candidate.fromWeb3(response),
    );
  }
  return candidates;
}

Future<String> vote(
    int candidateIndex, Web3Client client, String privateKey) async {
  final result = await callFunction(
      "vote", [BigInt.from(candidateIndex)], client, privateKey);
  print("vote counted successfully");
  return result;
}

Future<bool> checkOwner(String addressToCheck, Web3Client client) async {
  try {
    // Get the contract
    final result = await ask('owner', [], client);

    // Extract the owner address from the result
    String ownerAddress = (result[0] as EthereumAddress).hex;

    // Compare the addresses (convert both to lowercase to ensure case-insensitive comparison)
    bool isOwner = ownerAddress.toLowerCase() ==
        EthPrivateKey.fromHex(addressToCheck.toLowerCase())
            .address
            .hex
            .toLowerCase();

    print('Contract Owner Address: $ownerAddress');
    print('Checked Address: $addressToCheck');
    print('Is Owner: $isOwner');

    return isOwner;
  } catch (e) {
    print('Error checking owner: $e');
    return false;
  }
}

Future<String> getElectionName(Web3Client client) async {
  final response = await ask("electionName", [], client);
  print("election name $response");
  return response[0] as String;
}

Future<bool> electionCreated(Web3Client client) async {
  final response = await ask("electionCreated", [], client);
  print("isAdmin checked successfully $response");
  return response[0] as bool;
}
