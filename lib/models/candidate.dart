class Candidate {
  final String name;
  final int numVotes;

  Candidate({required this.name, required this.numVotes});

  factory Candidate.fromWeb3(List<dynamic> response) {
    return Candidate(
      name: response[0] as String,
      numVotes: (response[1] as BigInt).toInt(),
    );
  }
}
