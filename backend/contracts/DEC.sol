// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

/**
 * @title DEC-NG Voting DApp
 * @author Adekunle Adesokan
 * @notice A basic decentralized voting system
 */

// Acts as the central authority.
// Manages the creation, tracking, and overall governance of elections.
// Keeps records of all elections and their results.
// Responsible for authorizing and deploying individual election contracts.

contract DEC {

    enum Office { President, Governor, Senator, Representative, Chairman, Councillor }
    enum Region { North, South, East, West }
    mapping (uint256 => Candidate) private candidates;
    mapping (string => uint256) private candidateToVotes;
    mapping (string => bool) public allowedParty;
    mapping (uint256 => address) public addressToAdmins;
    uint256 public adminCount;
    address public admin;
    address public owner;

    Party [] public partyList;
    Candidate [] public candidateList;

    struct Party {
        string name;
        string acronym;
    }
    
    struct Candidate {
        uint256 candidateId;
        string name;
        string dateOfBirth;
        Party politicalParty;
        Office office;
        Region region;
        string politicalExperience;
        string education;
        string professionalExperience;
        string goalsPromises;
        string vision;
        string pastAchievements;

    }


    modifier OnlyAdmin () {
        require(msg.sender == admin || msg.sender == owner, "Unauthorized!");
        _;
    }

   /**
    * @dev Constructor
    * @notice Initializes the contract
    * @param _admin the address of the contract admin
    */
    constructor (address _admin) {
        require(_admin != address(0), "Invalid address");
        admin = _admin;
        owner = address(this);

    }

    /**
     * @dev Add a new admin
     * @dev Increment admin counter
     * @param _adminAddress Address of admin to add
     */
    function addAdmin(address _adminAddress) public {
        require(msg.sender == owner);
        require(_adminAddress != address(0), "Invalid address");
         addressToAdmins[adminCount] = _adminAddress;

         adminCount++;
    }

    /**
     * @dev Get list of all the admins
     */
    function getAllAdmin() public view returns(address[] memory){
        address [] memory admins = new address[](adminCount);

        for(uint256 i=0; i<adminCount; i++){
            admins[i] = addressToAdmins[i];
        }

        return admins;
    }


   
}