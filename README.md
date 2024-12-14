# Flutter Blockchain Election App

This is a decentralized election application built with Flutter, Solidity, and blockchain technology. The app allows users to create elections, add candidates, authorize voters, and cast votes securely using blockchain.

## Features

- **Start Election**: Initiate an election with a custom name.
- **Add Candidates**: Admins can add candidates to the election.
- **Authorize Voters**: Admins can authorize voters using their Ethereum addresses.
- **Cast Votes**: Authorized users can vote for candidates.
- **View Results**: See the total votes for each candidate.

## Tech Stack

- **Frontend**: Flutter
- **Smart Contracts**: Solidity
- **Blockchain Interaction**: Web3dart
- **Ethereum Network**: Infura (Holesky Testnet)

## Prerequisites

1. Install [Flutter](https://flutter.dev/docs/get-started/install).
2. Install [Node.js](https://nodejs.org/).
3. Set up an Infura project to connect to the Ethereum network.
4. Install the Remix IDE for smart contract development.

## Setup

### Smart Contract Deployment

1. Open the `Election.sol` contract in Remix IDE.
2. Compile the contract.
3. Deploy the contract on the Ethereum testnet (e.g., Holesky) using MetaMask.
4. Copy the deployed contract address and ABI.
5. Replace the `deployedContractAddress` and `abi.json` in the Flutter project accordingly.

### Flutter Project

1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the project directory:
   ```bash
   cd <project_directory>
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Update the `infuraUrl` in the code with your Infura project endpoint.
5. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Login**: Enter your private key to log in.
2. **Start Election**: Input the election name and start the election.
3. **Admin Actions**:
   - Add candidates.
   - Authorize voters.
4. **Voter Actions**:
   - View the list of candidates.
   - Vote for your preferred candidate.
5. **Results**: View the number of votes for each candidate.

## Project Structure

- **models/**: Contains data models like `Candidate`.
- **services/**: Contains blockchain interaction functions.
- **views/**: Contains Flutter UI components and pages.
- **utils/**: Contains constants like the contract address and Infura URL.

## Smart Contract Functions

### Public Functions

- `startElection(string electionName)`: Starts a new election.
- `addCandidate(string name)`: Adds a candidate.
- `authorizeVoter(address voter)`: Authorizes a voter.
- `vote(uint candidateIndex)`: Casts a vote for a candidate.

### View Functions

- `getNumCandidates()`: Returns the total number of candidates.
- `getNumVoters()`: Returns the total number of voters.
- `candidates(uint index)`: Returns candidate details (name and votes).
- `electionName()`: Returns the election name.

## Dependencies

- `flutter`
- `web3dart`
- `walletconnect_dart`
- `http`

## Screenshots

Add screenshots of your app here for better visualization.

## Future Improvements

- Add user authentication using WalletConnect.
- Enhance UI for a more seamless experience.
- Extend functionality to support multiple elections.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

- Thanks to the [Flutter](https://flutter.dev/) and [Solidity](https://soliditylang.org/) communities for their excellent resources.

## Contact

For questions or support, contact the developer at [rabiehoussaini@gmail.com].
