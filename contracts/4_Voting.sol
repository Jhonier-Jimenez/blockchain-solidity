// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Voting
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract Voting {
    // Constructor to set the owner
    constructor() {
        owner = msg.sender;
        deploymentTime = block.timestamp; // Save the time when the contract was deployed
        votingEndTime = deploymentTime + 3 days; // Stablish 3 days to vote
    }

    // Only person allowed to add proposals
    address public owner;

    // Time related
    uint256 public deploymentTime;
    uint256 public votingEndTime;

    // Whitelist of addresses allowed to vote
    mapping(address => bool) public whitelist;

    // Mapping to track if an address has voted
    mapping(address => bool) public hasVoted;

    // Mapping to store proposals with a unique identifier
    //mapping(uint => Proposal) public proposals;

    uint256 proposalsCount;
    Proposal[] public proposals;

    struct Proposal {
        string name;
        uint256 voteCount;
        uint256 id;
    }

    //FUNCTIONS
    // Get proposal count
    function getProposalCount() public view returns (uint256) {
        return proposalsCount;
    }

    // Get all proposals
    function getAllProposals() public view returns (Proposal[] memory) {
        return proposals;
    }

    // Add a proposal
    function addProposal(string memory _name) public onlyOwner {
        proposals.push(Proposal(_name, 0, proposalsCount));
        proposalsCount++;
    }

    // Add address to the whitelist
    function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    // Remove address from the whitelist
    function removeFromWhitelist(address _address) public onlyOwner {
        delete whitelist[_address];
    }

    // Vote for a proposal
    function vote(uint256 _proposalId) public {
        require(block.timestamp < votingEndTime, "Voting period has ended.");
        require(whitelist[msg.sender], "You are not allowed to vote.");
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_proposalId < proposalsCount, "Invalid proposal ID.");
        
        
        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender] = true;
    }

    //MODIFIERS
    // Restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
}
