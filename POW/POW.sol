// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

contract ManUnitedPlayersPOE {

    struct PlayerData {
        string fullname;
        string nationality;
        string position;
        uint shirtNumber;
    }

    mapping(string => bool) internal checkPlayer;
    mapping(string => PlayerData) internal playerDataToString;
    mapping(string => PlayerData) public newClubTransfer;

    PlayerData[] playersRecords;

    address admin;

    constructor(address _admin) {
        admin = _admin;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can call this function!");
        _;
    }

        // function to add player

    function addPlayer(
        string memory _fullname, string memory _nationality, string memory _position, uint _shirtNumber
        ) public onlyAdmin{
            PlayerData memory newPlayer = PlayerData(_fullname, _nationality, _position, _shirtNumber);
            playersRecords.push(newPlayer);

            playerDataToString[_fullname] = newPlayer;

        }

        // function to proof player exist 
        // get player record by string

    function getPlayer(string memory _fullname) external view returns(PlayerData memory) {
       return playerDataToString[_fullname];
    }

        // function to transfer player out of the club to a new club
    
    function transferPlayer(string memory playerName, string memory currentClub) external onlyAdmin returns(bool) {
        // push player into newClub
        newClubTransfer[playerName] = playerDataToString[playerName];
        
        // remove player from old club
        delete playerName[playerDataToString];

        //string to the array
        
    
        return true;
    }

}