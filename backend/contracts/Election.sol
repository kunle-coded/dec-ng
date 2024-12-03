// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

// Handles the specific voting process for one election.
// Manages candidates, voters, votes, and results for that election.
// Self-destructs after the election results are finalized, freeing up resources.

contract Election {

    enum Office { President, Governor, Senator, Representative, Chairman, Councillor }
    enum Region { North, South, East, West }
    mapping (string => bool) public allowedParty;
    mapping (string => bool) public votersToVoted;
    mapping (uint256 => uint256) public candidateToVotes;
    bool public votingStarted = false;

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

    /**
     * @dev restric activity (function call) to voting period
     */
    modifier votingPeriod(){
        require(votingStarted == true, "Voting has ended");
        _;
    }

    /**
     * @dev ensure only voter who has not voted before can vote
     */
    modifier onlyNotVoted(string calldata _voter){
      require(!votersToVoted[_voter], "You already voted");
      _;
    }

     /**
    * @dev Constructor
    * @notice Initializes the contract
    */
    constructor () {
        votingStarted = true;
    }


    /**
     * @dev Function to add party
     * @param _name Party name
     * @param _acronym Party acronym
     */
    function registerParty(string memory _name, string memory _acronym) public votingPeriod {
        require(!allowedParty[_acronym], "Party already exist");
    
        partyList.push(Party({name: _name, acronym: _acronym}));
        allowedParty[_acronym] = true;
    }

     /**
     * @dev Function to add candidate to the candidate list
     * @param _name candidate name
     * @param _dateOfBirth candidate name
     * @param _partyName candidate political party name
     * @param _partyAcronym candidate political party name
     * @param _office candidate office
     * @param _region candidate region
     * @param _politicalExperience candidate political experience
     * @param _education candidate education history
     * @param _professionalExperience candidate professional experience
     * @param _goalsAndPromises candidate goals and promises
     * @param _vision candidate vision
     * @param _pastAchievement candidate past achievements
     */
    function registerCandidate(string memory _name, string memory _dateOfBirth, string memory _partyName, string memory _partyAcronym, Office _office, Region _region, string memory _politicalExperience, string memory _education, string memory _professionalExperience, string memory _goalsAndPromises, string memory _vision, string memory _pastAchievement) public votingPeriod {

        require(allowedParty[_partyAcronym], "Invalid party");

        Candidate memory newCandidate =  Candidate({
        candidateId: candidateList.length,
        name: _name,
        dateOfBirth: _dateOfBirth,
        politicalParty: Party({name: _partyName, acronym: _partyAcronym}),
        office: _office,
        region: _region,
        politicalExperience: _politicalExperience,
        education: _education,
        professionalExperience: _professionalExperience,
        goalsPromises: _goalsAndPromises,
        vision: _vision,
        pastAchievements: _pastAchievement
        });

        // candidates[candidateList.length] = newCandidate;
        candidateList.push(newCandidate);
    }


    /**
     * @dev Get details of a candidate
     * @param _name Candidate name
     */
    function getCandidate(string calldata _name) public view returns(Candidate memory){
        // return candidate
        Candidate memory calledCandidate;
        bool found = false;

        for(uint256 i=0; i<candidateList.length; i++){
            if (keccak256(abi.encodePacked(candidateList[i].name)) == keccak256(abi.encodePacked(_name))) {
        calledCandidate = candidateList[i];
        found = true;
                break; // Exit the loop once the candidate is found
                }
            }
        
            require(found, "Not found");
            return calledCandidate;
        }


        /**
         * @dev Vote a candidate
         * @param _candidateId Id of candidate to vote
         * @param _voter identifier of voter
         */
        function vote(uint256 _candidateId, string calldata _voter) public votingPeriod onlyNotVoted(_voter) {
            candidateToVotes[_candidateId] += 1;
            votersToVoted[_voter] = true;
        }


    /**
     * 
        allowedParty["A"] = true;
        allowedParty["AA"] = true;
        allowedParty["AAC"] = true;
        allowedParty["ADC"] = true;
        allowedParty["ADP"] = true;
        allowedParty["APC"] = true;
        allowedParty["APGA"] = true;
        allowedParty["APM"] = true;
        allowedParty["APP"] = true;
        allowedParty["BP"] = true;
        allowedParty["LP"] = true;
        allowedParty["NRM"] = true;
        allowedParty["NNPP"] = true;
        allowedParty["PDP"] = true;
        allowedParty["PRP"] = true;
        allowedParty["SDP"] = true;
        allowedParty["YPP"] = true;
        allowedParty["YP"] = true;
        allowedParty["ZLP"] = true;
     */
}