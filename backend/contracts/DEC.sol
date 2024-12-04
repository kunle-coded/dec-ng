// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "./Election.sol";

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
    mapping (uint256 => address) public addressToAdmins;
    mapping (address => bool) public isAdmin;
    uint256 public adminCount;
    address public owner;
    bool public activeElection = false;

    Election public newElection;
    Election[] public elections;



    modifier onlyAdmin () {
        require(isAdmin[msg.sender] || msg.sender == owner, "Unauthorized!");
        _;
    }

    modifier onlyActiveElection(){
        require(activeElection, "No active election");
        _;
    }

   /**
    * @dev Constructor
    * @notice Initializes the contract
    */
    constructor () {
        owner = msg.sender;
    }

    /**
     * @dev Add a new admin
     * @dev Increment admin counter
     * @param _adminAddress Address of admin to add
     */
    function addAdmin(address _adminAddress) public onlyAdmin {
        require(_adminAddress != address(0), "Invalid address");
         addressToAdmins[adminCount] = _adminAddress;
         isAdmin[_adminAddress] = true;

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

    /**
     * @dev Create a new election
     */
    function createElection() public onlyAdmin {
        require(!activeElection, "There is an active election");
        
        activeElection = true;
         newElection = new Election(activeElection);
        elections.push(newElection);  
    }

    /**
     * @dev End current elections
     */
    function endElection () public onlyAdmin onlyActiveElection {
        // end active election;
        newElection.endElection(activeElection);
        activeElection = false;
    }
}