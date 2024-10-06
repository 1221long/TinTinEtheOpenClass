// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {

    uint256 private startTime;
    uint256 private endTime;

    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames, uint256 startTime_, uint256 endTime_) {
        require(endTime_ > startTime_, "Endtime must greater than the starttime.");
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        startTime = startTime_;
        endTime = endTime_;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0, "The voter should not have the weight.");
        voters[voter].weight = 1;
    }

    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote.");
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while(voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];
        require(delegate_.weight >= 1, "To voter should have the right to vote.");

        sender.voted = true;
        sender.delegate = to;

        if(delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Out of vote time range.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

    function setVoterWeight(address voter, uint weight) external {
        require(msg.sender == chairperson, "Only constructor can use this function.");
        require(weight > 0, "New weight must greater than 0.");
        Voter storage voter_ = voters[voter];
        require(voter_.weight != 0, "Has no right to vote.");
        require(!voter_.voted, "The voter already voted.");
        
        if(voter_.delegate != address(0)) {
            Voter storage delegater_ = voters[voter_.delegate];
            delegater_.weight += weight - voter_.weight;
        }
        voter_.weight = weight;              
    } 

}
