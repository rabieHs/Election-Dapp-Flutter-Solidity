
// SPDX-License-Identifier: MIT
pragma solidity >=0.5 < 0.9.0;

contract Election{
    struct Candidate{
        string name;
        uint numVotes;
    }

    struct Voter{
        string name;
        bool authorized;
        uint whom;
        bool voted;
    }

    address public  owner;
    string public electionName;
    
   

    mapping(address=> Voter)public  voters;

    Candidate[] public  candidates;

    uint public totalVotes;

  

    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    function startElection(string memory _electionName)public{
        owner = msg.sender;
        electionName = _electionName;

    }

    function addCondidate(string memory _candidateName)ownerOnly public{
        candidates.push(Candidate(_candidateName,0));
    }

    function authorizeVoter(address _voterAddress)ownerOnly public {
        voters[_voterAddress].authorized = true;
    }

    function getNumCandidates() public  view returns(uint){
        return candidates.length;
    }

    function getNumVoters()public view returns(uint){
        return totalVotes;
    }

   

    function vote(uint candidateIndex) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        voters[msg.sender].whom = candidateIndex;
        voters[msg.sender].voted = true;
        candidates[candidateIndex].numVotes++;
        totalVotes++;
    }

    function isAdmin() public view returns(bool){
        return owner == msg.sender;
    }

   function electionCreated() public view returns (bool) {
    return bytes(electionName).length > 0;
}


   



    
}
